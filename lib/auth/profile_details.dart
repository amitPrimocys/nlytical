// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:nlytical/auth/google_signin.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/register_contro.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/spinkit_loader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/controllers/user_controllers/profile_detail_contro.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';

class ProfileDetails extends StatefulWidget {
  String? number;
  String? email;
  ProfileDetails({super.key, this.number, this.email});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController lnamecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  RegisterContro registercontro = Get.find();
  GetprofileContro getprofilecontro = Get.find();

  FocusNode usernamepassFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode phonenamepassFocusNode = FocusNode();
  FocusNode phonenameFocusNode = FocusNode();
  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();
  FocusNode firstnamepassFocusNode = FocusNode();
  FocusNode firstnameFocusNode = FocusNode();
  FocusNode lastnamepassFocusNode = FocusNode();
  FocusNode lastnameFocusNode = FocusNode();
  final userNameKey = GlobalKey<FormFieldState>();
  final fnameFieldKey = GlobalKey<FormFieldState>();
  final lnameFieldKey = GlobalKey<FormFieldState>();
  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();
  final mobileFieldKey = GlobalKey<FormFieldState>();

  ProfileDetailContro profiledetailcontro = Get.find();

  bool isselected = false;

  void fieldcheck() {
    setState(() {
      isselected =
          lnamecontroller.text.isNotEmpty &&
          fnamecontroller.text.isNotEmpty &&
          emailcontroller.text.isEmail;
    });
  }

  @override
  void initState() {
    registercontro.userNameError.value = '';
    registercontro.userNameStatus.value = UserNameStatus.initial;
    phonecontroller.text = widget.number.toString();
    emailcontroller.text = (widget.email!.isNotEmpty
        ? widget.email
        : userEmail.toString())!;
    usernamecontroller.addListener(fieldcheck);
    lnamecontroller.addListener(fieldcheck);
    fnamecontroller.addListener(fieldcheck);
    emailcontroller.addListener(fieldcheck);
    getprofilecontro.getprofileApi();
    setState(() {});
    super.initState();
  }

  String? phone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          color: Appcolors.white,
          image: DecorationImage(
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
                    onTap: () async {
                      if (widget.email!.isNotEmpty && userEmail.isNotEmpty) {
                        await SecurePrefs.clear();
                        userEmail = '';
                        userID = '';
                        userIMAGE = '';
                        image_status = '';
                        subscribedUserGlobal = 0;
                        isStoreGlobal = 0;
                        await SecurePrefs.remove(SecureStorageKeys.USER_ID);
                        await FirebaseMessaging.instance.deleteToken();
                        signOutGoogle();
                      }
                      Navigator.pop(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Image.asset(
                          'assets/images/arrow-left1.png',
                          height: 24,
                        ).paddingAll(5),
                      ),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(20),
                CachedNetworkImage(
                  imageUrl: appLogo,
                  placeholder: (context, url) {
                    return SizedBox.shrink();
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      AppAsstes.default_user1,
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
                sizeBoxHeight(10),
                profileImage(context),
                sizeBoxHeight(20),
                //******************************** USERNAME ***********************************/
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
                TextFormField(
                  key: userNameKey,
                  maxLength: 15,
                  controller: usernamecontroller,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  keyboardType: TextInputType.name,
                  style: AppTypography.text11Regular(context).copyWith(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appTextColor.textBlack
                        : Appcolors.appTextColor.textWhite,
                  ),
                  focusNode: usernamepassFocusNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(usernamepassFocusNode);
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
                  decoration: InputDecoration(
                    counterText: '',
                    suffixIcon: Obx(() {
                      if (registercontro.currentUserName.value.trim().isEmpty) {
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
                Obx(
                  () => registercontro.userNameError.isEmpty
                      ? SizedBox.shrink()
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            registercontro.userNameError.value,
                            textAlign: TextAlign.left,
                            style: AppTypography.text8Medium(context).copyWith(
                              fontSize: 12,
                              color: Appcolors.appTextColor.textRedColor,
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 30),
                ),
                sizeBoxHeight(10),
                //******************************** FIRST_NAME ***********************************/
                globalTextField(
                  key: fnameFieldKey,
                  lable: 'First Name',
                  lable2: " *",
                  controller: fnamecontroller,
                  maxLength: 15,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(firstnamepassFocusNode);
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
                        color: Appcolors.grey200,
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
                //******************************** LAST_NAME ***********************************/
                globalTextField(
                  key: lnameFieldKey,
                  lable: "Last Name",
                  lable2: " *",
                  maxLength: 15,
                  controller: lnamecontroller,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(lastnamepassFocusNode);
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
                        color: Appcolors.grey200,
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
                //******************************** EMAIL ***********************************/
                isEmailVerify
                    ? twoText(
                        text1: languageController.textTranslate(
                          'Email Address',
                        ),
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
                      ).paddingSymmetric(horizontal: 20)
                    : SizedBox.shrink(),
                isEmailVerify ? sizeBoxHeight(4) : SizedBox.shrink(),
                !isEmailVerify
                    ? globalTextField(
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
                      ).paddingSymmetric(horizontal: 20)
                    : TextFormField(
                        key: emailFieldKey,
                        enabled: false,
                        controller: getprofilecontro.emailcontroller,
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            (emailFieldKey.currentState)?.validate();
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: themeContro.isLightMode.value
                              ? Appcolors.appPriSecColor.appPrimblue.withValues(
                                  alpha: 0.10,
                                )
                              : Appcolors.darkGray,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: themeContro.isLightMode.value
                                ? BorderSide.none
                                : const BorderSide(color: Appcolors.darkBorder),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: languageController.textTranslate(
                            "Email Address",
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Appcolors.appPriSecColor.appPrimblue,
                            fontWeight: FontWeight.w400,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: verifyIconWidget(),
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(10),
                //******************************** MOBiLE_NUMBER  ***********************************/
                twoText(
                  text1: languageController.textTranslate('Mobile Number'),
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
                sizeBoxHeight(4),

                isPhoneVerify
                    ? Container(
                        height: getProportionateScreenHeight(60),
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.appPriSecColor.appPrimblue
                              .withValues(alpha: 0.10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              phonecontroller.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: Appcolors.appPriSecColor.appPrimblue,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            verifyIconWidget(),
                          ],
                        ).paddingSymmetric(horizontal: 15),
                      ).paddingSymmetric(horizontal: 20)
                    : IntlPhoneField(
                        key: mobileFieldKey,
                        showCountryFlag: true,
                        showDropdownIcon: false,
                        initialCountryCode: countryFlagCode,
                        initialValue: contrycode,
                        onCountryChanged: (value) {
                          contrycode = value.dialCode;
                          countryFlagCode = value
                              .code; // ISO 2-letter country code like "IN", "US"
                        },
                        onChanged: (number) {
                          contrycode = number.countryCode;
                          phone = number.completeNumber;
                        },
                        style: AppTypography.text11Regular(context).copyWith(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                        ),
                        dropdownTextStyle: AppTypography.text11Regular(context)
                            .copyWith(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appTextColor.textBlack
                                  : Appcolors.appTextColor.textWhite,
                            ),
                        cursorColor: themeContro.isLightMode.value
                            ? Appcolors.appPriSecColor.appPrimblue
                            : Appcolors.white,
                        autofocus: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: phonecontroller,
                        keyboardType: TextInputType.number,
                        flagsButtonPadding: const EdgeInsets.only(left: 5),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: themeContro.isLightMode.value
                              ? Appcolors.appBgColor.transparent
                              : Appcolors.darkGray,
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
                          hintStyle: AppTypography.text11Regular(context)
                              .copyWith(
                                color: Appcolors.appTextColor.textLighGray,
                              ),
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
                            fontSize: 11,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.number.isEmpty) {
                            return null;
                          }
                          try {
                            if (value.isValidNumber()) {
                              return null; // Valid phone number
                            } else {
                              return 'Please enter a valid phone number';
                            }
                          } catch (e) {
                            return 'Please enter a valid phone number';
                          }
                        },
                      ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(25),
                //******************************** SUBMIT BUTTON ***********************************/
                Obx(() {
                  return profiledetailcontro.isLoading.value
                      ? commonLoading()
                      : GestureDetector(
                          onTap: () {
                            if (widget.email!.isNotEmpty) {
                              final isEmailValid =
                                  emailFieldKey.currentState?.validate() ??
                                  false;
                              final isNameValid =
                                  fnameFieldKey.currentState?.validate() ??
                                  false;
                              final isLnameValid =
                                  lnameFieldKey.currentState?.validate() ??
                                  false;
                              final isUserValid =
                                  userNameKey.currentState?.validate() ?? false;

                              if (isUserValid &&
                                  isNameValid &&
                                  isLnameValid &&
                                  isEmailValid) {
                                if (phonecontroller.text.trim().isNotEmpty) {
                                  profiledetailcontro.createProfileApi(
                                    isEmail: true,
                                    file: selectedImages?.path,
                                    uname: usernamecontroller.text,
                                    fname: fnamecontroller.text,
                                    laname: lnamecontroller.text,
                                    email: emailcontroller.text,
                                    code: contrycode,
                                    number: getMobile(phonecontroller.text),
                                  );
                                } else {
                                  snackBar("Enter Valid Mobile number");
                                }
                              } else {
                                snackBar("Please fill the mandatory fields");
                              }
                            } else {
                              final isEmailValid =
                                  emailFieldKey.currentState?.validate() ??
                                  false;
                              final isNameValid =
                                  fnameFieldKey.currentState?.validate() ??
                                  false;
                              final isLnameValid =
                                  lnameFieldKey.currentState?.validate() ??
                                  false;
                              final isUserValid =
                                  userNameKey.currentState?.validate() ?? false;

                              if (isUserValid &&
                                  isNameValid &&
                                  isLnameValid &&
                                  isEmailValid) {
                                profiledetailcontro.createProfileApi(
                                  isEmail: false,
                                  file: selectedImages?.path,
                                  uname: usernamecontroller.text,
                                  fname: fnamecontroller.text,
                                  laname: lnamecontroller.text,
                                  email: emailcontroller.text,
                                );
                              } else {
                                snackBar("Please fill the mandatory fields");
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            width: Get.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: isselected
                                  ? Appcolors.logoColork
                                  : Appcolors.logoColorWith60Opacityk,
                            ),
                            child: Center(
                              child: label(
                                "Submit",
                                textColor: Appcolors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                }),
                SizedBox(height: Get.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImage(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // openBottomForImagePick(context);
          selectPicture();
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenWidth(100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Appcolors.appPriSecColor.appPrimblue.withValues(
                  alpha: 0.10,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 0,
                    color: Appcolors.appPriSecColor.appPrimblue.withValues(
                      alpha: 0.10,
                    ),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Appcolors.white,
                  border: Border.all(
                    width: 2.5,
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: selectedImages != null
                      ? Image.file(selectedImages!, fit: BoxFit.cover)
                      : (getprofilecontro
                                    .getprofilemodel
                                    .value
                                    ?.userDetails
                                    ?.image !=
                                null &&
                            getprofilecontro
                                .getprofilemodel
                                .value!
                                .userDetails!
                                .image!
                                .isNotEmpty)
                      ? Image.network(
                          getprofilecontro
                              .getprofilemodel
                              .value!
                              .userDetails!
                              .image!,
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
                                    child: SpinKitSpinningLines(
                                      size: 30,
                                      color:
                                          Appcolors.appPriSecColor.appPrimblue,
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
                                return Image.asset(AppAsstes.default_user1);
                              },
                        )
                      : userFirstName.isNotEmpty
                      ? containerCapiltal(
                          height: getProportionateScreenHeight(100),
                          width: getProportionateScreenWidth(100),
                          fontSize: 30,
                          text: userFirstName,
                        )
                      : Image.asset(AppAsstes.default_user1),
                ).paddingAll(3),
              ).paddingAll(3),
            ),
            Positioned(
              bottom: 5,
              right: 6,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Appcolors.white,
                  border: Border.all(
                    width: 1.5,
                    color: Appcolors.appPriSecColor.appPrimblue.withValues(
                      alpha: 0.10,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: Appcolors.appPriSecColor.appPrimblue,
                  size: 15,
                ).paddingAll(0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> selectPicture() {
    final ap = Get.bottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.57),
      elevation: 0,
      backgroundColor: Appcolors.appBgColor.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.8, sigmaY: 3.8),
        child: Container(
          decoration: BoxDecoration(
            color: Appcolors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: getProportionateScreenHeight(200),
          width: Get.width,
          child: Column(
            children: [
              Container(
                height: getProportionateScreenHeight(70),
                width: Get.width,
                decoration: BoxDecoration(
                  // color: Appcolors.white,
                  borderRadius: BorderRadius.circular(20),
                  color: Appcolors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.black.withValues(alpha: 0.12),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                      offset: const Offset(
                        0.0,
                        2.0,
                      ), // shadow direction: bottom right
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Profile Photo",
                      style: poppinsFont(16, Appcolors.black, FontWeight.w500),
                    ),
                    sizeBoxWidth(100),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 25,
                      ).paddingOnly(right: 20),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      sizeBoxHeight(20),
                      GestureDetector(
                        onTap: () {
                          getImageFromcamera();
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pop("Discard");
                        },
                        child: Container(
                          height: getProportionateScreenHeight(60),
                          width: getProportionateScreenWidth(60),
                          decoration: BoxDecoration(
                            color: Appcolors.appPriSecColor.appPrimblue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/camera2.png',
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      sizeBoxHeight(10),
                      label(
                        "Camera",
                        textColor: Appcolors.greyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  sizeBoxWidth(30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      sizeBoxHeight(20),
                      GestureDetector(
                        onTap: () {
                          getImageFromGallery();
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pop("Discard");
                        },
                        child: Container(
                          height: getProportionateScreenHeight(60),
                          width: getProportionateScreenWidth(60),
                          decoration: BoxDecoration(
                            color: Appcolors.appPriSecColor.appPrimblue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/gallery2.png',
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      sizeBoxHeight(10),
                      label(
                        "Gallery",
                        textColor: Appcolors.greyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return ap;
  }

  File? selectedImages;
  final picker = ImagePicker();

  Future getImageFromcamera() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        selectedImages = File(pickedFile.path);
      }
    });
  }

  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        selectedImages = File(pickedFile.path);
      }
    });
  }
}
