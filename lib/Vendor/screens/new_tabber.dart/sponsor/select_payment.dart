// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/controllers/vendor_controllers/payment_controller.dart';
import 'package:nlytical/Vendor/payment/payment_google_pay.dart';
import 'package:nlytical/Vendor/payment/paypal_payment.dart';
import 'package:pay/pay.dart';
import 'package:uuid/uuid.dart';

class SelectPayment extends StatefulWidget {
  final String? price;
  final String? goalID;
  const SelectPayment({super.key, this.goalID, this.price});

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  PaymentController paymentcontro = Get.find();

  Pay payClient = Pay({
    PayProvider.google_pay: PaymentConfiguration.fromJsonString(
      defaultGooglePay,
    ),
    PayProvider.apple_pay: PaymentConfiguration.fromJsonString(defaultApplePay),
  });

  @override
  void initState() {
    super.initState();
    ("price:${widget.price}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      payClient = Pay({
        PayProvider.google_pay: PaymentConfiguration.fromJsonString(
          generateGooglePayConfig(
            environment:
                paymentcontro.model.value.data!.googlePay!.mode!
                        .toString()
                        .toLowerCase() ==
                    'test'
                ? "TEST"
                : "PRODUCTION", // Change to "TEST" for testing and PRODUCTION for live
            merchantId: paymentcontro.model.value.data!.googlePay!.publicKey!
                .toString(), // Your actual merchant ID
            merchantName: paymentcontro.model.value.data!.googlePay!.secretKey!
                .toString(),
            countryCode: paymentcontro.model.value.data!.googlePay!.countryCode!
                .toString()
                .toUpperCase(),
            currencyCode: paymentcontro
                .model
                .value
                .data!
                .googlePay!
                .currencyCode!
                .toString()
                .toUpperCase(),
          ),
        ),
        PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
          generateApplePayConfig(
            merchantIdentifier: paymentcontro
                .model
                .value
                .data!
                .applepay!
                .publicKey!, // Dynamic Merchant ID
            displayName: paymentcontro
                .model
                .value
                .data!
                .applepay!
                .secretKey!, // Dynamic Store Name
            countryCode: paymentcontro.model.value.data!.applepay!.countryCode!
                .toUpperCase(),
            currencyCode: paymentcontro
                .model
                .value
                .data!
                .applepay!
                .currencyCode!
                .toUpperCase(),
          ),
        ),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.appBgColor.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Select Preferred Payment"),
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
        child: Column(
          children: [
            sizeBoxHeight(20),
            //********************* STIPRE *******************************/
            //********************* STIPRE *******************************/
            //********************* STIPRE *******************************/
            paymentcontro.model.value.data!.stripe!.status == 1
                ? containerDesign(
                    onTap: () async {
                      String symbol = widget.price!
                          .replaceAll(RegExp(r'[\d\s.,]'), '')
                          .trim();

                      String currencyCode = "USD"; // Default currency
                      for (var entry in countryCurrency.values) {
                        if (entry["symbol"] == symbol) {
                          currencyCode = entry["code"]!;
                          break;
                        }
                      }

                      double amount = double.parse(
                        widget.price!
                            .replaceAll(RegExp(r'[^\d.]'), '')
                            .replaceAll(',', ''),
                      );

                      if (symbol != "\$") {
                        amount = await paymentcontro.convertUSDtoOTHER(
                          amount,
                          currencyCode,
                        );
                      }
                      String formattedAmount = amount % 1 == 0
                          ? amount.toStringAsFixed(0)
                          : amount.toStringAsFixed(2);
                      paymentcontro.makeStripePayment(
                        goalId: widget.goalID.toString(),
                        price: formattedAmount,
                        key: paymentcontro.model.value.data!.stripe!.secretKey!,
                        mode: paymentcontro.model.value.data!.stripe!.mode!,
                      );
                    },
                    img: 'assets/images/cr&deb.png',
                    title: 'Credit or Debit Card',
                    child: Obx(
                      () => paymentcontro.isStripeLoading.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: commonLoading(),
                            )
                          : Image.asset(
                              'assets/images/arrow-left (1).png',
                              color: themeContro.isLightMode.value
                                  ? Appcolors.black
                                  : Appcolors.white,
                              height: 16,
                              width: 16,
                            ),
                    ),
                  )
                : SizedBox.shrink(),
            paymentcontro.model.value.data!.stripe!.status == 1
                ? sizeBoxHeight(10)
                : SizedBox.shrink(),
            //********************* PAYPAL *******************************/
            //********************* PAYPAL *******************************/
            //********************* PAYPAL *******************************/
            // paypal payment button
            paymentcontro.model.value.data!.paypal!.status == 1
                ? containerDesign(
                    onTap: () async {
                      String symbol = widget.price!
                          .replaceAll(RegExp(r'[\d\s.,]'), '')
                          .trim();

                      String currencyCode = "USD"; // Default currency
                      for (var entry in countryCurrency.values) {
                        if (entry["symbol"] == symbol) {
                          currencyCode = entry["code"]!;
                          break;
                        }
                      }

                      double amount = double.parse(
                        widget.price!
                            .replaceAll(RegExp(r'[^\d.]'), '')
                            .replaceAll(',', ''),
                      );

                      if (symbol != "\$") {
                        amount = await paymentcontro.convertUSDtoOTHER(
                          amount,
                          currencyCode,
                        );
                      }
                      String formattedAmount = amount.toStringAsFixed(2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaypalPayment(
                            totalPrice: formattedAmount.toString(),
                            onFinish: (number) async {
                              final success = await paymentcontro.paymentApi(
                                goalId: widget.goalID.toString(),
                                price: formattedAmount,
                                paymentType: "paypal",
                              );

                              if (success) {
                                paymentDialogSucess();

                                Future.delayed(const Duration(seconds: 2), () {
                                  Get.back();
                                });
                              }
                            },
                            publickKey: paymentcontro
                                .model
                                .value
                                .data!
                                .paypal!
                                .publicKey
                                .toString(),
                            secretKey: paymentcontro
                                .model
                                .value
                                .data!
                                .paypal!
                                .secretKey
                                .toString(),
                          ),
                        ),
                      );
                    },
                    img: 'assets/images/paypal_image.png',
                    title: 'PayPal',
                    child: Image.asset(
                      'assets/images/arrow-left (1).png',
                      color: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                      height: 16,
                      width: 16,
                    ),
                  )
                : SizedBox.shrink(),
            paymentcontro.model.value.data!.paypal!.status == 1
                ? sizeBoxHeight(10)
                : SizedBox.shrink(),
            //********************* GOOGLEPAY *******************************/
            //********************* GOOGLEPAY *******************************/
            //********************* GOOGLEPAY *******************************/
            // gpay payment button
            paymentcontro.model.value.data!.googlePay!.status == 1
                ? containerDesign(
                    onTap: () async {
                      String symbol = widget.price!
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
                        widget.price!.replaceAll(RegExp(r'[^\d.]'), ''),
                      );

                      if (symbol != "\$") {
                        amount = await paymentcontro.convertUSDtoOTHER(
                          amount,
                          currencyCode,
                        );
                      }
                      try {
                        setState(() {
                          paymentcontro.isGooglePayLoading.value = true;
                        });
                        final result = await payClient
                            .showPaymentSelector(PayProvider.google_pay, [
                              PaymentItem(
                                amount: amount.toStringAsFixed(2),
                                status: PaymentItemStatus.final_price,
                                label: "Nlytical app",
                              ),
                            ])
                            .then((value) async {
                              setState(() async {
                                final success = await paymentcontro.paymentApi(
                                  goalId: widget.goalID.toString(),
                                  price: widget.price.toString(),
                                  paymentType: "googlepay",
                                );
                                if (success) {
                                  setState(() {
                                    paymentcontro.isGooglePayLoading.value =
                                        true;
                                  });
                                  paymentDialogSucess();

                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      Get.back();
                                    },
                                  );
                                }
                                setState(() {
                                  paymentcontro.isGooglePayLoading.value =
                                      false;
                                });
                              });
                            });
                      } catch (e) {
                        setState(() {
                          paymentcontro.isGooglePayLoading.value = false;
                        });
                      } finally {
                        setState(() {
                          paymentcontro.isGooglePayLoading.value = false;
                        });
                      }
                    },
                    img: 'assets/images/gpay.png',
                    title: 'Gpay',
                    child: paymentcontro.isGooglePayLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: commonLoading(),
                          )
                        : Image.asset(
                            'assets/images/arrow-left (1).png',
                            color: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            height: 16,
                            width: 16,
                          ),
                  )
                : SizedBox.shrink(),
            paymentcontro.model.value.data!.googlePay!.status == 1
                ? sizeBoxHeight(10)
                : SizedBox.shrink(),
            //********************* APPLE PAY *******************************/
            //********************* APPLE PAY *******************************/
            //********************* APPLE PAY *******************************/
            Platform.isIOS
                ? containerDesign(
                    onTap: () async {
                      String symbol = widget.price!
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
                        widget.price!.replaceAll(RegExp(r'[^\d.]'), ''),
                      );

                      if (symbol != "\$") {
                        amount = await paymentcontro.convertUSDtoOTHER(
                          amount,
                          currencyCode,
                        );
                      }

                      try {
                        setState(() {
                          paymentcontro.isApplePayLoading.value = true;
                        });
                        final result = await payClient
                            .showPaymentSelector(PayProvider.apple_pay, [
                              PaymentItem(
                                amount: amount.toStringAsFixed(2),
                                status: PaymentItemStatus.final_price,
                                label: "Nlytical app",
                              ),
                            ])
                            .then((value) async {
                              setState(() async {
                                final success = await paymentcontro.paymentApi(
                                  goalId: widget.goalID.toString(),
                                  price: widget.price.toString(),
                                  paymentType: "apple pay",
                                );

                                if (success) {
                                  paymentDialogSucess();

                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      Get.back();
                                    },
                                  );
                                  setState(() {});
                                }
                              });
                              setState(() {
                                paymentcontro.isApplePayLoading.value = false;
                              });
                            });
                      } catch (e) {
                        setState(() {
                          paymentcontro.isApplePayLoading.value = false;
                        });
                      } finally {
                        setState(() {
                          paymentcontro.isApplePayLoading.value = false;
                        });
                      }
                    },
                    img: AppAsstes.apple,
                    title: 'Apple Pay',
                    child: paymentcontro.isApplePayLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: commonLoading(),
                          )
                        : Image.asset(
                            'assets/images/arrow-left (1).png',
                            color: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            height: 16,
                            width: 16,
                          ),
                  )
                : SizedBox.shrink(),
            Platform.isIOS ? sizeBoxHeight(10) : SizedBox.shrink(),
            //************************** RAZORPAY **************************************/
            //************************** RAZORPAY **************************************/
            //************************** RAZORPAY **************************************/
            paymentcontro.model.value.data!.razorPay!.status == 1
                ? containerDesign(
                    onTap: () async {
                      paymentcontro.rezorPay(
                        goalId: widget.goalID.toString(),
                        price: widget.price!,
                        key: paymentcontro
                            .model
                            .value
                            .data!
                            .razorPay!
                            .publicKey!,
                      );
                    },
                    img: 'assets/images/razorpay.png',
                    title: 'Razorpay',
                    child: paymentcontro.isRazorPayLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: commonLoading(),
                          )
                        : Image.asset(
                            'assets/images/arrow-left (1).png',
                            color: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            height: 16,
                            width: 16,
                          ),
                  )
                : SizedBox.shrink(),
            paymentcontro.model.value.data!.razorPay!.status == 1
                ? sizeBoxHeight(10)
                : SizedBox.shrink(),
            //************************** FLUTTER WAVE **************************************/
            //************************** FLUTTER WAVE **************************************/
            //************************** FLUTTER WAVE **************************************/
            paymentcontro.model.value.data!.flutterwave!.status == 1
                ? containerDesign(
                    onTap: () async {
                      String symbol = widget.price!
                          .replaceAll(RegExp(r'[\d\s.,]'), '')
                          .trim();

                      String currencyCode = "USD"; // Default currency
                      for (var entry in countryCurrency.values) {
                        if (entry["symbol"] == symbol) {
                          currencyCode = entry["code"]!;
                          break;
                        }
                      }

                      double amount = double.parse(
                        widget.price!
                            .replaceAll(RegExp(r'[^\d.]'), '')
                            .replaceAll(',', ''),
                      );

                      if (symbol != "\$") {
                        amount = await paymentcontro.convertUSDtoOTHER(
                          amount,
                          currencyCode,
                        );
                      }
                      String formattedAmount = amount.toStringAsFixed(2);
                      if (!context.mounted) return;
                      makePayment(
                        key: paymentcontro
                            .model
                            .value
                            .data!
                            .flutterwave!
                            .secretKey
                            .toString(),
                        amount: formattedAmount,
                        currency: paymentcontro
                            .model
                            .value
                            .data!
                            .flutterwave!
                            .currencyCode!,
                        testOrLiveModel:
                            paymentcontro.model.value.data!.flutterwave!.mode!,
                      );
                    },
                    img: 'assets/images/flutterwave_logo.png',
                    title: 'Flutterwave',
                    child: paymentcontro.isFlutterWaveLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: commonLoading(),
                          )
                        : Image.asset(
                            'assets/images/arrow-left (1).png',
                            color: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            height: 16,
                            width: 16,
                          ),
                  )
                : SizedBox.shrink(),
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }

  Widget containerDesign({
    required Function() onTap,
    required String img,
    required String title,
    required Widget child,
  }) {
    return Container(
      height: 50,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.appBgColor.darkGray,
        boxShadow: [
          BoxShadow(
            color: themeContro.isLightMode.value
                ? Appcolors.grey200
                : Appcolors.darkShadowColor,
            blurRadius: 14.0,
            spreadRadius: 0.0,
            offset: const Offset(2.0, 4.0), // shadow direction: bottom right
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                sizeBoxWidth(10),
                Image.asset(
                  img,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                ),
                sizeBoxWidth(10),
                Text(title, style: AppTypography.text12Medium(context)),
              ],
            ),
            child,
          ],
        ).paddingOnly(right: 10),
      ),
    ).paddingSymmetric(horizontal: 10);
  }

  void makePayment({
    required String key,
    required String amount,
    required String currency,
    required String testOrLiveModel,
  }) async {
    setState(() {
      paymentcontro.isFlutterWaveLoading.value = true;
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
          final success = await paymentcontro.paymentApi(
            goalId: widget.goalID.toString(),
            price: amount,
            paymentType: "flutterwave",
          );

          if (success) {
            paymentDialogSucess();

            Future.delayed(const Duration(seconds: 2), () {
              Get.back();
            });
            setState(() {});
          }
          setState(() {});
        } else {
          // Payment failed
          snackBar('Payment Failed');
          setState(() {
            paymentcontro.isFlutterWaveLoading.value = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        snackBar(e.toString());
        setState(() {
          paymentcontro.isFlutterWaveLoading.value = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          paymentcontro.isFlutterWaveLoading.value = false;
        });
      }
    }
  }
}
