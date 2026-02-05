// ignore_for_file: prefer_const_constructors, unused_element, non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/Vendor/screens/add_store.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/my_review_screen.dart';
import 'package:nlytical/utils/enums.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/language_list.dart';
import 'package:get/get.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/web_view.dart';
import 'package:nlytical/auth/google_signin.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/auth/welcome.dart';
import 'package:nlytical/controllers/user_controllers/appfeedback_contro.dart';
import 'package:nlytical/controllers/user_controllers/chat_contro.dart';
import 'package:nlytical/controllers/user_controllers/delete_contro.dart';
import 'package:nlytical/controllers/user_controllers/feedback_contro.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/controllers/user_controllers/privacy_contro.dart';
import 'package:nlytical/controllers/user_controllers/terms_contro.dart';
import 'package:nlytical/auth/login.dart';
import 'package:nlytical/User/screens/favourite/favourite.dart';
import 'package:nlytical/User/screens/review/my_review.dart';
import 'package:nlytical/User/screens/settings/profile.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_widgets.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/slider_custom.dart';
import 'package:nlytical/Vendor/screens/auth/subcription.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Vendor/screens/auth/subcription.dart';
import '../../../Vendor/screens/new_tabber.dart/web_view.dart';
import '../../../utils/global.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  GetprofileContro getprofilecontro = Get.find();
  DeleteController deletecontro = Get.find();
  PrivacyPolicyContro privacycontro = Get.find();
  ChatController messageController = Get.find();
  TermsContro termscontro = Get.find();
  bool themeSwitch_noti = false;

  FeedbackContro feedbackContro = Get.find();
  TextEditingController msgController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getprofilecontro.updateProfileOne();
      getprofilecontro.getprofileApi();
      privacycontro.privacypolicyApi();
      termscontro.termsandcondiApi();
    });
    super.initState();
  }

  String themeNote = themeContro.isLightMode.value
      ? " (Light Theme)"
      : " (Dark Theme)";

  File? file;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Obx(() {
          return Scaffold(
            extendBody: true,
            backgroundColor: themeContro.isLightMode.value
                ? Appcolors.appBgColor.white
                : Appcolors.darkMainBlack,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(65),
              child: AppBar(
                centerTitle: true,
                title: Text(
                  languageController.textTranslate("Settings"),
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
                  sizeBoxHeight(10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          sizeBoxHeight(10),
                          userID.isEmpty
                              ? Column(
                                  children: [
                                    Center(
                                      child: customProfileImage(
                                        height: getProportionateScreenHeight(
                                          100,
                                        ),
                                        width: getProportionateScreenWidth(100),
                                        img: "",
                                      ),
                                    ),
                                    sizeBoxHeight(10),
                                    Text(
                                      languageController.textTranslate('Guest'),
                                      style: AppTypography.text12Medium(
                                        context,
                                      ),
                                    ),
                                    sizeBoxHeight(5),
                                  ],
                                )
                              : profileImage(context),
                          sizeBoxHeight(20),
                          profiledetail(),
                          sizeBoxHeight(70),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget profileImage(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              userIMAGE.isNotEmpty
                  ? customProfileImage(
                      height: getProportionateScreenHeight(100),
                      width: getProportionateScreenWidth(100),
                      img: userIMAGE.toString(),
                    )
                  : Container(
                      height: getProportionateScreenHeight(100),
                      width: getProportionateScreenWidth(100),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Appcolors.appOppaColor.appPrimOppacity,
                      ),
                      child: Center(
                        child: Text(
                          getFirstCapitalLetter(userName),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins",
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textBlack
                                : Appcolors.appTextColor.textWhite,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        sizeBoxHeight(10),
        userName.isNotEmpty
            ? Text(
                userName.toString(),
                style: AppTypography.text12Medium(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                ),
              )
            : SizedBox.shrink(),
        sizeBoxHeight(5),
        userEmail.isNotEmpty
            ? Text(
                userEmail.toString(),
                style: AppTypography.text12Medium(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget profiledetail() {
    void handleURLButtonPress(BuildContext context, String url, title) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivacyWebView(htmlContent: url, title: title),
        ),
      );
    }

    return Column(
      children: [
        //***********************************List your Business For*************************************** */
        appPayment == true
            ? GestureDetector(
                onTap: () {
                  if (userID.isEmpty) {
                    snackBar(
                      languageController.textTranslate(
                        'Please login to access to add store',
                      ),
                    );
                    // loginPopup(bottomsheetHeight: Get.height * 0.95);
                    Get.to(
                      const Login(isLogin: true),
                      transition: Transition.rightToLeft,
                    );
                  } else {
                    if (subscribedUserGlobal == 0) {
                      roleController.isVendorSelected();
                      Get.offAll(
                        () => TabbarScreen(currentIndex: 0),
                        transition: Transition.rightToLeft,
                      )!.then((_) {
                        setState(() {});
                      });
                    } else if (isStoreGlobal == 0) {
                      // if (isDemo == "false") {
                      //   Get.to(
                      //     () => AddStore(),
                      //     transition: Transition.rightToLeft,
                      //   )!.then((_) {
                      //     setState(() {});
                      //   });
                      // } else {
                      //   Get.offAll(
                      //     () => TabbarScreen(currentIndex: 0),
                      //     transition: Transition.rightToLeft,
                      //   )!.then((_) {
                      //     setState(() {});
                      //   });
                      // }
                      Get.to(
                        () => AddStore(),
                        transition: Transition.rightToLeft,
                      )!.then((_) {
                        setState(() {});
                      });
                    } else {
                      roleController.isVendorSelected();
                      Get.offAll(
                        () => TabbarScreen(currentIndex: 0),
                        transition: Transition.rightToLeft,
                      )!.then((_) {
                        setState(() {});
                      });
                    }
                  }
                },
                child: Container(
                  height: 45,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: themeContro.isLightMode.value
                        ? Border(
                            bottom: BorderSide(
                              color: Appcolors.appBgColor.transparent,
                            ),
                          )
                        : Border(bottom: BorderSide(color: Appcolors.white)),
                    color: themeContro.isLightMode.value
                        ? Appcolors.appOppaColor.appPrimOppacity
                        : Appcolors.appPriSecColor.appPrimblue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AppAsstes.settingUserIcons.shopAdd,
                            height: 16,
                            width: 16,
                            color: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                          ),
                          sizeBoxWidth(7),
                          Text(
                            subscribedUserGlobal == 0
                                ? languageController.textTranslate(
                                    'My Dashboard',
                                  )
                                : isStoreGlobal == 0
                                ? languageController.textTranslate(
                                    'List your Business',
                                  )
                                : languageController.textTranslate(
                                    'My Dashboard',
                                  ),
                            style: AppTypography.text12Medium(context).copyWith(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appTextColor.textBlack
                                  : Appcolors.appTextColor.textWhite,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        userTextDirection == "ltr"
                            ? AppAsstes.settingUserIcons.arrowLeft
                            : AppAsstes.settingUserIcons.arrowLeft1,
                        color: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.white,
                        height: 16,
                        width: 16,
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 15),
                ),
              )
            : SizedBox.shrink(),
        sizeBoxHeight(15),
        //*********************************** Profile ************************************** */
        setting(
          context,
          imagepath: AppAsstes.settingUserIcons.profile,
          name: languageController.textTranslate('Profile'),
          buttonOnTap: () {
            if (userID.isEmpty) {
              snackBar(
                languageController.textTranslate(
                  'Please login to access to profile',
                ),
              );
              // loginPopup(bottomsheetHeight: Get.height * 0.95);
              Get.to(
                const Login(isLogin: true),
                transition: Transition.rightToLeft,
              );
            } else {
              Get.to(() => Profile(), transition: Transition.rightToLeft);
            }
          },
        ),
        sizeBoxHeight(15),
        //************************************* Favorites ***************************************/
        setting(
          context,
          imagepath: AppAsstes.heart,
          name: languageController.textTranslate('Favorites'),
          buttonOnTap: () {
            if (userID.isEmpty) {
              snackBar(
                languageController.textTranslate(
                  'Please login to access to favourite',
                ),
              );
              // loginPopup(bottomsheetHeight: Get.height * 0.95);
              Get.to(
                const Login(isLogin: true),
                transition: Transition.rightToLeft,
              );
            } else {
              Get.to(
                () => Favourite(tap: true),
                transition: Transition.rightToLeft,
              );
            }
          },
        ),
        sizeBoxHeight(15),
        //**************************************** My Review *********************************************/
        appPayment == true
            ? setting(
                context,
                imagepath: AppAsstes.settingUserIcons.starBorder,
                name: roleController.isUser.value
                    ? languageController.textTranslate('My Review')
                    : subscribedUserGlobal == 0
                    ? languageController.textTranslate('My Review')
                    : isStoreGlobal == 0
                    ? languageController.textTranslate('My Review')
                    : languageController.textTranslate("Business Review"),
                buttonOnTap: () {
                  if (userID.isEmpty) {
                    snackBar(
                      languageController.textTranslate(
                        'Please login to access Review',
                      ),
                    );
                    // loginPopup(bottomsheetHeight: Get.height * 0.95);
                    Get.to(
                      const Login(isLogin: true),
                      transition: Transition.rightToLeft,
                    );
                  } else {
                    if (roleController.isUser.value) {
                      Get.to(
                        () => Review(),
                        transition: Transition.rightToLeft,
                      );
                    } else {
                      if (subscribedUserGlobal == 0) {
                        Get.to(
                          () => Review(),
                          transition: Transition.rightToLeft,
                        );
                      } else if (isStoreGlobal == 0) {
                        Get.to(
                          () => Review(),
                          transition: Transition.rightToLeft,
                        );
                      } else {
                        Get.to(() => const MyReviewScreen());
                      }
                    }
                  }
                },
              )
            : setting(
                context,
                imagepath: AppAsstes.settingUserIcons.starBorder,
                name: languageController.textTranslate('My Review'),
                buttonOnTap: () {
                  if (userID.isEmpty) {
                    snackBar(
                      languageController.textTranslate(
                        'Please login to access Review',
                      ),
                    );
                    // loginPopup(bottomsheetHeight: Get.height * 0.95);
                    Get.to(
                      const Login(isLogin: true),
                      transition: Transition.rightToLeft,
                    );
                  } else {
                    if (roleController.isUser.value) {
                      ("1");
                      Get.to(
                        () => Review(),
                        transition: Transition.rightToLeft,
                      );
                    }
                  }
                },
              ),
        sizeBoxHeight(15),
        //******************************** Subscription ********************************** */
        appPayment == true
            ? InkWell(
                onTap: () {
                  if (userID.isEmpty) {
                    snackBar(
                      languageController.textTranslate(
                        'Please login to become vendor',
                      ),
                    );
                    // loginPopup(bottomsheetHeight: Get.height * 0.95);
                    Get.to(
                      const Login(isLogin: true),
                      transition: Transition.rightToLeft,
                    );
                  } else {
                    getprofilecontro.updateProfileOne();
                    Get.to(
                      () => SubscriptionSceen(),
                      transition: Transition.rightToLeft,
                    )!.then((_) {
                      setState(() {});
                    });
                  }
                },
                child: Container(
                  height: 45,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Appcolors.white),
                    color: themeContro.isLightMode.value
                        ? Appcolors.white
                        : Appcolors.darkGray,
                    boxShadow: [
                      BoxShadow(
                        color: themeContro.isLightMode.value
                            ? Appcolors.grey300
                            : Appcolors.darkShadowColor,
                        blurRadius: 14.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                          2.0,
                          4.0,
                        ), // shadow direction: bottom right
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AppAsstes.settingUserIcons.dollar,
                            height: 16,
                            width: 16,
                            color: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                          ),
                          sizeBoxWidth(6),
                          Text(
                            languageController.textTranslate('Subscription'),
                            style: AppTypography.text12Medium(context).copyWith(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appTextColor.textBlack
                                  : Appcolors.appTextColor.textWhite,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Container(
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: userID.isEmpty
                                    ? Appcolors.appExtraColor.yellowColor
                                          .withValues(alpha: 0.29)
                                    : (subscribedUserGlobal == 0 &&
                                          userRole == "user")
                                    ? Appcolors.appExtraColor.yellowColor
                                          .withValues(alpha: 0.29)
                                    : userRole == "user"
                                    ? Appcolors.appExtraColor.yellowColor
                                          .withValues(alpha: 0.29)
                                    : (subscribedUserGlobal == 0 &&
                                          userRole == "vendor")
                                    ? Colors.red
                                    : subscribedUserGlobal == 0
                                    ? Colors.red
                                    : Appcolors.appPriSecColor.appPrimblue
                                          .withValues(alpha: 0.29),
                              ),
                              child: Center(
                                child: getprofilecontro.isupdate.value
                                    ? CupertinoActivityIndicator()
                                    : Text(
                                        userID.isEmpty
                                            ? "Become Vendor"
                                            : (subscribedUserGlobal == 0 &&
                                                  userRole == "user")
                                            ? "Become Vendor"
                                            : userRole == "user"
                                            ? "Become Vendor"
                                            : (subscribedUserGlobal == 0 &&
                                                  userRole == "vendor")
                                            ? "Expired"
                                            : subscribedUserGlobal == 0
                                            ? "Expired"
                                            : getprofilecontro
                                                  .updatemodel1
                                                  .value!
                                                  .subscriptionDetails!
                                                  .planName!,
                                        maxLines: 1,
                                        style:
                                            AppTypography.text8Medium(
                                              context,
                                            ).copyWith(
                                              color: userRole == "user"
                                                  ? Appcolors
                                                        .appTextColor
                                                        .textBlack
                                                  : subscribedUserGlobal == 0
                                                  ? Appcolors
                                                        .appTextColor
                                                        .textBlack
                                                  : themeContro
                                                        .isLightMode
                                                        .value
                                                  ? Appcolors
                                                        .appPriSecColor
                                                        .appPrimblue
                                                  : Appcolors
                                                        .appTextColor
                                                        .textWhite,
                                            ),
                                      ),
                              ).paddingSymmetric(horizontal: 10),
                            ),
                          ),
                          Image.asset(
                            userTextDirection == "ltr"
                                ? 'assets/images/arrow-left (1).png'
                                : "assets/images/arrow-left1.png",
                            color: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            height: 16,
                            width: 16,
                          ),
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 15),
                ),
              )
            : SizedBox.shrink(),
        appPayment == true ? sizeBoxHeight(15) : SizedBox.shrink(),
        //************************************ Privacy & Policy ******************************* */
        setting(
          context,
          imagepath: AppAsstes.lock2,
          name: languageController.textTranslate('Privacy & Policy'),
          buttonOnTap: () {
            handleURLButtonPress(
              context,
              privacycontro.privacymodel.value!.data![0].text!,
              languageController.textTranslate('Privacy & Policy'),
            );
          },
        ),
        sizeBoxHeight(15),
        //*********************************** Terms & Condition ******************************************* */
        setting(
          context,
          imagepath: AppAsstes.settingUserIcons.termCond,
          name: languageController.textTranslate('Terms & Condition'),
          buttonOnTap: () {
            handleURLButtonPress(
              context,
              termscontro.termsdata[0].text!,
              languageController.textTranslate('Terms & Condition'),
            );
          },
        ),
        sizeBoxHeight(15),
        themeContro.lightDarkModeSwitch(isVendor: false),
        sizeBoxHeight(15),
        // ******************************** App Language ****************************************************
        setting(
          context,
          imagepath: AppAsstes.settingUserIcons.langSquare,
          name: languageController.textTranslate('App Language'),
          buttonOnTap: () {
            if (userID.isEmpty) {
              snackBar(
                languageController.textTranslate(
                  'Please login to access language translation',
                ),
              );
              loginPopup(bottomsheetHeight: Get.height * 0.95);
            } else {
              bottomSheetGobal(
                context,
                bottomsheetHeight: languageController.languagesList.length > 5
                    ? Get.height * 0.48
                    : Get.height * 0.40,
                title: languageController.textTranslate('App Language'),
                child: LanguagePopUp(userType: UserType.isUser),
              );
            }
          },
        ),
        sizeBoxHeight(15),
        // *************************************** Share App ********************************************************
        setting(
          context,
          imagepath: AppAsstes.settingUserIcons.share1,
          name: languageController.textTranslate('Share App'),
          buttonOnTap: () {
            if (userID.isEmpty) {
              snackBar(
                languageController.textTranslate(
                  'Please login to access to profile',
                ),
              );
              // loginPopup(bottomsheetHeight: Get.height * 0.95);
              Get.to(
                const Login(isLogin: true),
                transition: Transition.rightToLeft,
              );
            } else {
              Platform.isIOS
                  ? Share.share(appIOSurl)
                  : Share.share("$appAndroidUrl$themeNote");
            }
          },
        ),
        sizeBoxHeight(15),
        //*********************************** App Feedback **************************************** */
        setting(
          context,
          imagepath: AppAsstes.settingUserIcons.feedback,
          name: languageController.textTranslate('App Feedback'),
          buttonOnTap: () {
            if (userID.isEmpty) {
              snackBar(
                languageController.textTranslate(
                  'Please login to access to profile',
                ),
              );
              // loginPopup(bottomsheetHeight: Get.height * 0.95);
              Get.to(
                const Login(isLogin: true),
                transition: Transition.rightToLeft,
              );
            } else {
              bottomSheetGobal(
                context,
                bottomsheetHeight: Get.height * 0.7,
                title: languageController.textTranslate(
                  "Nlytical App Feedback",
                ),
                child: appFeedback(),
              );
            }
          },
        ),
        sizeBoxHeight(15),
        // ************************************ App Version ******************************************************
        Container(
          height: 45,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: Appcolors.white),
            color: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkGray,
            boxShadow: [
              BoxShadow(
                color: themeContro.isLightMode.value
                    ? Appcolors.grey300
                    : Appcolors.darkShadowColor,
                blurRadius: 14.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 4.0), // shadow direction: bottom right
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    AppAsstes.settingUserIcons.appVersion,
                    height: 16,
                    width: 16,
                    color: themeContro.isLightMode.value
                        ? Appcolors.black
                        : Appcolors.white,
                  ),
                  sizeBoxWidth(6),
                  Text(
                    languageController.textTranslate('App Version'),
                    style: AppTypography.text12Medium(context).copyWith(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appTextColor.textBlack
                          : Appcolors.appTextColor.textWhite,
                    ),
                  ),
                ],
              ),
              Text(
                "1.0.0",
                style: AppTypography.text11Regular(
                  context,
                ).copyWith(color: Appcolors.appTextColor.textLighGray),
              ),
            ],
          ).paddingSymmetric(horizontal: 15),
        ),
        sizeBoxHeight(15),
        // **************************************** Logout button **************************************************
        userID.isEmpty
            ? SizedBox.shrink()
            : InkWell(
                onTap: () {
                  bottomSheetGobal(
                    context,
                    bottomsheetHeight: 250,
                    title: languageController.textTranslate("Logout"),
                    child: openBottomDailog(isDeleteParameter: false),
                  );
                },
                child: Container(
                  height: 45,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                    color: themeContro.isLightMode.value
                        ? Appcolors.white
                        : Appcolors.darkGray,
                    boxShadow: [
                      BoxShadow(
                        color: themeContro.isLightMode.value
                            ? Appcolors.grey300
                            : Appcolors.darkShadowColor,
                        blurRadius: 14.0,
                        spreadRadius: 0.0,
                        offset: Offset(2.0, 4.0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(AppAsstes.logout, height: 16, width: 16),
                      sizeBoxWidth(6),
                      Text(
                        languageController.textTranslate("Logout"),
                        style: AppTypography.text12Medium(
                          context,
                        ).copyWith(color: Appcolors.appTextColor.textRedColor),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 15),
                ),
              ),
        sizeBoxHeight(20),
        userID.isEmpty
            ? Center(
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      const Login(isLogin: true),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    width: Get.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: themeContro.isLightMode.value
                          ? Border.all(
                              color: Appcolors.appPriSecColor.appPrimblue,
                            )
                          : Border(
                              bottom: BorderSide(
                                color: Appcolors.appBgColor.transparent,
                              ),
                            ),
                      color: themeContro.isLightMode.value
                          ? Appcolors.appBgColor.transparent
                          : Appcolors.appPriSecColor.appPrimblue,
                    ),
                    child: Center(
                      child: label(
                        languageController.textTranslate("Login"),
                        textColor: themeContro.isLightMode.value
                            ? Appcolors.appPriSecColor.appPrimblue
                            : Appcolors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: GestureDetector(
                  onTap: () {
                    if (getprofilecontro.getprofilemodel.value!.isDemo ==
                        "false") {
                      bottomSheetGobal(
                        context,
                        bottomsheetHeight: 250,
                        title: languageController.textTranslate(
                          "Delete Account",
                        ),
                        child: openBottomDailog(isDeleteParameter: true),
                      );
                    } else {
                      snackBar("This is for demo, We can not allow to delete");
                    }
                  },
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: themeContro.isLightMode.value
                          ? Border.all(
                              color: Appcolors.appPriSecColor.appPrimblue,
                            )
                          : Border(
                              bottom: BorderSide(
                                color: Appcolors.appBgColor.transparent,
                              ),
                            ),
                      color: themeContro.isLightMode.value
                          ? Appcolors.appBgColor.transparent
                          : Appcolors.appPriSecColor.appPrimblue,
                    ),
                    child: Center(
                      child: label(
                        languageController.textTranslate("Delete"),
                        textColor: themeContro.isLightMode.value
                            ? Appcolors.appPriSecColor.appPrimblue
                            : Appcolors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 40),
              ),
        // sizeBoxHeight(10),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Column openBottomDailog({required bool isDeleteParameter}) {
    return Column(
      children: [
        sizeBoxHeight(20),
        Center(
          child: Text(
            isDeleteParameter
                ? languageController.textTranslate(
                    "Are you sure you want to \nDelete Account ?",
                  )
                : languageController.textTranslate(
                    "Are you sure you want to \nLogout Account?",
                  ),
            textAlign: TextAlign.center,
            style: AppTypography.text14Medium(context).copyWith(
              color: themeContro.isLightMode.value
                  ? Appcolors.appTextColor.textLighGray
                  : Appcolors.appTextColor.textWhite,
            ),
          ),
        ),
        sizeBoxHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonBorder(
              title: languageController.textTranslate("Cancel"),
              onPressed: () => Get.back(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: getProportionateScreenHeight(42),
              width: getProportionateScreenWidth(140),
              fontColor: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
            ),
            sizeBoxWidth(25),
            InkWell(
              onTap: () async {
                if (isDeleteParameter) {
                  // messageController.onlineuser(onlineStatus: "0");
                  deletecontro.deleteApi();
                } else {
                  deletecontro.isLogout.value = true;
                  // messageController.onlineuser(onlineStatus: "0");
                  await SecurePrefs.clear();
                  userEmail = '';
                  userID = '';
                  userIMAGE = '';
                  image_status = '';
                  subscribedUserGlobal = 0;
                  isStoreGlobal = 0;
                  await SecurePrefs.remove(SecureStorageKeys.USER_ID);
                  await SecurePrefs.setString(SecureStorageKeys.lnId, "1");

                  await languageController.getLanguageTranslation(lnId: "1");
                  if (!themeContro.isLightMode.value) {
                    await themeContro.toggleThemeMode(true);
                  }
                  languageController.updateTextDirection();
                  languageController.languageTranslationsData.refresh();

                  await FirebaseMessaging.instance.deleteToken();
                  signOutGoogle();
                  roleController.isUserSelected();
                  deletecontro.isLogout.value = false;
                  Get.back();
                  Get.offAll(() => const Welcome());
                }
              },
              child: Container(
                height: getProportionateScreenHeight(44),
                width: getProportionateScreenWidth(140),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Appcolors.appPriSecColor.appPrimblue,
                ),
                child: Center(
                  child: Obx(() {
                    bool isLoading = isDeleteParameter
                        ? deletecontro.isdelete.value
                        : deletecontro.isLogout.value;
                    return isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: commonLoadingWhite(),
                          )
                        : Text(
                            isDeleteParameter
                                ? languageController.textTranslate("Delete")
                                : languageController.textTranslate("Logout"),
                            style: poppinsFont(
                              14,
                              Appcolors.appTextColor.textWhite,
                              FontWeight.w400,
                            ),
                          );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  appFeedback() {
    final AppfeedbackContro appfeedbackContro = Get.find();
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageController.textTranslate(
                'Feel Free to share your feedback with Us',
              ),
              style: AppTypography.outerMedium(context),
            ),
            sizeBoxHeight(15),
            Container(
              height: 125,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Appcolors.grey200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(appfeedbackContro.emojis.length, (
                      index,
                    ) {
                      return Opacity(
                        opacity:
                            appfeedbackContro.sliderValue.value.round() ==
                                index + 1
                            ? 1.0
                            : 0.3, // Adjust opacity based on sliderValue
                        child: Column(
                          children: [
                            Text(
                              appfeedbackContro.emojis[index],
                              style: const TextStyle(fontSize: 25),
                            ),
                            if (appfeedbackContro.sliderValue.value.round() ==
                                index + 1)
                              label(
                                appfeedbackContro.emojiLabels[index],
                                fontSize: 10,
                                textColor: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                fontWeight: FontWeight.w500,
                              ), // Show label for the selected emoji
                          ],
                        ),
                      );
                    }),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackShape: GradientRectSliderTrackShape(
                        gradient: Appcolors.logoColorWith60Opacity1,
                        darkenInactive: true,
                      ),
                      thumbShape: CustomThumbShape(),
                    ),
                    child: Slider(
                      // thumbColor: Appcolors.white,
                      min: 1.0,
                      divisions: appfeedbackContro.emojis.length - 1,
                      max: appfeedbackContro.emojis.length.toDouble(),
                      value: appfeedbackContro.sliderValue.value.clamp(
                        1.0,
                        appfeedbackContro.emojis.length.toDouble(),
                      ),
                      onChanged: (value) {
                        appfeedbackContro.sliderValue.value = value;
                        (
                          'Select Review :- ${appfeedbackContro.sliderValue.toString().replaceAll(".0", "")}',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            sizeBoxHeight(10),
            TextFormField(
              cursorColor: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              autofocus: false,
              controller: msgController,
              style: TextStyle(
                fontSize: 14,
                color: themeContro.isLightMode.value
                    ? Appcolors.black
                    : Appcolors.white,
                fontWeight: FontWeight.w400,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: false,
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Appcolors.grey200),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Appcolors.grey200),
                ),
                hintText: languageController.textTranslate(
                  "Write Your Review....",
                ),
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Appcolors.grey400,
                  fontWeight: FontWeight.w400,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Appcolors.grey200),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Appcolors.grey200),
                ),
                errorStyle: TextStyle(
                  color: Appcolors.appTextColor.textRedColor,
                  fontSize: 10,
                ),
              ),
            ),
            sizeBoxHeight(15),
            Obx(() {
              return feedbackContro.isfeedback.value
                  ? Center(child: commonLoading())
                  : GestureDetector(
                      onTap: () async {
                        final success = await feedbackContro.feedbackApi(
                          appfeedbackContro.sliderValue.toString().replaceAll(
                            ".0",
                            "",
                          ),
                          msgController.text,
                        );
                        if (success) {
                          ("success");
                          msgController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Center(
                        child: Container(
                          height: getProportionateScreenHeight(50),
                          width: getProportionateScreenWidth(250),
                          decoration: BoxDecoration(
                            color: Appcolors.appPriSecColor.appPrimblue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: label(
                              languageController.textTranslate('Send'),
                              fontSize: 14,
                              textColor: Appcolors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      );
    });
  }
}
