// ignore_for_file: avoid_print, use_build_context_synchronously, depend_on_referenced_packages, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:get/get.dart';
import 'package:nlytical/Vendor/payment/payment_google_pay.dart';
import 'package:nlytical/Vendor/payment/paypal_payment.dart';
import 'package:nlytical/Vendor/screens/add_store.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/controllers/vendor_controllers/payment_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/login_controller.dart';
import 'package:nlytical/models/vendor_models/subscription_plan_model.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/html_tag_icon.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:uuid/uuid.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:developer' as developer;

class SubscriptionSceen extends StatefulWidget {
  const SubscriptionSceen({super.key});

  @override
  State<SubscriptionSceen> createState() => _SubscriptionSceenState();
}

class _SubscriptionSceenState extends State<SubscriptionSceen> {
  LoginContro1 loginContro = Get.put(LoginContro1());
  GetprofileContro getprofilecontro = Get.put(GetprofileContro());
  PaymentController paymentController = Get.find();

  Pay? payClient;
  // Google Pay Event Channel
  StreamSubscription? _paymentResultSubscription;
  static const _eventChannel = EventChannel(
    'plugins.flutter.io/pay/payment_result',
  );

  late final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _available = false;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  String convertHtmlToText(String htmlString) {
    var document = parser.parse(htmlString);

    return document.body!.text;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginContro.subscriptionPlanDetails(isHome: false);
      getprofilecontro.updateProfileOne();
      if (Platform.isIOS) {
        initializeIAP();
      } else {
        // Setup Google Pay result listener (very important!)
        _paymentResultSubscription = _eventChannel
            .receiveBroadcastStream()
            .listen(
              (dynamic event) {
                try {
                  final result =
                      jsonDecode(event as String) as Map<String, dynamic>;
                  developer.log('Google Pay result received: $result');
                  _handleGooglePayResult(result);
                } catch (e) {
                  developer.log('Error parsing Google Pay result: $e');
                }
              },
              onError: (error) {
                developer.log('Google Pay stream error: $error');
              },
              cancelOnError: false,
            );

        _initializeGooglePay();
      }
    });
    loginContro.isPaymentSuccessLoading.value = false;
    super.initState();
  }

  Future<void> initializeIAP() async {
    final bool available = await _iap.isAvailable();
    setState(() {
      _available = available;
    });

    if (available) {
      const Set<String> ids = {
        'startup_plan_nlytical',
        'business_plan_nlytical',
        'enterprise_plan_nlytical',
        'yearly_plan_nlytical',
      };
      final ProductDetailsResponse response = await _iap.queryProductDetails(
        ids,
      );
      setState(() {
        _products = response.productDetails;
        // Optionally sort _products if needed, e.g., based on price or ID
        _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
      });
    }

    // Listen to purchase updates
    _purchaseSubscription = _iap.purchaseStream.listen((purchases) {
      _handlePurchases(purchases);
    });
  }

  void _handlePurchases(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      if (purchase.status == PurchaseStatus.purchased
      // ||
      //     purchase.status == PurchaseStatus.restored
      ) {
        // Verify the purchase on your server if needed (send purchase.verificationData.serverVerificationData)
        // For example, call an API to validate the receipt

        // Assuming verification succeeds, call payment success
        final success = await loginContro.paymentSuccess(
          paymentType: "apple_in_app_purchase",
          appleIAPPlan: purchase.productID,
        );

        if (success) {
          paymentDialogSucess();
          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
            if (isDemo == "false") {
              if (isStoreGlobal == 0) {
                Get.to(() => AddStore())!.then((_) {
                  setState(() {});
                });
              } else {
                Get.back();
              }
            }
          });
          setState(() {});
        }
      } else if (purchase.status == PurchaseStatus.error) {
        snackBar('Purchase failed: ${purchase.error?.message}');
      }
    }
  }

  Future<void> _purchaseProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    try {
      await _iap.buyNonConsumable(
        purchaseParam: purchaseParam,
      ); // For subscriptions
    } catch (e) {
      snackBar('Failed to initiate purchase: $e');
    }
  }

  Future<void> _initializeGooglePay() async {
    try {
      final configJson = generateGooglePayConfig(
        environment:
            paymentController.model.value.data!.googlePay!.mode!
                    .toString()
                    .toLowerCase() ==
                'test'
            ? "TEST"
            : "PRODUCTION",
        merchantId: paymentController.model.value.data!.googlePay!.publicKey!,
        merchantName: paymentController.model.value.data!.googlePay!.secretKey!,
        countryCode: paymentController.model.value.data!.googlePay!.countryCode!
            .toUpperCase(),
        currencyCode: paymentController
            .model
            .value
            .data!
            .googlePay!
            .currencyCode!
            .toUpperCase(),
      );

      payClient = Pay({
        PayProvider.google_pay: PaymentConfiguration.fromJsonString(configJson),
      });

      developer.log("Google Pay client initialized successfully");
    } catch (e) {
      developer.log("Failed to initialize Google Pay: $e");
    }
  }

  // Handle Google Pay result (success, error, cancel)
  Future<void> _handleGooglePayResult(Map<String, dynamic> result) async {
    setState(() {
      loginContro.isPaymentSuccessLoading.value = true;
    });

    try {
      // Close dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // You can extract token here if needed
      // final token = result['paymentMethodData']?['tokenizationData']?['token'];

      final success = await loginContro.paymentSuccess(
        paymentType: "google pay",
      );

      if (success) {
        paymentDialogSucess();

        await Future.delayed(const Duration(seconds: 2));

        Get.back();

        if (isDemo == "false") {
          if (isStoreGlobal == 0) {
            await Get.to(() => AddStore())?.then((_) => setState(() {}));
          } else {
            Get.back();
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment verification failed")),
        );
      }
    } catch (e) {
      developer.log("Google Pay success handling error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        loginContro.isPaymentSuccessLoading.value = false;
      });
    }
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    _paymentResultSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Subscription"),
            style: AppTypography.h1(
              context,
            ).copyWith(color: Appcolors.appTextColor.textWhite),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: innerContainer(
        child: SingleChildScrollView(
          child: Obx(() {
            final subscriptionId = getprofilecontro
                .updatemodel1
                .value!
                .subscriptionDetails!
                .subscriptionId;

            final sortedList = List<SubscriptionDetail>.from(
              loginContro.subscriptionDetailsData,
            );
            sortedList.sort((a, b) {
              if (a.id.toString() == subscriptionId) return -1;
              if (b.id.toString() == subscriptionId) return 1;
              return 0;
            });
            return Column(
              children: [
                sizeBoxHeight(30),
                Container(
                  height: getProportionateScreenHeight(155),
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolors.appPriSecColor.appPrimblue.withValues(
                      alpha: 0.17,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(107),
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: themeContro.isLightMode.value
                              ? Appcolors.white
                              : Appcolors.darkGray,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CURRENT PLAN",
                                      style: AppTypography.text10Medium(
                                        context,
                                      ).copyWith(fontSize: 11),
                                    ),
                                    Text(
                                      (subscribedUserGlobal == 0 &&
                                              userRole == "user")
                                          ? "No Subscription"
                                          : userRole == "user"
                                          ? "No Subscription"
                                          : (subscribedUserGlobal == 0 &&
                                                userRole == "vendor")
                                          ? "Expired Plan"
                                          : subscribedUserGlobal == 0
                                          ? "Expired Plan"
                                          : getprofilecontro
                                                .updatemodel1
                                                .value!
                                                .subscriptionDetails!
                                                .planName!,
                                      style: AppTypography.text14Medium(context)
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Appcolors
                                                .appPriSecColor
                                                .appPrimblue,
                                          ),
                                    ),
                                  ],
                                ),
                                Text(
                                  subscribedUserGlobal == 0
                                      ? "\$0"
                                      : "\$${getprofilecontro.updatemodel1.value!.subscriptionDetails!.price!}",
                                  style: AppTypography.h1(context).copyWith(
                                    fontSize: 25,
                                    color: Appcolors.appPriSecColor.appPrimblue,
                                  ),
                                ),
                              ],
                            ),
                            sizeBoxHeight(10),
                            Text(
                              (subscribedUserGlobal == 0 && userRole == "user")
                                  ? "Validity: No Subscription"
                                  : userRole == "user"
                                  ? "Validity: No Subscription"
                                  : (subscribedUserGlobal == 0 &&
                                        userRole == "vendor")
                                  ? "Validity: Expired"
                                  : subscribedUserGlobal == 0
                                  ? "Validity: Expired"
                                  : "Validity: ${formatCustomDate(getprofilecontro.updatemodel1.value!.subscriptionDetails!.expireDate.toString())}",

                              //${formatCustomDate(getprofilecontro.updatemodel1.value!.subscriptionDetails!.startDate.toString())} -
                              style: AppTypography.text10Medium(context)
                                  .copyWith(
                                    fontSize: 11,
                                    color: subscribedUserGlobal == 0
                                        ? Colors.red
                                        : themeContro.isLightMode.value
                                        ? Appcolors.appTextColor.textBlack
                                        : Appcolors.appTextColor.textWhite,
                                  ),
                            ),
                          ],
                        ).paddingOnly(left: 15, right: 15, top: 15, bottom: 5),
                      ).paddingOnly(left: 4, right: 4, top: 4),
                      sizeBoxHeight(10),
                      Text(
                        subscribedUserGlobal == 0
                            ? "Subscribe Now To View The Vendor"
                            : "Your ${getprofilecontro.updatemodel1.value!.subscriptionDetails!.planName!} is activated",
                        textAlign: TextAlign.center,
                        style: AppTypography.text10Medium(
                          context,
                        ).copyWith(fontWeight: FontWeight.w500, fontSize: 11),
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 10),
                sizeBoxHeight(25),
                subscribedUserGlobal == 1
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Other Plans To Explore",
                          style: AppTypography.text16(
                            context,
                          ).copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                      ).paddingSymmetric(horizontal: 20)
                    : SizedBox.shrink(),
                subscribedUserGlobal == 1
                    ? sizeBoxHeight(15)
                    : SizedBox.shrink(),
                loginContro.isSubscriptionDetailLoading.value
                    ? Column(children: [sizeBoxHeight(200), commonLoading()])
                    : Platform.isIOS
                    ? _buildIOSPlans() // New method for iOS plans
                    : sortedList.isEmpty
                    ? Column(
                        children: [
                          sizeBoxHeight(200),
                          Center(
                            child: Text("Subscription Plan not available"),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: Get.height * 0.56,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: sortedList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Container(
                                height: Get.height * 0.54,
                                width: Get.width * 0.9,
                                decoration: BoxDecoration(
                                  color: themeContro.isLightMode.value
                                      ? Appcolors.white
                                      : Appcolors.darkGray,
                                  border: Border.all(
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.appPriSecColor.appPrimblue
                                              .withValues(alpha: 0.10)
                                        : Appcolors.darkgray2,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      AppAsstes.subscriptionIcons.subBg,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          label(
                                            sortedList[index].planName!,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            textColor: Appcolors
                                                .appPriSecColor
                                                .appPrimblue,
                                          ),
                                          sizeBoxHeight(10),
                                          SizedBox(
                                            height: 50,
                                            child: label(
                                              sortedList[index].subtext!,
                                              fontSize: 13,
                                              maxLines: 2,
                                              fontWeight: FontWeight.w600,
                                              textColor:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors
                                                        .appTextColor
                                                        .textBlack
                                                  : Appcolors
                                                        .appTextColor
                                                        .textWhite,
                                            ),
                                          ),
                                          sizeBoxHeight(20),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: RichText(
                                              text: TextSpan(
                                                text: '',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Appcolors
                                                      .appPriSecColor
                                                      .appPrimblue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: sortedList[index]
                                                        .price!,
                                                    style: TextStyle(
                                                      fontSize: 36,
                                                      color:
                                                          themeContro
                                                              .isLightMode
                                                              .value
                                                          ? Appcolors.black
                                                          : Appcolors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '/ ${capitalizeEachWord(sortedList[index].duration!)}',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: Appcolors
                                                          .appPriSecColor
                                                          .appPrimblue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          sizeBoxHeight(10),
                                          Divider(
                                            height: 2,
                                            color: Appcolors.grey400,
                                          ),
                                          sizeBoxHeight(20),
                                          HtmlListWithIcons(
                                            htmlData:
                                                sortedList[index].description!,
                                          ),
                                        ],
                                      ).paddingAll(30),
                                    ),
                                    loginContro.isPaymentSuccessLoading.value ==
                                            true
                                        ? Center(child: commonLoading())
                                        : GestureDetector(
                                            onTap: () {
                                              if (getprofilecontro
                                                      .updatemodel1
                                                      .value!
                                                      .subscriberUser !=
                                                  1) {
                                                loginContro
                                                        .selectedPlanIndex
                                                        .value =
                                                    index;
                                                paymentDialog();
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                color:
                                                    getprofilecontro
                                                            .updatemodel1
                                                            .value!
                                                            .subscriberUser ==
                                                        1
                                                    ? Appcolors
                                                          .appPriSecColor
                                                          .appPrimblue
                                                          .withValues(
                                                            alpha: 0.15,
                                                          )
                                                    : Appcolors
                                                          .appPriSecColor
                                                          .appPrimblue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: label(
                                                  getprofilecontro
                                                              .updatemodel1
                                                              .value!
                                                              .subscriberUser ==
                                                          1
                                                      ? getprofilecontro
                                                                    .updatemodel1
                                                                    .value!
                                                                    .subscriptionDetails!
                                                                    .subscriptionId ==
                                                                sortedList[index]
                                                                    .id
                                                                    .toString()
                                                            ? 'Activated'
                                                            : languageController
                                                                  .textTranslate(
                                                                    'Subscribe Now',
                                                                  )
                                                      : languageController
                                                            .textTranslate(
                                                              'Subscribe Now',
                                                            ),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  textColor:
                                                      getprofilecontro
                                                              .updatemodel1
                                                              .value!
                                                              .subscriberUser ==
                                                          1
                                                      ? getprofilecontro
                                                                    .updatemodel1
                                                                    .value!
                                                                    .subscriptionDetails!
                                                                    .subscriptionId ==
                                                                sortedList[index]
                                                                    .id
                                                                    .toString()
                                                            ? Appcolors
                                                                  .appPriSecColor
                                                                  .appPrimblue
                                                            : Appcolors
                                                                  .appTextColor
                                                                  .textLighGray
                                                                  .withValues(
                                                                    alpha: 0.3,
                                                                  )
                                                      : Appcolors.white,
                                                ),
                                              ),
                                            ),
                                          ).paddingSymmetric(horizontal: 20).paddingOnly(bottom: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return sizeBoxHeight(20);
                          },
                        ),
                      ),
              ],
            ).paddingSymmetric(horizontal: 5);
          }),
        ),
      ),
    );
  }

  Widget _buildIOSPlans() {
    if (!_available) {
      return Column(
        children: [
          sizeBoxHeight(200),
          Center(child: Text("In-App Purchases not available")),
        ],
      );
    } else if (_products.isEmpty) {
      return Column(
        children: [
          sizeBoxHeight(200),
          Center(child: Text("No subscription plans found")),
        ],
      );
    } else {
      return SizedBox(
        height: Get.height * 0.56,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: _products.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final product = _products[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                height: Get.height * 0.54,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.darkGray,
                  border: Border.all(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appPriSecColor.appPrimblue.withValues(
                            alpha: 0.10,
                          )
                        : Appcolors.darkgray2,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(AppAsstes.subscriptionIcons.subBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label(
                            product.title, // Use product title as plan name
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            textColor: Appcolors.appPriSecColor.appPrimblue,
                          ),
                          sizeBoxHeight(10),
                          SizedBox(
                            height: 50,
                            child: label(
                              product.description, // Use product description
                              fontSize: 13,
                              maxLines: 2,
                              fontWeight: FontWeight.w600,
                              textColor: themeContro.isLightMode.value
                                  ? Appcolors.appTextColor.textBlack
                                  : Appcolors.appTextColor.textWhite,
                            ),
                          ),
                          sizeBoxHeight(20),
                          Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: product.price, // Use product price
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: product.description,
                                    // text: '/ year',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color:
                                          Appcolors.appPriSecColor.appPrimblue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          sizeBoxHeight(10),
                          Divider(height: 2, color: Appcolors.grey400),
                          sizeBoxHeight(20),
                          // For features, you might need to hardcode or map based on product ID
                          // Example: Assuming description has HTML, but ProductDetails.description is plain text
                          // If features are in description, parse it or hardcode
                          // Text(
                          //   "Features for ${product.id}", // Customize as needed
                          //   style: AppTypography.text10Medium(context),
                          // ),
                          HtmlListWithIcons(
                            htmlData:
                                "<p><span style=\"color: rgb(0, 0, 0); font-family: Poppins, serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">24/7 Consultancy Service</span></p><p><span style=\"color: rgb(0, 0, 0); font-family: Poppins, serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Market Research and Analysis</span></p><p><span style=\"color: rgb(0, 0, 0); font-family: Poppins, serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Financial Planning and Budgeting</span></p><p><span style=\"color: rgb(0, 0, 0); font-family: Poppins, serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Branding and Marketing Strategies</span></p>",
                          ),
                        ],
                      ).paddingAll(30),
                    ),
                    loginContro.isPaymentSuccessLoading.value == true
                        ? Center(child: commonLoading())
                        : GestureDetector(
                                onTap: () {
                                  loginContro.selectedPlanIndex.value = index;
                                  if (getprofilecontro
                                          .updatemodel1
                                          .value!
                                          .subscriberUser !=
                                      1) {
                                    // For iOS, directly purchase
                                    _purchaseProduct(product);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color:
                                        getprofilecontro
                                                .updatemodel1
                                                .value!
                                                .subscriberUser ==
                                            1
                                        ? Appcolors.appPriSecColor.appPrimblue
                                              .withValues(alpha: 0.15)
                                        : Appcolors.appPriSecColor.appPrimblue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: label(
                                      getprofilecontro
                                                  .updatemodel1
                                                  .value!
                                                  .subscriberUser ==
                                              1
                                          ? 'Activated' // Adjust logic for current plan if needed
                                          : languageController.textTranslate(
                                              'Subscribe Now',
                                            ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      textColor:
                                          getprofilecontro
                                                  .updatemodel1
                                                  .value!
                                                  .subscriberUser ==
                                              1
                                          ? Appcolors.appPriSecColor.appPrimblue
                                          : Appcolors.white,
                                    ),
                                  ),
                                ),
                              )
                              .paddingSymmetric(horizontal: 20)
                              .paddingOnly(bottom: 20),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return sizeBoxHeight(20);
          },
        ),
      );
    }
  }

  Future<dynamic> paymentDialog() {
    if (Platform.isIOS) {
      // For iOS, no payment dialog needed since we're using IAP directly in the plan cards
      return Future.value(null);
    }
    return Get.dialog(
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.57),
      Dialog(
        elevation: 0,
        backgroundColor: Appcolors.appBgColor.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.8, sigmaY: 3.8),
          child: StatefulBuilder(
            builder: (context, aa) {
              return Container(
                height: Get.height * 0.50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.darkGray,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: loginContro.paymentOptions
                          .where((option) {
                            switch (option["value"]) {
                              case "credit_debit":
                                return paymentController
                                        .model
                                        .value
                                        .data!
                                        .stripe!
                                        .status ==
                                    1;
                              case "paypal":
                                return paymentController
                                        .model
                                        .value
                                        .data!
                                        .paypal!
                                        .status ==
                                    1;
                              case "gpay":
                                return Platform.isAndroid &&
                                    paymentController
                                            .model
                                            .value
                                            .data!
                                            .googlePay!
                                            .status ==
                                        1;
                              case "razorpay":
                                return paymentController
                                        .model
                                        .value
                                        .data!
                                        .razorPay!
                                        .status ==
                                    1;
                              case "flutterwave":
                                return paymentController
                                        .model
                                        .value
                                        .data!
                                        .flutterwave!
                                        .status ==
                                    1;
                              case "apple pay":
                                return Platform.isIOS &&
                                    paymentController
                                            .model
                                            .value
                                            .data!
                                            .applepay!
                                            .status ==
                                        1;
                              default:
                                return true; // Show other options by default
                            }
                          })
                          .map((option) {
                            return RadioListTile<String>(
                              dense: true,
                              activeColor: Appcolors.appPriSecColor.appPrimblue,
                              value: option["value"]!,
                              groupValue: loginContro.selectedPayment.value,
                              onChanged: (String? value) {
                                aa(() {
                                  loginContro.selectedPayment.value = value!;
                                });
                              },
                              title: Row(
                                children: [
                                  Image.asset(
                                    option["image"]!,
                                    width: 25, // Adjust size as needed
                                    height: 25,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    option["title"]!,
                                    style: poppinsFont(
                                      12,
                                      themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          .toList(),
                    ),
                    sizeBoxHeight(10),
                    Obx(() {
                      return loginContro.isPaymentSuccessLoading.value
                          ? Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: commonLoading(),
                              ),
                            )
                          : CustomButtom(
                              title: "Apply",
                              onPressed: () async {
                                (loginContro.selectedPayment.value);
                                String symbol = loginContro
                                    .subscriptionDetailsData[loginContro
                                        .selectedPlanIndex
                                        .value]
                                    .price!
                                    .replaceAll(RegExp(r'[\d\s.,]'), '')
                                    .trim();

                                // Find the matching currency code
                                String currencyCode = "USD"; // Default currency
                                for (var entry in countryCurrency.values) {
                                  if (entry["symbol"] == symbol) {
                                    currencyCode = entry["code"]!;
                                    break;
                                  }
                                }

                                double amount = double.parse(
                                  loginContro
                                      .subscriptionDetailsData[loginContro
                                          .selectedPlanIndex
                                          .value]
                                      .price!
                                      .replaceAll(RegExp(r'[^\d.]'), ''),
                                );

                                if (symbol != "\$") {
                                  amount = await paymentController
                                      .convertUSDtoOTHER(amount, currencyCode);
                                }

                                String formattedAmount = amount % 1 == 0
                                    ? amount.toStringAsFixed(0)
                                    : amount.toStringAsFixed(2);
                                //******************************* stripe payment call **************************
                                //******************************* stripe payment call **************************
                                //******************************* stripe payment call **************************
                                if (loginContro.selectedPayment.value ==
                                    "credit_debit") {
                                  makeStripePayment(
                                    key: paymentController
                                        .model
                                        .value
                                        .data!
                                        .stripe!
                                        .secretKey!,
                                    totlaAmt: formattedAmount,
                                  );
                                  //******************************* Paypal payment call
                                  //******************************* Paypal payment call
                                  //******************************* Paypal payment call
                                } else if (loginContro.selectedPayment.value ==
                                    "paypal") {
                                  ("currencyCode:$currencyCode");
                                  Get.back();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaypalPayment(
                                        totalPrice: formattedAmount,
                                        onFinish: (number) async {
                                          Navigator.pop(context);
                                          // await getprofilecontro.updateApi(isUpdateProfile: false);
                                          final success = await loginContro
                                              .paymentSuccess(
                                                paymentType: "paypal",
                                              );

                                          if (success) {
                                            paymentDialogSucess();

                                            Future.delayed(
                                              const Duration(seconds: 2),
                                              () {
                                                Get.back();
                                                if (isDemo == "false") {
                                                  if (isStoreGlobal == 0) {
                                                    Get.to(
                                                      () => AddStore(),
                                                    )!.then((_) {
                                                      setState(() {});
                                                    });
                                                  } else {
                                                    Get.back();
                                                  }
                                                }
                                              },
                                            );
                                            setState(() {});
                                          }
                                          setState(() {});
                                        },
                                        publickKey: paymentController
                                            .model
                                            .value
                                            .data!
                                            .paypal!
                                            .publicKey
                                            .toString(),
                                        secretKey: paymentController
                                            .model
                                            .value
                                            .data!
                                            .paypal!
                                            .secretKey
                                            .toString(),
                                      ),
                                    ),
                                  );
                                  //******************************* Gpay payment call
                                  //******************************* Gpay payment call
                                  //******************************* Gpay payment call
                                } else if (loginContro.selectedPayment.value ==
                                    "gpay") {
                                  try {
                                    setState(() {
                                      loginContro
                                              .isPaymentSuccessLoading
                                              .value =
                                          true;
                                    });

                                    await payClient!.showPaymentSelector(
                                      PayProvider.google_pay,
                                      [
                                        PaymentItem(
                                          label: "Nlytical app",
                                          amount: formattedAmount,
                                          status: PaymentItemStatus.final_price,
                                        ),
                                      ],
                                    );

                                    // Note: Do NOT put success logic here!
                                    // It is handled in the EventChannel listener
                                  } catch (e) {
                                    developer.log("Google Pay failed: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Google Pay error: $e"),
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      loginContro
                                              .isPaymentSuccessLoading
                                              .value =
                                          false;
                                    });
                                  }

                                  //============================================== Apple Pay
                                  //============================================== Apple Pay
                                  //============================================== Apple Pay
                                } else if (loginContro.selectedPayment.value ==
                                    "apple pay") {
                                  try {
                                    setState(() {
                                      loginContro
                                              .isPaymentSuccessLoading
                                              .value =
                                          true;
                                    });
                                    final result = await payClient!
                                        .showPaymentSelector(
                                          PayProvider.apple_pay,
                                          [
                                            PaymentItem(
                                              amount: formattedAmount,
                                              status:
                                                  PaymentItemStatus.final_price,
                                              label: "Nlytical app",
                                            ),
                                          ],
                                        )
                                        .then((value) async {
                                          setState(() async {
                                            Navigator.pop(context);
                                            final success = await loginContro
                                                .paymentSuccess(
                                                  paymentType: "apple pay",
                                                );

                                            if (success) {
                                              paymentDialogSucess();

                                              await Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  setState(() {});
                                                  Get.back();
                                                  if (isDemo == "false") {
                                                    if (isStoreGlobal == 0) {
                                                      Get.to(
                                                        () => AddStore(),
                                                      )!.then((_) {
                                                        setState(() {});
                                                      });
                                                    } else {
                                                      Get.back();
                                                    }
                                                  }
                                                },
                                              );
                                              setState(() {});
                                            }
                                            setState(() {
                                              loginContro
                                                      .isPaymentSuccessLoading
                                                      .value =
                                                  false;
                                            });
                                            setState(() {});
                                          });
                                        });
                                  } catch (e) {
                                    setState(() {
                                      loginContro
                                              .isPaymentSuccessLoading
                                              .value =
                                          false;
                                    });
                                  } finally {
                                    setState(() {
                                      loginContro
                                              .isPaymentSuccessLoading
                                              .value =
                                          false;
                                    });
                                  }

                                  //================================================= Razorpay payment call
                                  //================================================= Razorpay payment call
                                  //================================================= Razorpay payment call
                                } else if (loginContro.selectedPayment.value ==
                                    "razorpay") {
                                  rezorPay(
                                    key: paymentController
                                        .model
                                        .value
                                        .data!
                                        .razorPay!
                                        .publicKey!,
                                    price: formattedAmount,
                                  );
                                  Get.back();
                                  //============================================================ flutterwave
                                  //============================================================ flutterwave
                                  //============================================================ flutterwave
                                } else if (loginContro.selectedPayment.value ==
                                    "flutterwave") {
                                  makePayment(
                                    key: paymentController
                                        .model
                                        .value
                                        .data!
                                        .flutterwave!
                                        .secretKey
                                        .toString(),
                                    amount: formattedAmount,
                                    currency: paymentController
                                        .model
                                        .value
                                        .data!
                                        .flutterwave!
                                        .currencyCode!,
                                    testOrLiveModel: paymentController
                                        .model
                                        .value
                                        .data!
                                        .flutterwave!
                                        .mode
                                        .toString(),
                                  );
                                } else {
                                  snackBar("Please select method");
                                }
                              },
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 40,
                              width: Get.width,
                            ).paddingSymmetric(horizontal: 30);
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toUpperCase()}'
              : '',
        )
        .join(' ');
  }

  //=================================================================== RAZRPAY ====================================
  //=================================================================== RAZRPAY ====================================

  void rezorPay({required String key, required String price}) {
    (
      "Priceee ${loginContro.subscriptionDetailsData[loginContro.selectedPlanIndex.value].price!.substring(1)}",
    );
    loginContro.isPaymentSuccessLoading.value = true;

    Razorpay razorpay = Razorpay();
    var options = {
      'key': key, //'rzp_test_67sD9rAjWFVFZQ', rzp_test_51GttSaK6YbCA8
      'amount':
          int.parse(
            loginContro
                .subscriptionDetailsData[loginContro.selectedPlanIndex.value]
                .price!
                .replaceAll(RegExp(r'[^\d.]'), ''),
          ) *
          100,
      'name': "Nlytical app",
      'description': "",
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm'],
      },
      "currency": 'USD',
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    setState(() {
      loginContro.isPaymentSuccessLoading.value = false;
    });
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    Navigator.pop(context);

    final success = await loginContro.paymentSuccess(paymentType: "razorpay");

    if (success) {
      paymentDialogSucess();

      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
        if (isDemo == "false") {
          if (isStoreGlobal == 0) {
            Get.to(() => AddStore())!.then((_) {
              setState(() {});
            });
          }
        }
      });
      setState(() {});
    }
    setState(() {});

    setState(() {
      loginContro.isPaymentSuccessLoading.value = false;
    });
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    setState(() {
      loginContro.isPaymentSuccessLoading.value = false;
    });
  }

  //========================================================================== STRIPE ======================
  //========================================================================== STRIPE ======================
  // bool payLoading = false;
  Map<String, dynamic>? customer;
  Map<String, dynamic>? paymentIntent;

  Future<void> makeStripePayment({
    required String key,
    required String totlaAmt,
  }) async {
    loginContro.isPaymentSuccessLoading.value = true; // Start showing loader
    debugPrint("🟡 Stripe Start");
    debugPrint("🔑 Secret Key: $key");
    debugPrint("💰 Total Amount: $totlaAmt");

    // Find the matching currency code
    String currencyCode = "USD"; // Default currency
    int stripeAmountInCents = (double.parse(totlaAmt) * 100).round();

    debugPrint("💵 Stripe Amount (cents): $stripeAmountInCents");
    try {
      // Call createCustomer API
      debugPrint("➡️ Creating customer...");
      customer = await createCustomer(key: key);

      debugPrint("✅ Customer Response: $customer");

      // Check if the customer creation was successful
      if (customer != null && customer!.containsKey('id')) {
        debugPrint("❌ Customer creation failed");
        // Get the customer ID
        String customerId = customer!['id'];
        debugPrint("🆔 Customer ID: $customerId");

        debugPrint("➡️ Creating payment intent...");
        paymentIntent = await createPaymentIntent(
          stripeAmountInCents.toString(),
          currencyCode,
          customerId,
          key: key,
        );

        debugPrint("✅ PaymentIntent Response: $paymentIntent");

        if (paymentIntent == null ||
            !paymentIntent!.containsKey('client_secret')) {
          debugPrint("❌ PaymentIntent failed");
          loginContro.isPaymentSuccessLoading.value = false;
          return;
        }

        debugPrint("🔐 Client Secret: ${paymentIntent!['client_secret']}");

        /// STEP 3: Init Payment Sheet
        debugPrint("➡️ Initializing Payment Sheet...");

        var gpay = PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          currencyCode: currencyCode,
          testEnv: true,
        );

        // STEP 2: Initialize Payment Sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            merchantDisplayName: 'Merchant Name',
            style: ThemeMode.light,
            googlePay: gpay,
            allowsDelayedPaymentMethods: true,
            appearance: const PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(primary: Colors.blue),
            ),
          ),
        );

        // STEP 3: Display Payment sheet
        debugPrint("✅ Payment Sheet Initialized");

        /// STEP 4: Present Payment Sheet
        debugPrint("➡️ Presenting Payment Sheet...");
        await displayPaymentSheet();

        loginContro.isPaymentSuccessLoading.value =
            false; // Stop showing loader
      } else {
        loginContro.isPaymentSuccessLoading.value =
            false; // Stop showing loader
      }
    } catch (e, s) {
      loginContro.isPaymentSuccessLoading.value = false; // Stop showing loader
      debugPrint("🔥 Stripe Error: $e");
      debugPrint("📍 StackTrace: $s");
    } finally {
      loginContro.isPaymentSuccessLoading.value = false;
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      debugPrint("🟢 Opening Stripe Payment Sheet...");

      await Stripe.instance.presentPaymentSheet().then((value) async {
        Get.back();
        final success = await loginContro.paymentSuccess(paymentType: "stripe");

        debugPrint("📦 Backend Payment Success: $success");
        if (success) {
          paymentDialogSucess();

          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
            if (isDemo == "false") {
              if (isStoreGlobal == 0) {
                Get.to(() => AddStore())!.then((_) {
                  setState(() {});
                });
              } else {
                Get.back();
              }
            }
          });
          setState(() {});
        }
        setState(() {});

        setState(() {
          loginContro.isPaymentSuccessLoading.value = false;
        });
        // paymentApi(goalId: goalId, price: price, paymentType: "stripe");
      });
    } catch (e) {
      loginContro.isPaymentSuccessLoading.value = false; // Stop showing loader
      debugPrint("❌ Payment Sheet Error: $e");
    }
  }

  Future<dynamic> createPaymentIntent(
    String amount,
    String currency,
    String customerId, {
    required String key,
  }) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'customer': customerId,
      };

      debugPrint("➡️ Stripe PI API Call");
      debugPrint(
        "Amount: $amount | Currency: $currency | Customer: $customerId",
      );

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      debugPrint("📡 PI Status Code: ${response.statusCode}");
      debugPrint("📡 PI Response: ${response.body}");
      return json.decode(response.body);
    } catch (err) {
      debugPrint("❌ PI Exception: $err");
      throw Exception(err.toString());
    }
  }

  Future<dynamic> createCustomer({required String key}) async {
    try {
      debugPrint("➡️ Stripe Create Customer");
      Map<String, dynamic> body = {'email': "demo2@gmail.com"};

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body, //json.encode(body),
      );
      debugPrint("📡 Customer Status Code: ${response.statusCode}");
      debugPrint("📡 Customer Response: ${response.body}");

      return json.decode(response.body);
    } catch (err) {
      debugPrint("❌ Customer Exception: $err");
      throw Exception(err.toString());
    }
  }

  Future<double> convertUSDtoOTHER(double amount, String currencyCode) async {
    try {
      // Fetch live exchange rate (Replace with your API Key)
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$currencyCode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double exchangeRate = data["rates"]["USD"]; // Get CNY to USD rate
        return amount * exchangeRate;
      } else {
        throw Exception("Failed to load exchange rate");
      }
    } catch (e) {
      return amount * 0.138; // Default fallback conversion rate
    }
  }

  //========================================================================================================================
  //================================================  Flutterwave payment method ===========================================
  //========================================================================================================================

  void makePayment({
    required String key,
    required String amount,
    required String currency,
    required String testOrLiveModel,
  }) async {
    setState(() {
      loginContro.isPaymentSuccessLoading.value = true;
    });

    try {
      final Customer customer = Customer(
        email: userEmail,
        phoneNumber: "$contrycode $userMobileNum",
      );

      final Flutterwave flutterwave = Flutterwave(
        publicKey: key,
        currency: currency,
        amount: amount,
        customer: customer,
        txRef: Uuid().v4(),
        paymentOptions: "card, ussd, bank transfer",
        customization: Customization(
          title: "Payment for Product/Service",
          description: "Payment for items in cart",
        ),
        redirectUrl: "https://www.flutterwave.com",
        isTestMode: true, //testOrLiveModel == "Test" ? true : false,
      );

      final ChargeResponse response = await flutterwave.charge(context);

      if (mounted) {
        if (response.status == "successful") {
          // Payment was successful
          Navigator.pop(context);
          // await getprofilecontro.updateApi(isUpdateProfile: false);
          final success = await loginContro.paymentSuccess(
            paymentType: "flutterwave",
          );

          if (success) {
            paymentDialogSucess();

            Future.delayed(const Duration(seconds: 2), () {
              Get.back();
              if (isDemo == "false") {
                if (isStoreGlobal == 0) {
                  Get.to(() => AddStore())!.then((_) {
                    setState(() {});
                  });
                } else {
                  Get.back();
                }
              }
            });
            setState(() {});
          }
          setState(() {});
        } else {
          // Payment failed
          snackBar('Payment Failed');
          setState(() {
            loginContro.isPaymentSuccessLoading.value = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        snackBar(e.toString());
        setState(() {
          loginContro.isPaymentSuccessLoading.value = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          loginContro.isPaymentSuccessLoading.value = false;
        });
      }
    }
  }
}
// // ignore_for_file: avoid_print, use_build_context_synchronously, depend_on_referenced_packages, unused_local_variable

// import 'dart:convert';

// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutterwave_standard/core/flutterwave.dart';
// import 'package:flutterwave_standard/models/requests/customer.dart';
// import 'package:flutterwave_standard/models/requests/customizations.dart';
// import 'package:flutterwave_standard/models/responses/charge_response.dart';
// import 'package:get/get.dart';
// import 'package:nlytical/Vendor/payment/payment_google_pay.dart';
// import 'package:nlytical/Vendor/payment/paypal_payment.dart';
// import 'package:nlytical/Vendor/screens/add_store.dart';
// import 'package:nlytical/auth/splash.dart';
// import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
// import 'package:nlytical/controllers/vendor_controllers/payment_controller.dart';
// import 'package:nlytical/controllers/vendor_controllers/login_controller.dart';
// import 'package:nlytical/models/vendor_models/subscription_plan_model.dart';
// import 'package:nlytical/utils/assets.dart';
// import 'package:nlytical/utils/colors.dart';
// import 'package:nlytical/utils/common_widgets.dart';
// import 'package:nlytical/utils/flexible_space.dart';
// import 'package:nlytical/utils/global.dart';
// import 'package:nlytical/utils/html_tag_icon.dart';
// import 'package:nlytical/utils/size_config.dart';
// import 'package:pay/pay.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:nlytical/utils/global_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as parser;
// import 'package:uuid/uuid.dart';

// import '../../../controllers/vendor_controllers/login_controller.dart';
// import '../../../utils/global.dart';
// import '../../../utils/html_tag_icon.dart';
// import '../../payment/paypal_payment.dart';

// class SubscriptionSceen extends StatefulWidget {
//   const SubscriptionSceen({super.key});

//   @override
//   State<SubscriptionSceen> createState() => _SubscriptionSceenState();
// }

// class _SubscriptionSceenState extends State<SubscriptionSceen> {
//   LoginContro1 loginContro = Get.put(LoginContro1());
//   GetprofileContro getprofilecontro = Get.put(GetprofileContro());
//   PaymentController paymentController = Get.find();

//   Pay? payClient;

//   String convertHtmlToText(String htmlString) {
//     var document = parser.parse(htmlString);

//     return document.body!.text;
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loginContro.subscriptionPlanDetails(isHome: false);
//       getprofilecontro.updateProfileOne();
//       payClient = Pay({
//         PayProvider.google_pay: PaymentConfiguration.fromJsonString(
//           generateGooglePayConfig(
//             environment:
//                 paymentController.model.value.data!.googlePay!.mode!
//                         .toString()
//                         .toLowerCase() ==
//                     'test'
//                 ? "TEST"
//                 : "PRODUCTION", // Change to "TEST" for testing and PRODUCTION for live,
//             merchantId: paymentController
//                 .model
//                 .value
//                 .data!
//                 .googlePay!
//                 .publicKey!
//                 .toString(), // Your actual merchant ID
//             merchantName: paymentController
//                 .model
//                 .value
//                 .data!
//                 .googlePay!
//                 .secretKey!
//                 .toString(),
//             countryCode: paymentController
//                 .model
//                 .value
//                 .data!
//                 .googlePay!
//                 .countryCode!
//                 .toString()
//                 .toUpperCase(),
//             currencyCode: paymentController
//                 .model
//                 .value
//                 .data!
//                 .googlePay!
//                 .currencyCode!
//                 .toString()
//                 .toUpperCase(),
//           ),
//         ),
//         PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
//           generateApplePayConfig(
//             merchantIdentifier: paymentController
//                 .model
//                 .value
//                 .data!
//                 .applepay!
//                 .publicKey!, // Dynamic Merchant ID
//             displayName: paymentController
//                 .model
//                 .value
//                 .data!
//                 .applepay!
//                 .secretKey!, // Dynamic Store Name
//             countryCode: paymentController
//                 .model
//                 .value
//                 .data!
//                 .applepay!
//                 .countryCode!
//                 .toUpperCase(),
//             currencyCode: paymentController
//                 .model
//                 .value
//                 .data!
//                 .applepay!
//                 .currencyCode!
//                 .toUpperCase(),
//           ),
//         ),
//       });
//     });
//     loginContro.isPaymentSuccessLoading.value = false;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: themeContro.isLightMode.value
//           ? Appcolors.appBgColor.white
//           : Appcolors.darkMainBlack,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(65),
//         child: AppBar(
//           leading: customeBackArrow().paddingAll(15),
//           centerTitle: true,
//           title: Text(
//             languageController.textTranslate("Subscription"),
//             style: AppTypography.h1(
//               context,
//             ).copyWith(color: Appcolors.appTextColor.textWhite),
//           ),
//           flexibleSpace: flexibleSpace(),
//           backgroundColor: Appcolors.appBgColor.transparent,
//           shadowColor: Appcolors.appBgColor.transparent,
//           elevation: 0,
//           automaticallyImplyLeading: false,
//         ),
//       ),
//       body: innerContainer(
//         child: SingleChildScrollView(
//           child: Obx(() {
//             final subscriptionId = getprofilecontro
//                 .updatemodel1
//                 .value!
//                 .subscriptionDetails!
//                 .subscriptionId;

//             final sortedList = List<SubscriptionDetail>.from(
//               loginContro.subscriptionDetailsData,
//             );
//             sortedList.sort((a, b) {
//               if (a.id.toString() == subscriptionId) return -1;
//               if (b.id.toString() == subscriptionId) return 1;
//               return 0;
//             });
//             return Column(
//               children: [
//                 sizeBoxHeight(30),
//                 Container(
//                   height: getProportionateScreenHeight(155),
//                   width: Get.width,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Appcolors.appPriSecColor.appPrimblue.withValues(
//                       alpha: 0.17,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: getProportionateScreenHeight(107),
//                         width: Get.width,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20),
//                           ),
//                           color: themeContro.isLightMode.value
//                               ? Appcolors.white
//                               : Appcolors.darkGray,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "CURRENT PLAN",
//                                       style: AppTypography.text10Medium(
//                                         context,
//                                       ).copyWith(fontSize: 11),
//                                     ),

//                                     Text(
//                                       (subscribedUserGlobal == 0 &&
//                                               userRole == "user")
//                                           ? "No Subscription"
//                                           : userRole == "user"
//                                           ? "No Subscription"
//                                           : (subscribedUserGlobal == 0 &&
//                                                 userRole == "vendor")
//                                           ? "Expired Plan"
//                                           : subscribedUserGlobal == 0
//                                           ? "Expired Plan"
//                                           : getprofilecontro
//                                                 .updatemodel1
//                                                 .value!
//                                                 .subscriptionDetails!
//                                                 .planName!,
//                                       style: AppTypography.text14Medium(context)
//                                           .copyWith(
//                                             fontWeight: FontWeight.w600,
//                                             color: Appcolors
//                                                 .appPriSecColor
//                                                 .appPrimblue,
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   subscribedUserGlobal == 0
//                                       ? "\$0"
//                                       : "\$${getprofilecontro.updatemodel1.value!.subscriptionDetails!.price!}",
//                                   style: AppTypography.h1(context).copyWith(
//                                     fontSize: 25,
//                                     color: Appcolors.appPriSecColor.appPrimblue,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             sizeBoxHeight(10),
//                             Text(
//                               (subscribedUserGlobal == 0 && userRole == "user")
//                                   ? "Validity: No Subscription"
//                                   : userRole == "user"
//                                   ? "Validity: No Subscription"
//                                   : (subscribedUserGlobal == 0 &&
//                                         userRole == "vendor")
//                                   ? "Validity: Expired"
//                                   : subscribedUserGlobal == 0
//                                   ? "Validity: Expired"
//                                   : "Validity: ${formatCustomDate(getprofilecontro.updatemodel1.value!.subscriptionDetails!.expireDate.toString())}",

//                               //${formatCustomDate(getprofilecontro.updatemodel1.value!.subscriptionDetails!.startDate.toString())} -
//                               style: AppTypography.text10Medium(context)
//                                   .copyWith(
//                                     fontSize: 11,
//                                     color: subscribedUserGlobal == 0
//                                         ? Colors.red
//                                         : themeContro.isLightMode.value
//                                         ? Appcolors.appTextColor.textBlack
//                                         : Appcolors.appTextColor.textWhite,
//                                   ),
//                             ),
//                           ],
//                         ).paddingOnly(left: 15, right: 15, top: 15, bottom: 5),
//                       ).paddingOnly(left: 4, right: 4, top: 4),
//                       sizeBoxHeight(10),
//                       Text(
//                         subscribedUserGlobal == 0
//                             ? "Subscribe Now To View The Vendor"
//                             : "Your ${getprofilecontro.updatemodel1.value!.subscriptionDetails!.planName!} is activated",
//                         textAlign: TextAlign.center,
//                         style: AppTypography.text10Medium(
//                           context,
//                         ).copyWith(fontWeight: FontWeight.w500, fontSize: 11),
//                       ),
//                     ],
//                   ),
//                 ).paddingSymmetric(horizontal: 10),
//                 sizeBoxHeight(25),
//                 subscribedUserGlobal == 1
//                     ? Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "Other Plans To Explore",
//                           style: AppTypography.text16(
//                             context,
//                           ).copyWith(fontSize: 17, fontWeight: FontWeight.w600),
//                         ),
//                       ).paddingSymmetric(horizontal: 20)
//                     : SizedBox.shrink(),
//                 subscribedUserGlobal == 1
//                     ? sizeBoxHeight(15)
//                     : SizedBox.shrink(),

//                 loginContro.isSubscriptionDetailLoading.value
//                     ? Column(children: [sizeBoxHeight(200), commonLoading()])
//                     : sortedList.isEmpty
//                     ? Column(
//                         children: [
//                           sizeBoxHeight(200),
//                           Center(
//                             child: Text("Subscription Plan not available"),
//                           ),
//                         ],
//                       )
//                     : SizedBox(
//                         height: Get.height * 0.56,
//                         child: ListView.separated(
//                           padding: EdgeInsets.zero,
//                           physics: const BouncingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           itemCount: sortedList.length,
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 5,
//                               ),
//                               child: Container(
//                                 height: Get.height * 0.54,
//                                 width: Get.width * 0.9,
//                                 decoration: BoxDecoration(
//                                   color: themeContro.isLightMode.value
//                                       ? Appcolors.white
//                                       : Appcolors.darkGray,
//                                   border: Border.all(
//                                     color: themeContro.isLightMode.value
//                                         ? Appcolors.appPriSecColor.appPrimblue
//                                               .withValues(alpha: 0.10)
//                                         : Appcolors.darkgray2,
//                                     width: 3,
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                   image: DecorationImage(
//                                     image: AssetImage(
//                                       AppAsstes.subscriptionIcons.subBg,
//                                     ),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           label(
//                                             sortedList[index].planName!,
//                                             fontSize: 19,
//                                             fontWeight: FontWeight.w600,
//                                             textColor: Appcolors
//                                                 .appPriSecColor
//                                                 .appPrimblue,
//                                           ),
//                                           sizeBoxHeight(10),
//                                           SizedBox(
//                                             height: 50,
//                                             child: label(
//                                               sortedList[index].subtext!,
//                                               fontSize: 13,
//                                               maxLines: 2,
//                                               fontWeight: FontWeight.w600,
//                                               textColor:
//                                                   themeContro.isLightMode.value
//                                                   ? Appcolors
//                                                         .appTextColor
//                                                         .textBlack
//                                                   : Appcolors
//                                                         .appTextColor
//                                                         .textWhite,
//                                             ),
//                                           ),

//                                           sizeBoxHeight(20),
//                                           Align(
//                                             alignment: Alignment.topLeft,
//                                             child: RichText(
//                                               text: TextSpan(
//                                                 text: '',
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   color: Appcolors
//                                                       .appPriSecColor
//                                                       .appPrimblue,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                                 children: <TextSpan>[
//                                                   TextSpan(
//                                                     text: sortedList[index]
//                                                         .price!,
//                                                     style: TextStyle(
//                                                       fontSize: 36,
//                                                       color:
//                                                           themeContro
//                                                               .isLightMode
//                                                               .value
//                                                           ? Appcolors.black
//                                                           : Appcolors.white,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text:
//                                                         '/ ${capitalizeEachWord(sortedList[index].duration!)}',
//                                                     style: TextStyle(
//                                                       fontSize: 9,
//                                                       color: Appcolors
//                                                           .appPriSecColor
//                                                           .appPrimblue,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           sizeBoxHeight(10),
//                                           Divider(
//                                             height: 2,
//                                             color: Appcolors.grey400,
//                                           ),
//                                           sizeBoxHeight(20),
//                                           HtmlListWithIcons(
//                                             htmlData:
//                                                 sortedList[index].description!,
//                                           ),
//                                         ],
//                                       ).paddingAll(30),
//                                     ),
//                                     loginContro.isPaymentSuccessLoading.value ==
//                                             true
//                                         ? Center(child: commonLoading())
//                                         : GestureDetector(
//                                             onTap: () {
//                                               if (getprofilecontro
//                                                       .updatemodel1
//                                                       .value!
//                                                       .subscriberUser !=
//                                                   1) {
//                                                 loginContro
//                                                         .selectedPlanIndex
//                                                         .value =
//                                                     index;
//                                                 paymentDialog();
//                                               }
//                                             },
//                                             child: Container(
//                                               height: 50,
//                                               width: Get.width,
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     getprofilecontro
//                                                             .updatemodel1
//                                                             .value!
//                                                             .subscriberUser ==
//                                                         1
//                                                     ? Appcolors
//                                                           .appPriSecColor
//                                                           .appPrimblue
//                                                           .withValues(
//                                                             alpha: 0.15,
//                                                           )
//                                                     : Appcolors
//                                                           .appPriSecColor
//                                                           .appPrimblue,
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                               child: Center(
//                                                 child: label(
//                                                   getprofilecontro
//                                                               .updatemodel1
//                                                               .value!
//                                                               .subscriberUser ==
//                                                           1
//                                                       ? getprofilecontro
//                                                                     .updatemodel1
//                                                                     .value!
//                                                                     .subscriptionDetails!
//                                                                     .subscriptionId ==
//                                                                 sortedList[index]
//                                                                     .id
//                                                                     .toString()
//                                                             ? 'Activated'
//                                                             : languageController
//                                                                   .textTranslate(
//                                                                     'Subscribe Now',
//                                                                   )
//                                                       : languageController
//                                                             .textTranslate(
//                                                               'Subscribe Now',
//                                                             ),
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w600,
//                                                   textColor:
//                                                       getprofilecontro
//                                                               .updatemodel1
//                                                               .value!
//                                                               .subscriberUser ==
//                                                           1
//                                                       ? getprofilecontro
//                                                                     .updatemodel1
//                                                                     .value!
//                                                                     .subscriptionDetails!
//                                                                     .subscriptionId ==
//                                                                 sortedList[index]
//                                                                     .id
//                                                                     .toString()
//                                                             ? Appcolors
//                                                                   .appPriSecColor
//                                                                   .appPrimblue
//                                                             : Appcolors
//                                                                   .appTextColor
//                                                                   .textLighGray
//                                                                   .withValues(
//                                                                     alpha: 0.3,
//                                                                   )
//                                                       : Appcolors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ).paddingSymmetric(horizontal: 20).paddingOnly(bottom: 20),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return sizeBoxHeight(20);
//                           },
//                         ),
//                       ),
//               ],
//             ).paddingSymmetric(horizontal: 5);
//           }),
//         ),
//       ),
//     );
//   }

//   paymentDialog() {
//     return Get.dialog(
//       barrierColor: const Color.fromRGBO(0, 0, 0, 0.57),
//       Dialog(
//         elevation: 0,
//         backgroundColor: Appcolors.appBgColor.transparent,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//         ),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 3.8, sigmaY: 3.8),
//           child: StatefulBuilder(
//             builder: (context, aa) {
//               return Container(
//                 height: Get.height * 0.50,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.all(Radius.circular(20)),
//                   color: themeContro.isLightMode.value
//                       ? Appcolors.white
//                       : Appcolors.darkGray,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: loginContro.paymentOptions
//                           .where((option) {
//                             switch (option["value"]) {
//                               case "credit_debit":
//                                 return paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .stripe!
//                                         .status ==
//                                     1;
//                               case "paypal":
//                                 return paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .paypal!
//                                         .status ==
//                                     1;
//                               case "gpay":
//                                 return Platform.isAndroid &&
//                                     paymentController
//                                             .model
//                                             .value
//                                             .data!
//                                             .googlePay!
//                                             .status ==
//                                         1;
//                               case "razorpay":
//                                 return paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .razorPay!
//                                         .status ==
//                                     1;
//                               case "flutterwave":
//                                 return paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .flutterwave!
//                                         .status ==
//                                     1;
//                               case "apple pay":
//                                 return Platform.isIOS &&
//                                     paymentController
//                                             .model
//                                             .value
//                                             .data!
//                                             .applepay!
//                                             .status ==
//                                         1;
//                               default:
//                                 return true; // Show other options by default
//                             }
//                           })
//                           .map((option) {
//                             return RadioListTile<String>(
//                               dense: true,
//                               activeColor: Appcolors.appPriSecColor.appPrimblue,
//                               value: option["value"]!,
//                               groupValue: loginContro.selectedPayment.value,
//                               onChanged: (String? value) {
//                                 aa(() {
//                                   loginContro.selectedPayment.value = value!;
//                                 });
//                               },
//                               title: Row(
//                                 children: [
//                                   Image.asset(
//                                     option["image"]!,
//                                     width: 25, // Adjust size as needed
//                                     height: 25,
//                                   ),
//                                   const SizedBox(width: 5),
//                                   Text(
//                                     option["title"]!,
//                                     style: poppinsFont(
//                                       12,
//                                       themeContro.isLightMode.value
//                                           ? Appcolors.black
//                                           : Appcolors.white,
//                                       FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           })
//                           .toList(),
//                     ),
//                     sizeBoxHeight(10),
//                     Obx(() {
//                       return loginContro.isPaymentSuccessLoading.value
//                           ? Center(
//                               child: SizedBox(
//                                 height: 30,
//                                 width: 30,
//                                 child: commonLoading(),
//                               ),
//                             )
//                           : CustomButtom(
//                               title: "Apply",
//                               onPressed: () async {
//                                 (loginContro.selectedPayment.value);
//                                 String symbol = loginContro
//                                     .subscriptionDetailsData[loginContro
//                                         .selectedPlanIndex
//                                         .value]
//                                     .price!
//                                     .replaceAll(RegExp(r'[\d\s.,]'), '')
//                                     .trim();

//                                 // Find the matching currency code
//                                 String currencyCode = "USD"; // Default currency
//                                 for (var entry in countryCurrency.values) {
//                                   if (entry["symbol"] == symbol) {
//                                     currencyCode = entry["code"]!;
//                                     break;
//                                   }
//                                 }

//                                 double amount = double.parse(
//                                   loginContro
//                                       .subscriptionDetailsData[loginContro
//                                           .selectedPlanIndex
//                                           .value]
//                                       .price!
//                                       .replaceAll(RegExp(r'[^\d.]'), ''),
//                                 );

//                                 if (symbol != "\$") {
//                                   amount = await paymentController
//                                       .convertUSDtoOTHER(amount, currencyCode);
//                                 }

//                                 String formattedAmount = amount % 1 == 0
//                                     ? amount.toStringAsFixed(0)
//                                     : amount.toStringAsFixed(2);
//                                 //******************************* stripe payment call **************************
//                                 //******************************* stripe payment call **************************
//                                 //******************************* stripe payment call **************************
//                                 if (loginContro.selectedPayment.value ==
//                                     "credit_debit") {
//                                   makeStripePayment(
//                                     key: paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .stripe!
//                                         .secretKey!,
//                                     totlaAmt: formattedAmount,
//                                   );
//                                   //******************************* Paypal payment call
//                                   //******************************* Paypal payment call
//                                   //******************************* Paypal payment call
//                                 } else if (loginContro.selectedPayment.value ==
//                                     "paypal") {
//                                   ("currencyCode:$currencyCode");
//                                   Get.back();
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => PaypalPayment(
//                                         totalPrice: formattedAmount,
//                                         onFinish: (number) async {
//                                           Navigator.pop(context);
//                                           // await getprofilecontro.updateApi(isUpdateProfile: false);
//                                           final success = await loginContro
//                                               .paymentSuccess(
//                                                 paymentType: "paypal",
//                                               );

//                                           if (success) {
//                                             paymentDialogSucess();

//                                             Future.delayed(
//                                               const Duration(seconds: 2),
//                                               () {
//                                                 Get.back();
//                                                 if (isDemo == "false") {
//                                                   if (isStoreGlobal == 0) {
//                                                     Get.to(
//                                                       () => AddStore(),
//                                                     )!.then((_) {
//                                                       setState(() {});
//                                                     });
//                                                   } else {
//                                                     Get.back();
//                                                   }
//                                                 }
//                                               },
//                                             );
//                                             setState(() {});
//                                           }
//                                           setState(() {});
//                                         },
//                                         publickKey: paymentController
//                                             .model
//                                             .value
//                                             .data!
//                                             .paypal!
//                                             .publicKey
//                                             .toString(),

//                                         secretKey: paymentController
//                                             .model
//                                             .value
//                                             .data!
//                                             .paypal!
//                                             .secretKey
//                                             .toString(),
//                                       ),
//                                     ),
//                                   );
//                                   //******************************* Gpay payment call
//                                   //******************************* Gpay payment call
//                                   //******************************* Gpay payment call
//                                 } else if (loginContro.selectedPayment.value ==
//                                     "gpay") {
//                                   try {
//                                     setState(() {
//                                       loginContro
//                                               .isPaymentSuccessLoading
//                                               .value =
//                                           true;
//                                     });
//                                     final result = await payClient!
//                                         .showPaymentSelector(
//                                           PayProvider.google_pay,
//                                           [
//                                             PaymentItem(
//                                               amount: formattedAmount,
//                                               status:
//                                                   PaymentItemStatus.final_price,
//                                               label: "Nlytical app",
//                                             ),
//                                           ],
//                                         )
//                                         .then((value) async {
//                                           // _successPayment();
//                                           setState(() async {
//                                             Navigator.pop(context);
//                                             final success = await loginContro
//                                                 .paymentSuccess(
//                                                   paymentType: "google pay",
//                                                 );

//                                             if (success) {
//                                               paymentDialogSucess();

//                                               Future.delayed(
//                                                 const Duration(seconds: 2),
//                                                 () {
//                                                   Get.back();
//                                                   if (isDemo == "false") {
//                                                     if (isStoreGlobal == 0) {
//                                                       Get.to(
//                                                         () => AddStore(),
//                                                       )!.then((_) {
//                                                         setState(() {});
//                                                       });
//                                                     } else {
//                                                       Get.back();
//                                                     }
//                                                   }
//                                                 },
//                                               );
//                                               setState(() {});
//                                             }
//                                             setState(() {
//                                               loginContro
//                                                       .isPaymentSuccessLoading
//                                                       .value =
//                                                   false;
//                                             });
//                                             setState(() {
//                                               loginContro
//                                                       .isPaymentSuccessLoading
//                                                       .value =
//                                                   false;
//                                             });
//                                           });
//                                         });
//                                   } catch (e) {
//                                     setState(() {
//                                       loginContro
//                                               .isPaymentSuccessLoading
//                                               .value =
//                                           false;
//                                     });
//                                   } finally {
//                                     setState(() {
//                                       loginContro
//                                               .isPaymentSuccessLoading
//                                               .value =
//                                           false;
//                                     });
//                                   }

//                                   //============================================== Apple Pay
//                                   //============================================== Apple Pay
//                                   //============================================== Apple Pay
//                                 } else if (loginContro.selectedPayment.value ==
//                                     "apple pay") {
//                                   try {
//                                     setState(() {
//                                       loginContro
//                                               .isPaymentSuccessLoading
//                                               .value =
//                                           true;
//                                     });
//                                     final result = await payClient!
//                                         .showPaymentSelector(
//                                           PayProvider.apple_pay,
//                                           [
//                                             PaymentItem(
//                                               amount: formattedAmount,
//                                               status:
//                                                   PaymentItemStatus.final_price,
//                                               label: "Nlytical app",
//                                             ),
//                                           ],
//                                         )
//                                         .then((value) async {
//                                           setState(() async {
//                                             Navigator.pop(context);
//                                             final success = await loginContro
//                                                 .paymentSuccess(
//                                                   paymentType: "apple pay",
//                                                 );

//                                             if (success) {
//                                               paymentDialogSucess();

//                                               await Future.delayed(
//                                                 const Duration(seconds: 2),
//                                                 () {
//                                                   setState(() {});
//                                                   Get.back();
//                                                   if (isDemo == "false") {
//                                                     if (isStoreGlobal == 0) {
//                                                       Get.to(
//                                                         () => AddStore(),
//                                                       )!.then((_) {
//                                                         setState(() {});
//                                                       });
//                                                     } else {
//                                                       Get.back();
//                                                     }
//                                                   }
//                                                 },
//                                               );
//                                               setState(() {});
//                                             }
//                                             setState(() {
//                                               loginContro
//                                                       .isPaymentSuccessLoading
//                                                       .value =
//                                                   false;
//                                             });
//                                             setState(() {});
//                                           });
//                                         });
//                                   } catch (e) {
//                                     setState(() {
//                                       loginContro
//                                               .isPaymentSuccessLoading
//                                               .value =
//                                           false;
//                                     });
//                                   } finally {
//                                     setState(() {
//                                       loginContro
//                                               .isPaymentSuccessLoading
//                                               .value =
//                                           false;
//                                     });
//                                   }

//                                   //================================================= Razorpay payment call
//                                   //================================================= Razorpay payment call
//                                   //================================================= Razorpay payment call
//                                 } else if (loginContro.selectedPayment.value ==
//                                     "razorpay") {
//                                   rezorPay(
//                                     key: paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .razorPay!
//                                         .publicKey!,
//                                     price: formattedAmount,
//                                   );
//                                   Get.back();
//                                   //============================================================ flutterwave
//                                   //============================================================ flutterwave
//                                   //============================================================ flutterwave
//                                 } else if (loginContro.selectedPayment.value ==
//                                     "flutterwave") {
//                                   makePayment(
//                                     key: paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .flutterwave!
//                                         .secretKey
//                                         .toString(),
//                                     amount: formattedAmount,
//                                     currency: paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .flutterwave!
//                                         .currencyCode!,
//                                     testOrLiveModel: paymentController
//                                         .model
//                                         .value
//                                         .data!
//                                         .flutterwave!
//                                         .mode
//                                         .toString(),
//                                   );
//                                 } else {
//                                   snackBar("Please select method");
//                                 }
//                               },
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               height: 40,
//                               width: Get.width,
//                             ).paddingSymmetric(horizontal: 30);
//                     }),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   String capitalizeEachWord(String text) {
//     return text
//         .split(' ')
//         .map(
//           (word) => word.isNotEmpty
//               ? '${word[0].toUpperCase()}${word.substring(1).toUpperCase()}'
//               : '',
//         )
//         .join(' ');
//   }

//   //=================================================================== RAZRPAY ====================================
//   //=================================================================== RAZRPAY ====================================

//   void rezorPay({required String key, required String price}) {
//     (
//       "Priceee ${loginContro.subscriptionDetailsData[loginContro.selectedPlanIndex.value].price!.substring(1)}",
//     );
//     loginContro.isPaymentSuccessLoading.value = true;

//     Razorpay razorpay = Razorpay();
//     var options = {
//       'key': key, //'rzp_test_67sD9rAjWFVFZQ', rzp_test_51GttSaK6YbCA8
//       'amount':
//           int.parse(
//             loginContro
//                 .subscriptionDetailsData[loginContro.selectedPlanIndex.value]
//                 .price!
//                 .replaceAll(RegExp(r'[^\d.]'), ''),
//           ) *
//           100,
//       'name': "Nlytical app",
//       'description': "",
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
//       'external': {
//         'wallets': ['paytm'],
//       },
//       "currency": 'USD',
//     };
//     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//     razorpay.open(options);
//   }

//   void handlePaymentErrorResponse(PaymentFailureResponse response) {
//     setState(() {
//       loginContro.isPaymentSuccessLoading.value = false;
//     });
//   }

//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
//     Navigator.pop(context);

//     final success = await loginContro.paymentSuccess(paymentType: "razorpay");

//     if (success) {
//       paymentDialogSucess();

//       Future.delayed(const Duration(seconds: 2), () {
//         Get.back();
//         if (isDemo == "false") {
//           if (isStoreGlobal == 0) {
//             Get.to(() => AddStore())!.then((_) {
//               setState(() {});
//             });
//           }
//         }
//       });
//       setState(() {});
//     }
//     setState(() {});

//     setState(() {
//       loginContro.isPaymentSuccessLoading.value = false;
//     });
//   }

//   void handleExternalWalletSelected(ExternalWalletResponse response) {
//     setState(() {
//       loginContro.isPaymentSuccessLoading.value = false;
//     });
//   }

//   //========================================================================== STRIPE ======================
//   //========================================================================== STRIPE ======================
//   // bool payLoading = false;
//   Map<String, dynamic>? customer;
//   Map<String, dynamic>? paymentIntent;

//   Future<void> makeStripePayment({
//     required String key,
//     required String totlaAmt,
//   }) async {
//     loginContro.isPaymentSuccessLoading.value = true; // Start showing loader

//     // Find the matching currency code
//     String currencyCode = "USD"; // Default currency
//     int stripeAmountInCents = (double.parse(totlaAmt) * 100).round();
//     try {
//       // Call createCustomer API
//       customer = await createCustomer(key: key);

//       // Check if the customer creation was successful
//       if (customer != null && customer!.containsKey('id')) {
//         // Get the customer ID
//         String customerId = customer!['id'];

//         paymentIntent = await createPaymentIntent(
//           stripeAmountInCents.toString(),
//           currencyCode,
//           customerId,
//           key: key,
//         );

//         var gpay = PaymentSheetGooglePay(
//           merchantCountryCode: 'US',
//           currencyCode: currencyCode,
//           testEnv: true,
//         );

//         // STEP 2: Initialize Payment Sheet
//         await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: paymentIntent!['client_secret'],
//             merchantDisplayName: 'Merchant Name',
//             style: ThemeMode.light,
//             googlePay: gpay,
//             allowsDelayedPaymentMethods: true,
//           ),
//         );

//         // STEP 3: Display Payment sheet
//         displayPaymentSheet();

//         loginContro.isPaymentSuccessLoading.value =
//             false; // Stop showing loader
//       } else {
//         loginContro.isPaymentSuccessLoading.value =
//             false; // Stop showing loader
//       }
//     } catch (err) {
//       loginContro.isPaymentSuccessLoading.value = false; // Stop showing loader
//       (err);
//     }
//   }

//   Future<void> displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) async {
//         Get.back();
//         final success = await loginContro.paymentSuccess(paymentType: "stripe");

//         if (success) {
//           paymentDialogSucess();

//           Future.delayed(const Duration(seconds: 2), () {
//             Get.back();
//             if (isDemo == "false") {
//               if (isStoreGlobal == 0) {
//                 Get.to(() => AddStore())!.then((_) {
//                   setState(() {});
//                 });
//               } else {
//                 Get.back();
//               }
//             }
//           });
//           setState(() {});
//         }
//         setState(() {});

//         setState(() {
//           loginContro.isPaymentSuccessLoading.value = false;
//         });
//         // paymentApi(goalId: goalId, price: price, paymentType: "stripe");
//       });
//     } catch (e) {
//       loginContro.isPaymentSuccessLoading.value = false; // Stop showing loader
//       ('$e');
//     }
//   }

//   createPaymentIntent(
//     String amount,
//     String currency,
//     String customerId, {
//     required String key,
//   }) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'customer': customerId,
//       };

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer $key',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: body,
//       );

//       (json.decode(response.body));
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }

//   createCustomer({required String key}) async {
//     try {
//       Map<String, dynamic> body = {'email': "demo2@gmail.com"};

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/customers'),
//         headers: {
//           'Authorization': 'Bearer $key',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: body, //json.encode(body),
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       (err.toString());
//       throw Exception(err.toString());
//     }
//   }

//   Future<double> convertUSDtoOTHER(double amount, String currencyCode) async {
//     try {
//       // Fetch live exchange rate (Replace with your API Key)
//       final response = await http.get(
//         Uri.parse('https://api.exchangerate-api.com/v4/latest/$currencyCode'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         double exchangeRate = data["rates"]["USD"]; // Get CNY to USD rate
//         return amount * exchangeRate;
//       } else {
//         throw Exception("Failed to load exchange rate");
//       }
//     } catch (e) {
//       return amount * 0.138; // Default fallback conversion rate
//     }
//   }

//   //========================================================================================================================
//   //================================================  Flutterwave payment method ===========================================
//   //========================================================================================================================

//   void makePayment({
//     required String key,
//     required String amount,
//     required String currency,
//     required String testOrLiveModel,
//   }) async {
//     setState(() {
//       loginContro.isPaymentSuccessLoading.value = true;
//     });

//     try {
//       final Customer customer = Customer(
//         email: userEmail,
//         phoneNumber: "$contrycode $userMobileNum",
//       );

//       final Flutterwave flutterwave = Flutterwave(
//         publicKey: key,
//         currency: currency,
//         amount: amount,
//         customer: customer,
//         txRef: Uuid().v4(),
//         paymentOptions: "card, ussd, bank transfer",
//         customization: Customization(
//           title: "Payment for Product/Service",
//           description: "Payment for items in cart",
//         ),
//         redirectUrl: "https://www.flutterwave.com",
//         isTestMode: true, //testOrLiveModel == "Test" ? true : false,
//       );

//       final ChargeResponse response = await flutterwave.charge(context);

//       if (mounted) {
//         if (response.status == "successful") {
//           // Payment was successful
//           Navigator.pop(context);
//           // await getprofilecontro.updateApi(isUpdateProfile: false);
//           final success = await loginContro.paymentSuccess(
//             paymentType: "flutterwave",
//           );

//           if (success) {
//             paymentDialogSucess();

//             Future.delayed(const Duration(seconds: 2), () {
//               Get.back();
//               if (isDemo == "false") {
//                 if (isStoreGlobal == 0) {
//                   Get.to(() => AddStore())!.then((_) {
//                     setState(() {});
//                   });
//                 } else {
//                   Get.back();
//                 }
//               }
//             });
//             setState(() {});
//           }
//           setState(() {});
//         } else {
//           // Payment failed
//           snackBar('Payment Failed');
//           setState(() {
//             loginContro.isPaymentSuccessLoading.value = false;
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         snackBar(e.toString());
//         setState(() {
//           loginContro.isPaymentSuccessLoading.value = false;
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           loginContro.isPaymentSuccessLoading.value = false;
//         });
//       }
//     }
//   }
// }
