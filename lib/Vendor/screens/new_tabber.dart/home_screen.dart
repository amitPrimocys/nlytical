// ignore_for_file: deprecated_member_use, avoid_print, unnecessary_null_comparison, use_full_hex_values_for_flutter_colors
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nlytical/User/screens/settings/profile.dart';
import 'package:nlytical/Vendor/screens/add_store.dart';
import 'package:nlytical/Vendor/screens/auth/subcription.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/line_chat/chart.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/search_services.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/controllers/vendor_controllers/campaign_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/lang_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/payment_history_controller.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/controllers/vendor_controllers/profile_cotroller.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/Vendor/screens/auth/payment_history.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/all_service.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/my_review_screen.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_images.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_social_link.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_video.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_website.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/contact_detail.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/edit_service_profile.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/store_time.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/support.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/sponsor/add_campaign.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nlytical/utils/global_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StoreController storeController = Get.put(StoreController());
  GetprofileContro getprofilecontro = Get.find();
  ProfileCotroller profileCotroller = Get.find();
  PaymentHistoryController paymentHistoryController = Get.find();
  CampaignController campaignController = Get.find();
  final searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  // String currentAddress = "Fetching location...";
  // ignore: unused_field
  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, so request the user to enable them.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, so return an error.
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, so return an error.
      return Future.error('Location permissions are permanently denied.');
    }

    // Get the current location of the device
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    ("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

    setState(() {
      _currentPosition = position;
    });

    // Get the address from the current latitude and longitude
    _getAddressFromLatLng(position);
  }

  // Convert latitude and longitude to address using geocoding
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      (position.latitude);
      (position.longitude);
      await SecurePrefs.setString(
        SecureStorageKeys.LATTITUDE,
        position.latitude.toString(),
      );
      await SecurePrefs.setString(
        SecureStorageKeys.LONGITUDE,
        position.longitude.toString(),
      );

      Placemark place = placemarks[0];

      setState(() {
        storeController.currentAddress =
            "${place.subLocality} ,${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        storeController.currentAddress = "Could not get address";
      });
    }
  }

  @override
  void initState() {
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userTextDirection.isEmpty && userTextDirection == "") {
        ("empty");
        Get.find<LanguageController>().getLanguages;
        Get.find<LanguageController>().getLanguageTranslation();
        Get.find<LanguageController>().loadTextDirection();
      }
      getprofilecontro.updateProfileOne();
      if (isStoreGlobal == 1) {
        paymentHistoryController.getPaymentHistory(isHome: true);
        storeController.businessPercentageApi();
        storeController.getStoreDetailApi();
        profileCotroller.getProfleApi();
        campaignController.getCampaignApi(isHome: true);
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Appcolors.appPriSecColor.appPrimblue,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: themeContro.isLightMode.value
            ? Appcolors.appBgColor.white
            : Appcolors.darkMainBlack,
        body: Stack(
          children: [
            Column(
              children: [
                myLocationWidget(),
                sizeBoxHeight(50),
                Expanded(
                  child: SingleChildScrollView(
                    child: isStoreGlobal == 0
                        ? subscribedUserAlertWidget(
                            context,
                            height: 60,
                            title: languageController.textTranslate(
                              "Start Adding Store",
                            ),
                            secTitle: languageController.textTranslate(
                              "As you have subscribed, you can proceed to start adding the store",
                            ),
                            buttonText: languageController.textTranslate(
                              "Add Store",
                            ),
                            onTap: () {
                              if (isDemo == "false") {
                                Get.to(() => AddStore());
                              } else {
                                snackBar(
                                  "This is for demo, We can not allow to add",
                                );
                              }
                            },
                          )
                        : businessHomeWidget(),
                  ),
                ),
              ],
            ),

            //***************************************************************************************************************** */
            //************************************* when subscription over then show ****************************************** */
            //***************************************************************************************************************** */
            appPayment == true
                ? subscribedUserGlobal == 0
                      ? Container(
                          color: Color(0xff3A3A3A).withValues(alpha: 0.94),
                          child: Center(
                            child: Container(
                              height: getProportionateScreenHeight(330),
                              width: getProportionateScreenWidth(300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(AppAsstes.blue_bg),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    languageController.textTranslate(
                                      "Subscription",
                                    ),
                                    style: AppTypography.text16Semi(context)
                                        .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Appcolors.appTextColor.textWhite,
                                        ),
                                  ),
                                  sizeBoxHeight(10),
                                  Image.asset(AppAsstes.subscri2, height: 70),
                                  sizeBoxHeight(25),
                                  Text(
                                    languageController.textTranslate(
                                      "Subscribe to start listing and sponsor store",
                                    ),
                                    textAlign: TextAlign.center,
                                    style: AppTypography.text16Semi(context)
                                        .copyWith(
                                          fontSize: 18,
                                          fontFamily: 'limericItalic',
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Appcolors.appTextColor.textWhite,
                                        ),
                                  ).paddingSymmetric(horizontal: 20),
                                  sizeBoxHeight(20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => SubscriptionSceen())!.then((
                                        _,
                                      ) {
                                        setState(() {
                                          campaignController.getcampaignmodel
                                              .refresh();
                                        });
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageController.textTranslate(
                                          "Subscribe Now",
                                        ),
                                        style:
                                            AppTypography.text12Medium(
                                              context,
                                            ).copyWith(
                                              fontSize: 12,
                                              color: Appcolors
                                                  .appPriSecColor
                                                  .appPrimblue,
                                            ),
                                      ),
                                    ),
                                  ).paddingSymmetric(horizontal: 30),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink()
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget businessHomeWidget() {
    return Column(
      children: [
        //* business percentage
        percentageWidget(),
        sizeBoxHeight(20),
        //* professional dashboard
        profetionaldash(),
        sizeBoxHeight(20),
        //* add service button
        addServiceBtn(),
        sizeBoxHeight(20),
        //* quick links
        quickLinkWidget(),
        sizeBoxHeight(30),
        //* business tools
        myBusinessWidget(),
      ],
    );
  }

  //================================================= PERCENTAGE Widget ===========================================================================================
  Widget percentageWidget() {
    setState(() {});
    final percentageString = percentageStore;
    final percentageValue = double.tryParse(percentageString) ?? 0.0;
    return Container(
      height: getProportionateScreenHeight(130),
      decoration: BoxDecoration(
        border: Border.all(
          color: themeContro.isLightMode.value
              ? Appcolors.appPriSecColor.appPrimblue.withValues(alpha: 0.10)
              : Appcolors.appBgColor.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.appPriSecColor.appPrimblue,
        boxShadow: [
          BoxShadow(
            blurRadius: 14.4,
            offset: Offset(0, 4),
            spreadRadius: 0,
            color: Appcolors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              animatedCircularProgressIndicator(value: percentageValue / 100),
              Text(
                percentageString == '0' && percentageString == null
                    // ignore: dead_code
                    ? '0%'
                    : '$percentageString%', // Display the percentage here
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeContro.isLightMode.value
                      ? Appcolors.appExtraColor.greenColor.withValues(
                          alpha: 0.75,
                        )
                      : Appcolors.appExtraColor.c00F884,
                ),
              ),
            ],
          ),
          sizeBoxWidth(30),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageController.textTranslate(
                    "Increase Business Profile Score",
                  ),
                  style: AppTypography.text14Medium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  languageController.textTranslate(
                    "Reach out to more Customers",
                  ),
                  style: AppTypography.text12Medium(context),
                ),
                sizeBoxHeight(2),
                InkWell(
                  onTap: () {
                    Get.to(const EditServiceProfile());
                  },
                  child: Container(
                    height: getProportionateScreenHeight(30),
                    width: getProportionateScreenWidth(100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: themeContro.isLightMode.value
                          ? Appcolors.appPriSecColor.appPrimblue
                          : Appcolors.appBgColor.white,
                    ),
                    child: Center(
                      child: Text(
                        languageController.textTranslate("Increase Score"),
                        style: AppTypography.text10Medium(context).copyWith(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textWhite
                              : Appcolors.appPriSecColor.appPrimblue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 30),
    ).paddingSymmetric(horizontal: 12);
  }

  //================================================ Proferional Widget =========================================================================================

  Widget profetionaldash() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => const Chart());
          },
          child: Container(
            height: getProportionateScreenHeight(85),
            width: Get.width,
            decoration: BoxDecoration(
              border: Border.all(
                color: themeContro.isLightMode.value
                    ? Appcolors.appPriSecColor.appPrimblue.withValues(
                        alpha: 0.10,
                      )
                    : Appcolors.appBgColor.darkGray,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Appcolors.appPriSecColor.appPrimblue.withValues(
                alpha: 0.10,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageController.textTranslate('Professional Dashboard'),
                  style: AppTypography.text14Medium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                sizeBoxHeight(8),
                Text(
                  languageController.textTranslate(
                    'Reach out to more Customers',
                  ),
                  style: AppTypography.text10Regular(context),
                ),
              ],
            ).paddingAll(12),
          ).paddingSymmetric(horizontal: 13),
        ),
        Positioned(
          top: -42,
          right: 7,
          child: Image.asset(AppAsstes.Darkanalytics, height: 150, width: 122),
        ),
      ],
    );
  }

  //==================================================== Add Service Btn =========================================================================================
  Widget addServiceBtn() {
    return Container(
      height: getProportionateScreenHeight(65),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Appcolors.appPriSecColor.appPrimblue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Grow Your ",
                        style: AppTypography.text14Medium(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: "Business By Boosting 🚀",
                        style: AppTypography.text14Medium(context).copyWith(
                          color: Appcolors.appTextColor.textRedAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 15),
              ),
            ],
          ).paddingSymmetric(vertical: 5),
          Obx(() {
            return paymentHistoryController.isLoading.value
                ? CupertinoActivityIndicator(
                    color: Appcolors.appPriSecColor.appPrimblue.withValues(
                      alpha: 0.10,
                    ),
                  ).paddingSymmetric(horizontal: 50)
                : campaignController.getLoading.value == true
                ? CupertinoActivityIndicator(
                    color: Appcolors.appPriSecColor.appPrimblue.withValues(
                      alpha: 0.10,
                    ),
                  ).paddingSymmetric(horizontal: 50)
                : campaignController.getcampaignmodel.value!.isPaymentStatus ==
                      "1"
                ? Container(
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Appcolors.appPriSecColor.appPrimblue.withValues(
                        alpha: 0.10,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageController.textTranslate(
                              "Your Store has been sponsored",
                            ),
                            style: AppTypography.text8Medium(context).copyWith(
                              fontSize: 7,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          sizeBoxHeight(2),
                          Text(
                            // "From: 12-06-2025 to 30-06-202",
                            paymentHistoryController.goalData.isNotEmpty
                                ? "From ${paymentHistoryController.goalData[0].startDate.toString()} to ${paymentHistoryController.goalData[0].endDate.toString()}"
                                : "",
                            style: AppTypography.text8Medium(context).copyWith(
                              fontSize: 7,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).paddingSymmetric(vertical: 7).paddingOnly(right: 10)
                : customBtn(
                    onTap: () {
                      Get.to(
                        () => AddCampaign(
                          latt: storeController
                              .storeDetailModel
                              .value
                              .serviceDetails![0]
                              .contactDetails!
                              .lat
                              .toString(),
                          lonn: storeController
                              .storeDetailModel
                              .value
                              .serviceDetails![0]
                              .contactDetails!
                              .lon
                              .toString(),
                          serviceid: storeController
                              .storeDetailModel
                              .value
                              .serviceDetails![0]
                              .businessDetails!
                              .id
                              .toString(),
                          vendorid: storeController
                              .storeDetailModel
                              .value
                              .serviceDetails![0]
                              .businessDetails!
                              .vendorId
                              .toString(),
                          addrss: storeController
                              .storeDetailModel
                              .value
                              .serviceDetails![0]
                              .contactDetails!
                              .address
                              .toString(),
                        ),
                      );
                    },
                    title: "Sponsor Now",
                    fontSize: 11,
                    weight: FontWeight.w500,
                    radius: const BorderRadius.all(Radius.circular(11)),
                    width: getProportionateScreenWidth(140),
                    height: getProportionateScreenHeight(27),
                  ).paddingSymmetric(vertical: 8, horizontal: 10);
          }),
        ],
      ),
    ).paddingSymmetric(horizontal: 13);
  }

  //=========================================================== QUICK LINKS =======================================================================================
  Widget quickLinkWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageController.textTranslate("Quick Links"),
          style: AppTypography.h3(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ).paddingSymmetric(horizontal: 15),
        sizeBoxHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            linkContainer(
              onTap: () {
                Get.to(const EditServiceProfile());
              },
              color: Appcolors.appExtraColor.cFFDCDC,
              img: AppAsstes.vision,
              height: 24,
              title: languageController.textTranslate("Edit Profile"),
            ),
            linkContainer(
              onTap: () {
                Get.to(() => const BusinessImages())!.then((_) {
                  setState(() {
                    storeController.storeDetailModel.refresh();
                    storeController.storeList.refresh();
                  });
                });
              },
              color: Appcolors.appExtraColor.cC5FFCD,
              img: AppAsstes.photo,
              height: 23,
              title: languageController.textTranslate("Add Photos"),
            ),
            linkContainer(
              onTap: () {
                Get.to(() => const ContactDetail())!.then((_) {
                  setState(() {
                    storeController.storeDetailModel.refresh();
                    storeController.storeList.refresh();
                  });
                });
              },
              color: Appcolors.appExtraColor.cDCEBFF,
              img: AppAsstes.contact,
              height: 23,
              title: languageController.textTranslate("Add Contact"),
            ),
            linkContainer(
              onTap: () {
                Get.to(() => const StoreTimeScreen())!.then((_) {
                  setState(() {
                    storeController.storeDetailModel.refresh();
                    storeController.storeList.refresh();
                  });
                });
              },
              color: Appcolors.appExtraColor.cE6DCFF,
              img: AppAsstes.clock1,
              height: 24,
              title: languageController.textTranslate("Business Timings"),
            ),
          ],
        ).paddingSymmetric(horizontal: 30),
        sizeBoxHeight(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            linkContainer(
              onTap: () {
                Get.to(() => const MyReviewScreen());
              },
              color: Appcolors.appExtraColor.cB5E2FF,
              img: AppAsstes.discussion,
              height: 24,
              title: languageController
                  .textTranslate("reviews")
                  .capitalizeFirst!,
            ),
            linkContainer(
              onTap: () {
                Get.to(() => const BusinessWebsite())!.then((_) {
                  setState(() {
                    storeController.storeDetailModel.refresh();
                    storeController.storeList.refresh();
                  });
                });
              },
              color: Appcolors.appExtraColor.cFFDCFD,
              img: AppAsstes.Group,
              height: 23,
              title: languageController.textTranslate("Add Website"),
            ),
            linkContainer(
              onTap: () {
                Get.to(() => const BusinessVideo())!.then((_) {
                  setState(() {
                    storeController.storeDetailModel.refresh();
                    storeController.storeList.refresh();
                  });
                });
              },
              color: Appcolors.appExtraColor.cFFE1AA,
              img: AppAsstes.video,
              height: 23,
              title: languageController.textTranslate("Add Video"),
            ),
            linkContainer(
              onTap: () {
                Get.to(() => const BusinessSocialLink())!.then((_) {
                  setState(() {
                    storeController.storeDetailModel.refresh();
                    storeController.storeList.refresh();
                  });
                });
              },
              color: Appcolors.appExtraColor.cB7FDF7,
              img: AppAsstes.lock1,
              height: 24,
              title: languageController.textTranslate("Add Social Links"),
            ),
          ],
        ).paddingSymmetric(horizontal: 30),
      ],
    );
  }

  Widget linkContainer({
    required Function() onTap,
    required Color color,
    required String img,
    required String title,
    required double height,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: getProportionateScreenHeight(50),
            width: getProportionateScreenWidth(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: color,
            ),
            child: Center(child: Image.asset(img, height: height)),
          ),
          sizeBoxHeight(5),
          SizedBox(
            width: 50,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.text10Medium(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  //===================================================== MY BUSINESS ============================================================================================
  Widget myBusinessWidget() {
    return Container(
      width: Get.width,
      height: appPayment == true
          ? getProportionateScreenHeight(555)
          : getProportionateScreenHeight(455),
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.appBgColor.white
            : Appcolors.appBgColor.darkGray,
        boxShadow: [
          BoxShadow(
            blurRadius: 11.9,
            spreadRadius: 0,
            offset: const Offset(6, 8),
            color: Appcolors.black.withValues(alpha: 0.30),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          sizeBoxHeight(10),
          Container(height: 3, width: 70, color: Appcolors.grey),
          sizeBoxHeight(20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              languageController.textTranslate("My Business"),
              style: AppTypography.h3(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          sizeBoxHeight(20),
          businessContainer(
            onTap: () {
              Get.to(const EditServiceProfile());
            },
            img: AppAsstes.tools,
            title: languageController.textTranslate("Business Tools"),
            subTitle: languageController.textTranslate(
              "Manage Offers, Reviews and more",
            ),
          ),
          sizeBoxHeight(20),
          businessContainer(
            onTap: () {
              Get.to(() => const AllServiceScreen());
            },
            img: AppAsstes.group1,
            title: languageController.textTranslate("Services"),
            subTitle: languageController.textTranslate(
              "Add Services, List, and Edit it",
            ),
          ),
          appPayment == true ? sizeBoxHeight(20) : SizedBox.shrink(),
          appPayment == true
              ? businessContainer(
                  onTap: () {
                    Get.to(() => const PaymentHistory());
                  },
                  img: AppAsstes.payment,
                  title: languageController.textTranslate("Payment History"),
                  subTitle: languageController.textTranslate(
                    "See all the sponsored payment history",
                  ),
                )
              : SizedBox.shrink(),
          sizeBoxHeight(20),
          businessContainer(
            onTap: () {
              Get.to(const Support());
            },
            img: AppAsstes.contact1,
            title: languageController.textTranslate("Support"),
            subTitle: languageController.textTranslate("Connect with Us"),
          ),
        ],
      ).paddingSymmetric(horizontal: 15),
    );
  }

  Widget businessContainer({
    required Function() onTap,
    required String img,
    required String title,
    required String subTitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getProportionateScreenHeight(80),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 0.14,
              spreadRadius: 0,
              offset: const Offset(0.2, 0.4),
              color: themeContro.isLightMode.value
                  ? Appcolors.grey
                  : const Color(0xff0000000f),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.appBgColor.darkMainBlack,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(img, height: 19),
                sizeBoxWidth(15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    sizeBoxHeight(5),
                    Text(
                      subTitle,
                      style: AppTypography.text10Medium(
                        context,
                      ).copyWith(color: Appcolors.appTextColor.textLighGray),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 17,
              color: Appcolors.appPriSecColor.appPrimblue,
            ).paddingOnly(bottom: 15),
          ],
        ).paddingOnly(left: 15, right: 10, top: 15),
      ),
    );
  }

  //================================================== TOP CURRENT LOCATION STATUS WIDGET =========================================================================
  Widget myLocationWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: getProportionateScreenHeight(170),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAsstes.line_design),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Appcolors.appPriSecColor.appPrimblue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${languageController.textTranslate("Hello")}, $userName",
                      style: AppTypography.h1(
                        context,
                      ).copyWith(color: Appcolors.white),
                    ),
                    const SizedBox(height: 4), // Space between text lines
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAsstes.location1,
                          color: Appcolors.white,
                          height: 18,
                        ),
                        Expanded(
                          child: Text(
                            " ${storeController.currentAddress}",
                            style: AppTypography.text10Medium(
                              context,
                            ).copyWith(color: Appcolors.white),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => const Profile(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(44),
                    color: Appcolors.appBgColor.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(44),
                    child: Image.network(
                      userIMAGE,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (
                            BuildContext ctx,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CupertinoActivityIndicator(
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                ),
                              );
                            }
                          },
                      errorBuilder:
                          (
                            BuildContext? context,
                            Object? exception,
                            StackTrace? stackTrace,
                          ) {
                            return containerCapiltal(
                              height: getProportionateScreenHeight(44),
                              width: getProportionateScreenWidth(44),
                              fontSize: 15,
                              text: userName,
                            );
                          },
                    ),
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10),
        ),
        Positioned(bottom: -23, left: 9, child: searchBar()),
      ],
    );
  }

  Widget searchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: TextField(
        controller: searchController,
        style: AppTypography.text12Medium(context),
        onTap: () {
          Get.to(() => SearchServiceScreen());
        },
        readOnly: true,
        decoration: InputDecoration(
          fillColor: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: themeContro.isLightMode.value
                ? BorderSide.none
                : BorderSide(color: Appcolors.greyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: themeContro.isLightMode.value
                ? BorderSide(color: Appcolors.appPriSecColor.appPrimblue)
                : BorderSide(color: Appcolors.greyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeContro.isLightMode.value
                  ? Appcolors.grey300
                  : Appcolors.darkGray,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolors.greyColor, width: 5),
          ),
          hintText: languageController.textTranslate("Search Services"),
          hintStyle: AppTypography.text12Medium(
            context,
          ).copyWith(color: Appcolors.appTextColor.textLighGray),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 15, top: 15),
            child: Image.asset(
              AppAsstes.search,
              color: Appcolors.grey400,
              height: 10,
            ),
          ),
        ),
      ).paddingSymmetric(horizontal: 10),
    );
  }

  Widget animatedCircularProgressIndicator({required double value}) {
    if (Platform.isIOS) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: value),
        duration: const Duration(
          milliseconds: 800,
        ), // Adjust the duration as needed
        builder: (context, animatedValue, child) {
          return CircularProgressIndicator(
            strokeAlign: 2.7,
            strokeWidth: 7,
            strokeCap: StrokeCap.round,
            value: animatedValue,
            backgroundColor: const Color.fromRGBO(113, 239, 180, 0.445),
            valueColor: AlwaysStoppedAnimation<Color>(
              themeContro.isLightMode.value
                  ? Appcolors.appExtraColor.greenColor.withValues(alpha: 0.75)
                  : Appcolors.appExtraColor.c00F884,
            ),
          );
        },
      );
    } else {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: value),
        duration: const Duration(milliseconds: 800),
        builder: (context, animatedValue, child) {
          return CircularProgressIndicator(
            strokeAlign: 2.7,
            strokeWidth: 7,
            strokeCap: StrokeCap.round,
            value: animatedValue,
            backgroundColor: const Color.fromRGBO(113, 239, 180, 0.445),
            valueColor: AlwaysStoppedAnimation<Color>(
              themeContro.isLightMode.value
                  ? Appcolors.appExtraColor.greenColor.withValues(alpha: 0.75)
                  : Appcolors.appExtraColor.c00F884,
            ),
          );
        },
      );
    }
  }
}
