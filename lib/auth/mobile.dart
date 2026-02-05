// ignore_for_file: unnecessary_string_interpolations, avoid_print
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nlytical/auth/demo_login_widget.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/mobile_contro.dart';
import 'package:nlytical/auth/register.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  TextEditingController mobilecontroller = TextEditingController();
  MobileContro mobilecontro = Get.find();
  int maxLength = 10;

  bool isselected = false;

  void fieldcheck() {
    setState(() {
      isselected = mobilecontroller.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    mobilecontroller.addListener(fieldcheck);
    super.initState();
  }

  String? phone;

  String demoLoginMobile = "+1-4673974998";
  String demoLoginOtp = "1234";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          extendBody: true,
          backgroundColor: Appcolors.appBgColor.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                sizeBoxHeight(45),
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
                sizeBoxHeight(65),
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
                sizeBoxHeight(25),
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
                  style: AppTypography.text11Regular(context).copyWith(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appTextColor.textBlack
                        : Appcolors.appTextColor.textWhite,
                  ),
                  controller: mobilecontroller,
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
                      fontSize: 11,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(25),
                Obx(() {
                  return mobilecontro.isLoading.value
                      ? Center(child: commonLoading())
                      : GestureDetector(
                          onTap: () {
                            if (mobilecontroller.text.isEmpty) {
                              snackBar("Please enter your mobile number");
                            } else {
                              mobilecontro.registerNumberApi(
                                newmobile:
                                    "$contrycode${mobilecontroller.text}",
                                countrycode: '$contrycode',
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
                                "Get OTP",
                                style: AppTypography.text16(context).copyWith(
                                  fontSize: 14,
                                  color: Appcolors.appTextColor.textWhite,
                                ),
                              ),
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 60);
                }),
                sizeBoxHeight(35),
                forDemoField(
                  isForEmail: false,
                  email: "",
                  phone: demoLoginMobile,
                  pwdOtp: demoLoginOtp,
                  onTap: () {
                    contrycode = "+1";
                    mobilecontroller.text = getMobile(demoLoginMobile);
                  },
                ).paddingSymmetric(horizontal: 30),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
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
                    style: AppTypography.text14Medium(context).copyWith(
                      color: Appcolors.appPriSecColor.appPrimblue,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
