// ignore_for_file: body_might_complete_normally_nullable, avoid_print

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/password_contro.dart';
import 'package:nlytical/controllers/user_controllers/register_contro.dart';
import 'package:nlytical/auth/login.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController usercontroller = TextEditingController();
  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController lnamecontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();

  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();
  FocusNode userpassFocusNode = FocusNode();
  FocusNode userFocusNode = FocusNode();
  FocusNode firstnamepassFocusNode = FocusNode();
  FocusNode firstnameFocusNode = FocusNode();
  FocusNode lastnamepassFocusNode = FocusNode();
  FocusNode lastnameFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  PassCheckController passCheckCtrl = Get.find();

  RegisterContro registercontro = Get.find();

  final userNameKey = GlobalKey<FormFieldState>();
  final fnameFieldKey = GlobalKey<FormFieldState>();
  final lnameFieldKey = GlobalKey<FormFieldState>();
  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();
  final mobileFieldKey = GlobalKey<FormFieldState>();

  String? phone;

  bool isselected = false;

  void fieldcheck() {
    setState(() {
      isselected =
          emailcontroller.text.isEmail &&
          passcontroller.text.isNotEmpty &&
          passcontroller.text.contains(
            RegExp(r'[A-Za-z0-9@#$%^&+=]'),
          ) && // Example: check for specific characters
          passcontroller.text.length >= 8 && // Minimum length requirement
          mobilecontroller.text.isNotEmpty &&
          lnamecontroller.text.isNotEmpty &&
          fnamecontroller.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    registercontro.userNameError.value = '';
    registercontro.userNameStatus.value = UserNameStatus.initial;
    emailcontroller.addListener(fieldcheck);
    passcontroller.addListener(fieldcheck);
    mobilecontroller.addListener(fieldcheck);
    lnamecontroller.addListener(fieldcheck);
    fnamecontroller.addListener(fieldcheck);
    super.initState();
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
          child: Scaffold(
            backgroundColor: Appcolors.appBgColor.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  sizeBoxHeight(40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Image.asset(
                            'assets/images/arrow-left1.png',
                            height: 24,
                          ).paddingAll(5),
                        ),
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 20),
                  sizeBoxHeight(35),
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
                  sizeBoxHeight(15),
                  sizeBoxHeight(17),
                  twoText(
                    text1: "User Name",
                    text2: " *",
                    style1: AppTypography.outerMedium(context).copyWith(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appTextColor.textBlack
                          : Appcolors.appTextColor.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                    style2: poppinsFont(
                      11,
                      Appcolors.appTextColor.textRedColor,
                      FontWeight.w600,
                    ),
                    mainAxisAlignment: MainAxisAlignment.start,
                  ).paddingSymmetric(horizontal: 20),
                  sizeBoxHeight(3),
                  Obx(
                    () => TextFormField(
                      key: userNameKey,
                      controller: usercontroller,
                      maxLength: 15,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      style: AppTypography.text11Regular(context).copyWith(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appTextColor.textBlack
                            : Appcolors.appTextColor.textWhite,
                      ),
                      keyboardType: TextInputType.name,
                      focusNode: userFocusNode,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(userpassFocusNode);
                      },
                      onTap: () {
                        registercontro.isUserName.value = true;
                      },
                      onChanged: (String searchText) {
                        registercontro.onUserNameChanged(searchText);
                        if (searchText.isNotEmpty) {
                          userNameKey.currentState?.validate();
                        }
                      },
                      onSaved: (newValue) {
                        FocusScope.of(context).nextFocus();
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        counterText: '',
                        suffixIcon: Obx(() {
                          if (registercontro.currentUserName.value
                              .trim()
                              .isEmpty) {
                            return const SizedBox.shrink();
                          }
                          switch (registercontro.userNameStatus.value) {
                            case UserNameStatus.loading:
                              return Padding(
                                padding: EdgeInsets.all(15),
                                child: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: commonLoading(),
                                ),
                              );
                            case UserNameStatus.success:
                              return Container(
                                margin: const EdgeInsets.all(16),
                                child: verifyIconWidget(),
                              );
                            case UserNameStatus.error:
                              return Container(
                                margin: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Appcolors.appTextColor.textRedColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Appcolors.white,
                                ),
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        }),

                        // suffix: suffixIcon,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        fillColor: themeContro.isLightMode.value
                            ? Appcolors.appBgColor.transparent
                            : Appcolors.darkGray,
                        filled: true,
                        hintText: "User Name",
                        hintStyle: AppTypography.text11Regular(
                          context,
                        ).copyWith(color: Appcolors.appTextColor.textLighGray),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Appcolors.appPriSecColor.appPrimblue,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appStrokColor.cF0F0F0
                                : Appcolors.grey1,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Appcolors.appTextColor.textRedColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Appcolors.appTextColor.textRedColor,
                          ),
                        ),
                        errorStyle: poppinsFont(
                          12,
                          Appcolors.appTextColor.textRedColor,
                          FontWeight.normal,
                        ),
                        counterStyle: poppinsFont(
                          0,
                          Appcolors.appExtraColor.cB4B4B4,
                          FontWeight.normal,
                        ),
                        labelStyle: poppinsFont(
                          12,
                          Appcolors.colorB0B0B0,
                          FontWeight.w400,
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 20),
                  ),
                  Obx(
                    () =>
                        registercontro.userNameError.isEmpty &&
                            registercontro.userNameStatus.value ==
                                UserNameStatus.initial
                        ? SizedBox.shrink()
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              registercontro.userNameError.value,
                              textAlign: TextAlign.left,
                              style: AppTypography.text8Medium(context)
                                  .copyWith(
                                    fontSize: 12,
                                    color: Appcolors.appTextColor.textRedColor,
                                  ),
                            ),
                          ).paddingSymmetric(horizontal: 30),
                  ),
                  sizeBoxHeight(10),
                  globalTextField(
                    key: fnameFieldKey,
                    lable: 'First Name',
                    lable2: " *",
                    maxLength: 15,
                    controller: fnamecontroller,
                    onEditingComplete: () {
                      FocusScope.of(
                        context,
                      ).requestFocus(firstnamepassFocusNode);
                    },
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        fnameFieldKey.currentState?.validate();
                      }
                    },
                    isEmail: false,
                    isNumber: false,
                    focusNode: firstnameFocusNode,
                    hintText: 'First Name',
                    context: context,
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
                            'assets/images/profile1.png',
                            color: Appcolors.grey500,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 20),
                  sizeBoxHeight(10),
                  globalTextField(
                    key: lnameFieldKey,
                    lable: "Last Name",
                    lable2: " *",
                    maxLength: 15,
                    controller: lnamecontroller,
                    onEditingComplete: () {
                      FocusScope.of(
                        context,
                      ).requestFocus(lastnamepassFocusNode);
                    },
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        lnameFieldKey.currentState?.validate();
                      }
                    },
                    isEmail: false,
                    isNumber: false,
                    focusNode: lastnameFocusNode,
                    hintText: 'Last Name',
                    context: context,
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
                            'assets/images/profile1.png',
                            color: Appcolors.grey500,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 20),
                  sizeBoxHeight(10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          'Mobile Number',
                          style: AppTypography.outerMedium(context).copyWith(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textBlack
                                : Appcolors.appTextColor.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        sizeBoxWidth(3),
                        Text(
                          ' *',
                          style: poppinsFont(
                            11,
                            Appcolors.appTextColor.textRedColor,
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 20),
                  sizeBoxHeight(4),
                  IntlPhoneField(
                    key: mobileFieldKey,
                    dropdownTextStyle: AppTypography.text11Regular(context)
                        .copyWith(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                        ),
                    showCountryFlag: true,
                    showDropdownIcon: false,
                    initialCountryCode: countryFlagCode,
                    initialValue: contrycode,
                    onCountryChanged: (value) {
                      contrycode = value.dialCode;
                      countryFlagCode = value.code;
                    },
                    onChanged: (number) {
                      contrycode = number.countryCode;
                      phone = number.completeNumber;
                    },
                    cursorColor: themeContro.isLightMode.value
                        ? Appcolors.appPriSecColor.appPrimblue
                        : Appcolors.white,
                    autofocus: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: AppTypography.text11Regular(context).copyWith(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appTextColor.textBlack
                          : Appcolors.appTextColor.textWhite,
                    ),
                    controller: mobilecontroller,
                    keyboardType: TextInputType.number,
                    flagsButtonPadding: const EdgeInsets.only(left: 5),
                    decoration: InputDecoration(
                      fillColor: themeContro.isLightMode.value
                          ? Appcolors.appBgColor.transparent
                          : Appcolors.darkGray,
                      filled: true,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Appcolors.appPriSecColor.appPrimblue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appStrokColor.cF0F0F0
                              : Appcolors.grey1,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Appcolors.appTextColor.textRedColor,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Appcolors.appTextColor.textRedColor,
                        ),
                      ),
                      hintText: "Enter Your Mobile Number".tr,
                      hintStyle: AppTypography.text11Regular(
                        context,
                      ).copyWith(color: Appcolors.appTextColor.textLighGray),
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
                              'assets/images/call.png',
                              color: Appcolors.grey500,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: Appcolors.appTextColor.textRedColor,
                        fontSize: 12,
                      ),
                    ),
                    validator: (value) {
                      if (phone == null ||
                          phone!.isEmpty ||
                          mobilecontroller.text.isEmpty) {
                        return 'Please Enter Your Valid Number';
                      }
                    },
                  ).paddingSymmetric(horizontal: 20),
                  sizeBoxHeight(10),
                  globalTextField(
                    key: emailFieldKey,
                    lable: "Email Address",
                    lable2: " *",
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
                  sizeBoxHeight(10),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Text(
                          'Password',
                          style: AppTypography.outerMedium(context).copyWith(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textBlack
                                : Appcolors.appTextColor.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        sizeBoxWidth(3),
                        Text(
                          ' *',
                          style: poppinsFont(
                            11,
                            Appcolors.appTextColor.textRedColor,
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 20),
                  sizeBoxHeight(4),
                  passwordField().paddingSymmetric(horizontal: 10),
                  sizeBoxHeight(10),
                  sizeBoxHeight(25),
                  Obx(() {
                    return registercontro.isLoading.value
                        ? commonLoading()
                        : GestureDetector(
                            onTap: () {
                              //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
                              final isEmailValid =
                                  emailFieldKey.currentState?.validate() ??
                                  false;
                              final isPasswordValid =
                                  passwordFieldKey.currentState?.validate() ??
                                  false;
                              final isNameValid =
                                  fnameFieldKey.currentState?.validate() ??
                                  false;
                              final isLnameValid =
                                  lnameFieldKey.currentState?.validate() ??
                                  false;
                              final isUserValid =
                                  userNameKey.currentState?.validate() ?? false;
                              // final isMobileFieldKey =
                              //     mobileFieldKey.currentState?.validate() ??
                              //     false;

                              if (isUserValid &&
                                  isNameValid &&
                                  isLnameValid &&
                                  isEmailValid &&
                                  // isMobileFieldKey &&
                                  isPasswordValid) {
                                if (mobilecontroller.text.trim().isNotEmpty) {
                                  registercontro.registerApi(
                                    username: usercontroller.text,
                                    firstname: fnamecontroller.text,
                                    lastname: lnamecontroller.text,
                                    newmobile: mobilecontroller.text,
                                    countrycode: contrycode,
                                    email: emailcontroller.text,
                                    password: passcontroller.text,
                                  );
                                } else {
                                  snackBar("Enter Valid Mobile number");
                                }
                              } else {
                                snackBar("Please fill the mandatory fields");
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
                                child: label(
                                  "Next",
                                  textColor: Appcolors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 60);
                  }),
                  SizedBox(height: Get.height * 0.04),
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
                            () => const Login(isLogin: false),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Text(
                          "Sign In",
                          style: AppTypography.text14Medium(context).copyWith(
                            color: Appcolors.appPriSecColor.appPrimblue,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Appcolors.appPriSecColor.appPrimblue,
          cursorColor: Appcolors.appPriSecColor.appPrimblue,
          selectionColor: Appcolors.appPriSecColor.appPrimblue.withValues(
            alpha: 0.5,
          ),
        ),
      ),
      child: Obx(() {
        return Column(
          children: [
            TextFormField(
                  key: passwordFieldKey,
                  controller: passcontroller,
                  focusNode: passFocusNode,
                  cursorColor: Appcolors.appPriSecColor.appPrimblue,

                  onEditingComplete: () {
                    // FocusScope.of(context).nextFocus();
                    FocusScope.of(context).requestFocus(passwordFocusNode);
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: AppTypography.text11Regular(context).copyWith(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appTextColor.textBlack
                        : Appcolors.appTextColor.textWhite,
                  ),
                  // focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  onSaved: (newValue) {
                    FocusScope.of(context).nextFocus();
                  },

                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      passwordFieldKey.currentState?.validate();
                    }
                    if (value.length < 8) {
                      passCheckCtrl.moreThan8Char(false);
                      // return "Minimum 8 characters required";
                    } else {
                      passCheckCtrl.moreThan8Char(true);
                    }

                    // Check if password contains a special character
                    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                      passCheckCtrl.oneSpecialCaseChar(false);
                      // return "Password must contain at least one special character";
                    } else {
                      passCheckCtrl.oneSpecialCaseChar(true);
                    }

                    // Check if password contains at least one number
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      passCheckCtrl.oneNumberChar(false);
                      // return "Password must contain at least one number";
                    } else {
                      passCheckCtrl.oneNumberChar(true);
                    }

                    // Check if password contains at least one lowercase letter
                    if (!value.contains(RegExp(r'[a-z]'))) {
                      passCheckCtrl.oneLowerCaseChar(false);
                      // return "Password must contain at least one lowercase letter";
                    } else {
                      passCheckCtrl.oneLowerCaseChar(true);
                    }

                    // Check if password contains at least one uppercase letter
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      passCheckCtrl.oneUpperCaseChar(false);
                      // return "Password must contain at least one uppercase letter";
                    } else {
                      passCheckCtrl.oneUpperCaseChar(true);
                    }

                    if (value.isEmpty) {
                      passCheckCtrl.moreThan8Char(false);
                      passCheckCtrl.oneNumberChar(false);
                      passCheckCtrl.oneUpperCaseChar(false);
                      passCheckCtrl.oneLowerCaseChar(false);
                      passCheckCtrl.oneSpecialCaseChar(false);
                    }
                  },
                  readOnly: false,

                  // textAlignVertical: TextAlignVertical.top,
                  // expands: true,
                  // expands: true,
                  // obscureText: userAuthController.isObscureForSignUp.value,
                  decoration: InputDecoration(
                    // prefixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 40),
                    // prefixIcon: Text('+91 '),
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,

                    hintText: "Password",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),

                    hintStyle: AppTypography.text11Regular(
                      context,
                    ).copyWith(color: Appcolors.appTextColor.textLighGray),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Appcolors.appPriSecColor.appPrimblue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appStrokColor.cF0F0F0
                            : Appcolors.darkgray3,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appStrokColor.cF0F0F0
                            : Appcolors.grey1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Appcolors.appTextColor.textRedColor,
                      ),
                    ),
                    errorStyle: poppinsFont(
                      12,
                      Appcolors.appTextColor.textRedColor,
                      FontWeight.normal,
                    ),
                    labelStyle: poppinsFont(
                      12,
                      Appcolors.black,
                      FontWeight.w400,
                    ),
                  ),
                  // validator: (value) {
                  //   if (!passCheckCtrl.moreThan8Char.value ||
                  //       !passCheckCtrl.oneNumberChar.value ||
                  //       !passCheckCtrl.oneUpperCaseChar.value ||
                  //       !passCheckCtrl.oneLowerCaseChar.value ||
                  //       !passCheckCtrl.oneSpecialCaseChar.value) {
                  //     return 'Please Enter Your Password';
                  //   }

                  //   return null;
                  // },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return 'Password must contain at least one lowercase letter';
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return 'Password must contain at least one number';
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return 'Password must contain at least one special character';
                    }
                    return null;
                  },
                )
                .paddingSymmetric(horizontal: 6)
                .paddingSymmetric(
                  vertical:
                      (passCheckCtrl.moreThan8Char.value &&
                          passCheckCtrl.oneNumberChar.value &&
                          passCheckCtrl.oneUpperCaseChar.value &&
                          passCheckCtrl.oneLowerCaseChar.value &&
                          passCheckCtrl.oneSpecialCaseChar.value)
                      ? 0
                      : 0,
                ),
            (passCheckCtrl.moreThan8Char.value &&
                    passCheckCtrl.oneNumberChar.value &&
                    passCheckCtrl.oneUpperCaseChar.value &&
                    passCheckCtrl.oneLowerCaseChar.value &&
                    passCheckCtrl.oneSpecialCaseChar.value)
                ? const SizedBox.shrink()
                : Wrap(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          passCheckCtrl.moreThan8Char.value
                              ? Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Appcolors.appExtraColor.greenColor,
                                )
                              : Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Appcolors.appTextColor.textRedColor,
                                ),
                          Text(
                            "8 or more character ",
                            style: poppinsFont(
                              12,
                              passCheckCtrl.moreThan8Char.value
                                  ? Appcolors.appExtraColor.greenColor
                                  : Appcolors.appTextColor.textRedColor,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          passCheckCtrl.oneNumberChar.value
                              ? Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Appcolors.appExtraColor.greenColor,
                                )
                              : Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Appcolors.appTextColor.textRedColor,
                                ),
                          Text(
                            "1 number ",
                            style: poppinsFont(
                              12,
                              passCheckCtrl.oneNumberChar.value
                                  ? Appcolors.appExtraColor.greenColor
                                  : Appcolors.appTextColor.textRedColor,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          passCheckCtrl.oneUpperCaseChar.value
                              ? Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Appcolors.appExtraColor.greenColor,
                                )
                              : Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Appcolors.appTextColor.textRedColor,
                                ),
                          Text(
                            "1 Uppercase ",
                            style: poppinsFont(
                              12,
                              passCheckCtrl.oneUpperCaseChar.value
                                  ? Appcolors.appExtraColor.greenColor
                                  : Appcolors.appTextColor.textRedColor,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          passCheckCtrl.oneLowerCaseChar.value
                              ? Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Appcolors.appExtraColor.greenColor,
                                )
                              : Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Appcolors.appTextColor.textRedColor,
                                ),
                          Text(
                            "1 LowerCase ",
                            style: poppinsFont(
                              12,
                              passCheckCtrl.oneLowerCaseChar.value
                                  ? Appcolors.appExtraColor.greenColor
                                  : Appcolors.appTextColor.textRedColor,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          passCheckCtrl.oneSpecialCaseChar.value
                              ? Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Appcolors.appExtraColor.greenColor,
                                )
                              : Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Appcolors.appTextColor.textRedColor,
                                ),
                          Text(
                            "1 special character ",
                            style: poppinsFont(
                              12,
                              passCheckCtrl.oneSpecialCaseChar.value
                                  ? Appcolors.appExtraColor.greenColor
                                  : Appcolors.appTextColor.textRedColor,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            (passCheckCtrl.moreThan8Char.value &&
                    passCheckCtrl.oneNumberChar.value &&
                    passCheckCtrl.oneUpperCaseChar.value &&
                    passCheckCtrl.oneLowerCaseChar.value &&
                    passCheckCtrl.oneSpecialCaseChar.value)
                ? const SizedBox.shrink()
                : const SizedBox(height: 0),
          ],
        ).paddingSymmetric(horizontal: 6);
      }),
    );
  }
}

//  twoText(
//           text1: "Select Number of Employees",
//           text2: " *",
//           fontWeight: FontWeight.w600,
//           mainAxisAlignment: MainAxisAlignment.start,
//         ),
