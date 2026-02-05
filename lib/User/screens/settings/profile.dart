// ignore_for_file: prefer_const_constructors, dead_code, non_constant_identifier_names, prefer_null_aware_operators, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nlytical/controllers/user_controllers/register_contro.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/User/screens/controller/user_tab_controller.dart';
import 'package:nlytical/User/screens/shimmer_loader/profile_detail_loader.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/spinkit_loader.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // String contrycode = '';
  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode userNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode signUpPhoneFocusNode = FocusNode();

  // FocusNode signUpEmailIDFocusNode = FocusNode();

  File? file;
  String filePath = '';
  bool isTermsPrivacy = false;
  bool isRemoveImage = false;
  bool readonlyauth = false;

  GetprofileContro getprofilecontro = Get.find();
  RegisterContro registercontro = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registercontro.userNameError.value = '';
      registercontro.userNameStatus.value = UserNameStatus.initial;
      getprofilecontro.getprofileApi();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: themeContro.isLightMode.value
            ? Appcolors.appBgColor.white
            : Appcolors.darkMainBlack,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: AppBar(
            leading: customeBackArrow().paddingAll(15),
            centerTitle: true,
            title: Text(
              languageController.textTranslate("Profile"),
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
              Expanded(child: profillist()),
            ],
          ),
        ),
      ),
    );
  }

  String? phone;

  Widget profillist() {
    return Obx(() {
      return getprofilecontro.isprofile.value
          ? profiledetailsLoader(context)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizeBoxHeight(30),
                  profileImage(context),
                  sizeBoxHeight(8),
                  GestureDetector(
                    onTap: () {
                      bottomSheetGobal(
                        context,
                        bottomsheetHeight: Platform.isIOS ? 250 : 200,
                        title: languageController.textTranslate(
                          "Profile Photo",
                        ),
                        child: openBottomDailog(),
                      );
                    },
                    child: Center(
                      child: Text(
                        languageController.textTranslate("Select Your Profile"),
                        maxLines: 2,
                        style: AppTypography.text11Regular(context),
                      ),
                    ),
                  ),
                  sizeBoxHeight(28),
                  twoText(
                    text1: languageController.textTranslate("User Name"),
                    text2: getprofilecontro.userNameController.text.isNotEmpty
                        ? ""
                        : " *",
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
                  ),
                  sizeBoxHeight(4),
                  getprofilecontro.userNameController.text.isNotEmpty
                      ? Container(
                          height: getProportionateScreenHeight(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeContro.isLightMode.value
                                ? Appcolors.appPriSecColor.appPrimblue
                                      .withValues(alpha: 0.10)
                                : Appcolors.darkGray,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getprofilecontro.userNameController.text,
                                style: AppTypography.text11Regular(context)
                                    .copyWith(
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.appTextColor.textBlack
                                          : Appcolors.appTextColor.textWhite,
                                    ),
                              ),
                              verifyIconWidget(),
                            ],
                          ).paddingSymmetric(horizontal: 15),
                        )
                      : TextFormField(
                          controller: getprofilecontro.userNameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          style: AppTypography.text11Regular(context).copyWith(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textBlack
                                : Appcolors.appTextColor.textWhite,
                          ),
                          keyboardType: TextInputType.name,
                          focusNode: userNameFocusNode,
                          onEditingComplete: () {
                            FocusScope.of(
                              context,
                            ).requestFocus(userNameFocusNode);
                          },
                          onTap: () {
                            registercontro.isUserName.value = true;
                          },
                          onChanged: (String searchText) {
                            registercontro.onUserNameChanged(searchText);
                          },
                          onSaved: (newValue) {
                            FocusScope.of(context).nextFocus();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
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
                                      color:
                                          Appcolors.appTextColor.textRedColor,
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
                            hintStyle: AppTypography.text11Regular(context)
                                .copyWith(
                                  color: Appcolors.appTextColor.textLighGray,
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
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please Enter your user name';
                          //   }
                          //   return null;
                          // },
                        ),
                  Obx(
                    () => registercontro.userNameError.isEmpty
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
                  sizeBoxHeight(17),
                  globalTextField(
                    lable2: " *",
                    controller: getprofilecontro.fnameController,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(lastNameFocusNode);
                    },
                    isEmail: false,
                    isNumber: false,
                    focusNode: firstNameFocusNode,
                    lable: languageController.textTranslate("First Name"),
                    hintText: languageController.textTranslate("First Name"),
                    context: context,
                  ),
                  sizeBoxHeight(17),
                  globalTextField(
                    lable2: " *",
                    controller: getprofilecontro.lnameController,
                    onEditingComplete: () {
                      FocusScope.of(
                        context,
                      ).requestFocus(signUpEmailIDFocusNode);
                    },
                    isEmail: false,
                    isNumber: false,
                    focusNode: lastNameFocusNode,
                    lable: languageController.textTranslate("Last Name"),
                    hintText: languageController.textTranslate("Last Name"),
                    context: context,
                  ),
                  sizeBoxHeight(17),
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
                        )
                      : SizedBox.shrink(),
                  isEmailVerify ? sizeBoxHeight(4) : SizedBox.shrink(),
                  !isEmailVerify
                      ? globalTextField(
                          lable: "Email Address",
                          lable2: ' *',
                          controller: getprofilecontro.emailcontroller,
                          onEditingComplete: () {
                            FocusScope.of(
                              context,
                            ).requestFocus(signUpPasswordFocusNode);
                          },
                          onChanged: (val) {},
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
                        )
                      : TextFormField(
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
                          decoration: InputDecoration(
                            fillColor: themeContro.isLightMode.value
                                ? Appcolors.appPriSecColor.appPrimblue
                                      .withValues(alpha: 0.10)
                                : Appcolors.darkGray,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: themeContro.isLightMode.value
                                  ? BorderSide.none
                                  : const BorderSide(
                                      color: Appcolors.darkBorder,
                                    ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
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
                        ),
                  sizeBoxHeight(15),
                  twoText(
                    text1: languageController.textTranslate('Mobile Number'),
                    text2: isPhoneVerify ? " " : " *",
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
                  ),
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
                                getprofilecontro.countrycode.value +
                                    getprofilecontro.phoneController.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              verifyIconWidget(),
                            ],
                          ).paddingSymmetric(horizontal: 15),
                        )
                      : IntlPhoneField(
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
                          dropdownTextStyle:
                              AppTypography.text11Regular(context).copyWith(
                                color: themeContro.isLightMode.value
                                    ? Appcolors.appTextColor.textBlack
                                    : Appcolors.appTextColor.textWhite,
                              ),
                          cursorColor: themeContro.isLightMode.value
                              ? Appcolors.appPriSecColor.appPrimblue
                              : Appcolors.white,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: getprofilecontro.phoneController,
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
                        ),
                  sizeBoxHeight(25),
                  Center(
                    child: Obx(() {
                      return getprofilecontro.isupdate.value
                          ? commonLoading()
                          : GestureDetector(
                              onTap: () async {
                                // Call update API with the values from the text
                                if (getprofilecontro
                                        .getprofilemodel
                                        .value!
                                        .isDemo ==
                                    "false") {
                                  getprofilecontro.updateApi(
                                    file: selectedImages != null
                                        ? selectedImages!.path
                                        : null,
                                    countryCode:
                                        getprofilecontro.countrycode.value,
                                    fname:
                                        getprofilecontro.fnameController.text,
                                    lname:
                                        getprofilecontro.lnameController.text,
                                    email:
                                        getprofilecontro.emailcontroller.text,
                                    phone:
                                        "${getprofilecontro.countrycode.value}${getprofilecontro.phoneController.text}",

                                    isUpdateProfile: true,
                                  );
                                  Get.find<UserTabController>()
                                          .currentTabIndex
                                          .value =
                                      4;
                                } else {
                                  snackBar(
                                    "This is for demo, We can not allow to update",
                                  );
                                }
                              },
                              child: Container(
                                height: 50,
                                width: Get.width * 0.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                ),
                                child: Center(
                                  child: Text(
                                    languageController.textTranslate("Save"),
                                    style: AppTypography.text16(context)
                                        .copyWith(
                                          color:
                                              Appcolors.appTextColor.textWhite,
                                        ),
                                  ),
                                ),
                              ),
                            );
                    }),
                  ),
                  sizeBoxHeight(50),
                ],
              ).paddingSymmetric(horizontal: 20),
            );
    });
  }

  Widget profileImage(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          bottomSheetGobal(
            context,
            bottomsheetHeight: Platform.isIOS ? 250 : 200,
            title: languageController.textTranslate("Profile Photo"),
            child: openBottomDailog(),
          );
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
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.darkGray,
                  border: Border.all(
                    width: 2.5,
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: selectedImages == null
                      ? image_status == "0"
                            ? containerCapiltal(
                                height: getProportionateScreenHeight(100),
                                width: getProportionateScreenWidth(100),
                                fontSize: 30,
                                text: userName,
                              )
                            : getprofilecontro
                                  .getprofilemodel
                                  .value!
                                  .userDetails!
                                  .image!
                                  .isNotEmpty
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
                                            color: Appcolors
                                                .appPriSecColor
                                                .appPrimblue,
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
                                        height: getProportionateScreenHeight(
                                          100,
                                        ),
                                        width: getProportionateScreenWidth(100),
                                        fontSize: 30,
                                        text: userName,
                                      );
                                    },
                              )
                            : containerCapiltal(
                                height: getProportionateScreenHeight(100),
                                width: getProportionateScreenWidth(100),
                                fontSize: 30,
                                text: userName,
                              )
                      : Image.file(selectedImages!, fit: BoxFit.cover),
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

  StatefulBuilder openBottomDailog() {
    return StatefulBuilder(
      builder: (context, aa) {
        return Column(
          children: [
            sizeBoxHeight(20),
            image_status == '1'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cotainer(
                        onTap: () {
                          getImageFromcamera();
                          Get.back();
                        },
                        title: languageController.textTranslate("Camera"),
                        img: AppAsstes.camera2,
                      ),
                      sizeBoxWidth(30),
                      cotainer(
                        onTap: () {
                          getImageFromGallery();
                          Get.back();
                        },
                        title: languageController.textTranslate("Gallery"),
                        img: AppAsstes.gallery2,
                      ),
                      sizeBoxWidth(30),
                      Obx(() {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            cotainer(
                              onTap: () async {
                                deleteImage();
                                if (selectedImages != null) {
                                  selectedImages = null;
                                  snackBar("Removed selected image");
                                  Get.back();
                                } else {
                                  Navigator.of(context).pop();
                                  final success = await getprofilecontro
                                      .removeProfileApi();

                                  if (success) {
                                    setState(() {});
                                  }
                                }
                              },
                              title: languageController.textTranslate("Delete"),
                              img: AppAsstes.trash,
                            ),
                            getprofilecontro.isRemoveProfile.value
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(55),
                                    child: Container(
                                      height: getProportionateScreenHeight(55),
                                      width: getProportionateScreenWidth(55),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(55),
                                        color: Appcolors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: commonLoadingWhite(),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        );
                      }),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cotainer(
                        onTap: () {
                          getImageFromcamera();
                          Get.back();
                        },
                        title: languageController.textTranslate("Camera"),
                        img: AppAsstes.camera2,
                      ),
                      sizeBoxWidth(30),
                      cotainer(
                        onTap: () {
                          getImageFromGallery();
                          Get.back();
                        },
                        title: languageController.textTranslate("Gallery"),
                        img: AppAsstes.gallery2,
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }

  Widget cotainer({
    required Function() onTap,
    required String title,
    required String img,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: getProportionateScreenHeight(55),
            width: getProportionateScreenWidth(55),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55),
              color: Appcolors.appPriSecColor.appPrimblue,
            ),
            child: Image.asset(img).paddingAll(10),
          ),
          sizeBoxHeight(10),
          Text(
            title,
            style: AppTypography.text12Ragular(
              context,
            ).copyWith(color: Appcolors.appTextColor.textLighGray),
          ),
        ],
      ),
    );
  }

  File? selectedImages;
  final picker = ImagePicker();

  void deleteImage() {
    setState(() {
      selectedImages = null; // Clear the selected image
    });
  }

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
