import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/apple_signin.dart';
import 'package:nlytical/auth/demo_login_widget.dart';
import 'package:nlytical/auth/google_signin.dart';
import 'package:nlytical/controllers/user_controllers/login_contro.dart';
import 'package:nlytical/auth/forgotpass.dart';
import 'package:nlytical/auth/mobile.dart';
import 'package:nlytical/auth/register.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPopup extends StatefulWidget {
  const LoginPopup({super.key});

  @override
  State<LoginPopup> createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool isTermsPrivacy = false;

  LoginContro logincontro = Get.find();
  final GlobalKey<FormState> _keyform = GlobalKey();

  bool isselected = false;

  void fieldcheck() {
    setState(() {
      isselected =
          emailcontroller.text.isEmail && passcontroller.text.isNotEmpty;
    });
  }

  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    requestPermission();
    emailcontroller.addListener(fieldcheck);
    passcontroller.addListener(fieldcheck);
    super.initState();
  }

  Future<void> requestPermission() async {
    await Permission.notification.request();
    await Permission.location.request();
    // await Permission.camera.request();
    // await Permission.photos.request();
  }

  String demoLoginEmail = "john@demo.com";
  String demoLoginPass = "123456";

  void unFocus() {
    signUpPasswordFocusNode.unfocus();
    signUpEmailIDFocusNode.unfocus();
    passFocusNode.unfocus();
    passwordFocusNode.unfocus();
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _keyform,
                  child: Column(
                    children: [
                      sizeBoxHeight(105),
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
                          style: AppTypography.text12Ragular(context).copyWith(
                            color: Appcolors.appTextColor.textDarkGrey,
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 40),
                      sizeBoxHeight(20),
                      globalTextField(
                        lable: "Email Address",
                        lable2: ' *',
                        controller: emailcontroller,
                        onEditingComplete: () {
                          FocusScope.of(
                            context,
                          ).requestFocus(signUpPasswordFocusNode);
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
                        lable: "Password",
                        lable2: ' *',
                        controller: passcontroller,
                        onEditingComplete: () {
                          FocusScope.of(
                            context,
                          ).requestFocus(passwordFocusNode);
                        },
                        isOnlyRead: emailLoginStatus == "1" ? false : true,
                        focusNode: passFocusNode,
                        hintText: 'Password',
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
                                        height: getProportionateScreenHeight(
                                          48,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),

                                          gradient: isselected
                                              ? Appcolors.logoColork
                                              : Appcolors
                                                    .logoColorWith60Opacityk,
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
                                Get.to(
                                  const Mobile(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              title: "Sign in with Phone Number",
                              img: 'assets/images/call1.png',
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: Get.height * 0.06),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: AppTypography.text12Ragular(context),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => const Register(),
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: AppTypography.text14Medium(context)
                                  .copyWith(
                                    color: Appcolors.appPriSecColor.appPrimblue,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
        height: 50,
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
            Image.asset(img, height: 20),
            sizeBoxWidth(10),
            Text(
              title,
              maxLines: 2,
              style: AppTypography.text14Medium(context),
            ),
          ],
        ),
      ),
    ).paddingSymmetric(horizontal: 50);
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
        GestureDetector(
          onTap: () {
            Get.to(const Forgotpass(), transition: Transition.rightToLeft);
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
        ),
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
