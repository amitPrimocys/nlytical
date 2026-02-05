// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:ui';

import 'package:nlytical/utils/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/apple_signin.dart';
import 'package:nlytical/auth/demo_login_widget.dart';
import 'package:nlytical/auth/google_signin.dart';
import 'package:nlytical/controllers/user_controllers/home_contro.dart';
import 'package:nlytical/controllers/user_controllers/login_contro.dart';
import 'package:nlytical/auth/forgotpass.dart';
import 'package:nlytical/auth/mobile.dart';
import 'package:nlytical/auth/register.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:permission_handler/permission_handler.dart';

import '../shared_preferences/shared_prefkey.dart';
import 'google_signin.dart';

class Login extends StatefulWidget {
  final bool isLogin;
  const Login({super.key, required this.isLogin});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool isTermsPrivacy = false;

  LoginContro logincontro = Get.find();
  HomeContro homeContro = Get.find();

  bool isselected = false;

  void fieldcheck() {
    setState(() {
      isselected =
          emailcontroller.text.isEmail && passcontroller.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    _getToken();
    dataAdd();
    requestPermission();
    homeContro.checkLocationPermission(isRought: true);
    emailcontroller.addListener(fieldcheck);
    passcontroller.addListener(fieldcheck);
    super.initState();
  }

  Future<void> requestPermission() async {
    await Permission.notification.request();
    // await Permission.location.request();
    // await Permission.camera.request();
    // await Permission.photos.request();
  }

  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String _fcmtoken = "";
  void _getToken() {
    firebaseMessaging.getToken().then((token) async {
      setState(() {
        _fcmtoken = token!;
      });

      await SecurePrefs.setString(
        SecureStorageKeys.DEVICE_TOKEN,
        _fcmtoken.toString(),
      );
      await SecurePrefs.getMultipleAndSetGlobalsWithMap({
        SecureStorageKeys.DEVICE_TOKEN: (v) => deviceToken = v!,
      });
    });
  }

  String demoLoginEmail = "john@demo.com";
  String demoLoginPass = "123456";

  void unFocus() {
    signUpPasswordFocusNode.unfocus();
    signUpEmailIDFocusNode.unfocus();
    passFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }

  void dataAdd() async {
    if (countryFlagCode.isEmpty) {
      contrycode = '+1';
      countryFlagCode = 'US';
      await SecurePrefs.setString(
        SecureStorageKeys.COUINTRY_FLAG_CODE,
        countryFlagCode,
      );
      await SecurePrefs.setString(SecureStorageKeys.COUINTRY_CODE, contrycode);
    }
    await SecurePrefs.getLoadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Appcolors.appBgColor.transparent,
        statusBarIconBrightness: Brightness.dark, // black icons
        statusBarBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            color: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkMainBlack,
            image: const DecorationImage(
              image: AssetImage(AppAsstes.appbackground),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Appcolors.appBgColor.transparent,
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    widget.isLogin ? sizeBoxHeight(5) : SizedBox.shrink(),
                    widget.isLogin
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Image.asset(
                                    'assets/images/arrow-left1.png',
                                    height: 24,
                                  ).paddingAll(5),
                                ),
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 20)
                        : SizedBox.shrink(),
                    widget.isLogin ? SizedBox.shrink() : sizeBoxHeight(20),
                    CachedNetworkImage(
                      imageUrl: appLogo,
                      placeholder: (context, url) {
                        return SizedBox.shrink();
                      },
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          AppAsstes.logo,
                          height: 55,
                          width: 180,
                          fit: BoxFit.contain,
                        );
                      },
                    ).paddingSymmetric(horizontal: 100),
                    sizeBoxHeight(15),
                    Center(
                      child: Text(
                        "Discover more about our app by registering or logging in",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: AppTypography.text12Ragular(
                          context,
                        ).copyWith(color: Appcolors.appTextColor.textDarkGrey),
                      ),
                    ).paddingSymmetric(horizontal: 40),
                    sizeBoxHeight(20),
                    globalTextField(
                      key: emailFieldKey,
                      lable: "Email Address",
                      lable2: ' *',
                      controller: emailcontroller,
                      onEditingComplete: () {
                        FocusScope.of(
                          context,
                        ).requestFocus(signUpPasswordFocusNode);
                      },
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          (emailFieldKey.currentState)?.validate();
                        }
                      },
                      isOnlyRead: emailLoginStatus == "1" ? false : true,
                      isEmail: true,
                      focusNode: signUpEmailIDFocusNode,
                      hintText: 'Email Address',
                      context: context,
                      imagePath: 'assets/images/sms.png',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Appcolors.appExtraColor.cB4B4B4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/sms.png',
                              color: Appcolors.grey500,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 20),
                    sizeBoxHeight(12),
                    globalTextField(
                      key: passwordFieldKey,
                      lable: "Password",
                      lable2: ' *',
                      controller: passcontroller,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      focusNode: passFocusNode,
                      hintText: 'Password',
                      isOnlyRead: emailLoginStatus == "1" ? false : true,
                      context: context,
                      imagePath: 'assets/images/sms.png',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Appcolors.appExtraColor.cB4B4B4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/lock.png',
                              color: Appcolors.grey500,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 20),
                    sizeBoxHeight(20),

                    //=========== FORGOT PWD
                    forgetPassField(),
                    sizeBoxHeight(25),
                    emailLoginStatus == "1"
                        ? Obx(() {
                            return logincontro.isLoading.value
                                ? commonLoading()
                                : GestureDetector(
                                    onTap: () {
                                      final isEmailValid =
                                          emailFieldKey.currentState
                                              ?.validate() ??
                                          false;
                                      final isPasswordValid =
                                          passwordFieldKey.currentState
                                              ?.validate() ??
                                          false;
                                      FocusScope.of(context).unfocus();
                                      unFocus();
                                      if (isEmailValid && isPasswordValid) {
                                        logincontro.loginApi(
                                          email: emailcontroller.text,
                                          password: passcontroller.text,
                                        );
                                      } else {
                                        snackBar(
                                          "Please fill the mandatory fields",
                                        );
                                      }
                                    },

                                    child: Container(
                                      height: getProportionateScreenHeight(48),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),

                                        gradient: isselected
                                            ? Appcolors.logoColork
                                            : Appcolors.logoColorWith60Opacityk,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Sign In",
                                          style: AppTypography.text16(context)
                                              .copyWith(
                                                fontSize: 14,
                                                color: Appcolors
                                                    .appTextColor
                                                    .textWhite,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ).paddingSymmetric(horizontal: 60);
                          })
                        : SizedBox.shrink(),
                    emailLoginStatus == "1"
                        ? sizeBoxHeight(25)
                        : SizedBox.shrink(),
                    forDemoField(
                      isForEmail: true,
                      email: demoLoginEmail,
                      phone: "+1-4673974998",
                      pwdOtp: demoLoginPass,
                      onTap: () {
                        emailcontroller.text = demoLoginEmail;
                        passcontroller.text = demoLoginPass;
                      },
                    ).paddingSymmetric(horizontal: 30),
                    sizeBoxHeight(15),
                    appleLoginStatus == "1" ||
                            googleLoginStatus == "1" ||
                            mobileLoginStatus == "1"
                        ? orTextField()
                        : SizedBox.shrink(),
                    appleLoginStatus == "1" ||
                            googleLoginStatus == "1" ||
                            mobileLoginStatus == "1"
                        ? sizeBoxHeight(15)
                        : SizedBox.shrink(),
                    googleLoginStatus == "1"
                        ? Obx(
                            () => logincontro.isSocialLogin.value
                                ? googleLoading()
                                : googleBtn(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      unFocus();

                                      await signInWithGoogle(context);
                                    },
                                    title: "Sign in with Google",
                                    img: 'assets/images/google.png',
                                  ),
                          )
                        : SizedBox.shrink(),
                    googleLoginStatus == "1"
                        ? sizeBoxHeight(15)
                        : SizedBox.shrink(),
                    appleLoginStatus == "1"
                        ? Platform.isIOS
                              ? Obx(
                                  () => logincontro.isApplLogin.value
                                      ? googleLoading()
                                      : googleBtn(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            unFocus();

                                            await AppleSignInService()
                                                .signInWithApple(context);
                                          },
                                          title: "Sign in with Apple",
                                          img: 'assets/images/apple.png',
                                        ),
                                )
                              : SizedBox.shrink()
                        : SizedBox.shrink(),
                    appleLoginStatus == "1"
                        ? Platform.isIOS
                              ? sizeBoxHeight(15)
                              : SizedBox.shrink()
                        : SizedBox.shrink(),
                    mobileLoginStatus == "1"
                        ? googleBtn(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              unFocus();
                              Get.to(
                                const Mobile(),
                                transition: Transition.rightToLeft,
                              );
                            },
                            title: "Sign in with Phone Number",
                            img: 'assets/images/call1.png',
                          )
                        : SizedBox.shrink(),
                    // SizedBox(height: Get.height * 0.05),
                  ],
                ),
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: AppTypography.text12Ragular(context),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      unFocus();
                      Get.to(
                        () => const Register(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: AppTypography.text14Medium(context).copyWith(
                        color: Appcolors.appPriSecColor.appPrimblue,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(bottom: 10),
            ),
          ),
        ),
      ),
    );
  }

  Widget googleBtn({
    required Function() onTap,
    required String title,
    required String img,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getProportionateScreenHeight(47),
        decoration: BoxDecoration(
          border: Border.all(
            color: themeContro.isLightMode.value
                ? Appcolors.appPriSecColor.appPrimblue
                : Appcolors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(img, height: 15),
            sizeBoxWidth(10),
            Text(
              title,
              maxLines: 2,
              style: AppTypography.text14Medium(context).copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    ).paddingSymmetric(horizontal: 60);
  }

  Widget forgetPassField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isTermsPrivacy = !isTermsPrivacy;
            });
          },
          splashColor: Appcolors.appBgColor.transparent,
          highlightColor: Appcolors.appBgColor.transparent,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: isTermsPrivacy
                      ? Appcolors.appPriSecColor.appPrimblue
                      : Appcolors.appBgColor.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: isTermsPrivacy
                      ? null
                      : Border.all(color: Appcolors.greyColor),
                ),
                child: isTermsPrivacy
                    ? Center(
                        child: Icon(
                          Icons.check_rounded,
                          color: Appcolors.white,
                          size: 15,
                        ),
                      )
                    : Container(),
              ),
              const SizedBox(width: 5),
              Text(
                "Remember me",
                style: TextStyle(
                  fontSize: 12,
                  color: Appcolors.grey,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        ),
        emailLoginStatus == "1"
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  unFocus();
                  Get.to(
                    const Forgotpass(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Text(
                  "Forgot Password ?",
                  style: TextStyle(
                    fontSize: 12,
                    color: Appcolors.appPriSecColor.appPrimblue,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    ).paddingSymmetric(horizontal: 25);
  }

  Widget orTextField() {
    return Row(
      children: [
        Expanded(child: Divider(color: Appcolors.appPriSecColor.appSecondary)),
        Text(
          "Or".tr,
          style: TextStyle(
            fontSize: 14,
            color: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
        ).paddingSymmetric(horizontal: 14),
        Expanded(child: Divider(color: Appcolors.appPriSecColor.appSecondary)),
      ],
    ).paddingSymmetric(horizontal: 25);
  }
}
