// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/register.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/forgot_otp_controller.dart';
import 'package:nlytical/controllers/user_controllers/mobile_contro.dart';
import 'package:nlytical/controllers/user_controllers/otp_contro.dart';
import 'package:nlytical/controllers/user_controllers/register_contro.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:pinput/pinput.dart';

class Otpscreen extends StatefulWidget {
  String? email;
  String? passwrd;
  String? number;
  String? countryCode;
  String? usernme;
  String? fname;
  String? lname;
  String? devicetoken;
  int isfortap;
  Otpscreen({
    super.key,
    this.email,
    this.number,
    this.countryCode,
    required String devicetoken,
    required this.isfortap,
  });

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  TextEditingController otpcontroller = TextEditingController();
  RegisterContro registercontro = Get.find();

  OtpController otpcontro = Get.find();
  ForgotOtpController forgotOtpController = Get.find();
  MobileContro mobilecontro = Get.find();

  late Timer _timer;
  int _currentSeconds = 300;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds == 0) {
        _timer.cancel();
        setState(() {
          _currentSeconds = 300;
        });
      } else {
        setState(() {
          _currentSeconds--;
        });
      }
    });
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final minutesStr = minutes.toString().padLeft(1, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 20,
        color: Appcolors.appPriSecColor.appPrimblue,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        // border: Border.all(color: Appcolors.greyColor),
        border: Border.all(color: Appcolors.appPriSecColor.appSecondary),
        borderRadius: BorderRadius.circular(4),
      ),
    );
    final focusedPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 20,
        color: Appcolors.appPriSecColor.appPrimblue,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        // border: Border.all(color: Appcolors.appColor),
        border: Border.all(color: Appcolors.appPriSecColor.appSecondary),
        borderRadius: BorderRadius.circular(4),
      ),
    );
    final submittedPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 20,
        color: Appcolors.appPriSecColor.appPrimblue,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        // border: Border.all(color: Appcolors.appColor),
        border: Border.all(color: Appcolors.appPriSecColor.appPrimblue),
        borderRadius: BorderRadius.circular(4),
      ),
    );
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
          backgroundColor: Appcolors.appBgColor.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                sizeBoxHeight(45),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      _timer.cancel();
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
                sizeBoxHeight(18),
                Center(
                  child: Text(
                    "Verification Code",
                    style: poppinsFont(
                      19,
                      themeContro.isLightMode.value
                          ? Appcolors.appTextColor.textBlack
                          : Appcolors.appTextColor.textWhite,
                      FontWeight.w600,
                    ),
                  ),
                ),
                sizeBoxHeight(18),
                Center(
                  child: Text(
                    widget.isfortap == 1
                        ? "We have sent the code verification to your Mobile Number"
                        : "We have sent the code verification to your Email Address",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppTypography.text14Medium(
                      context,
                    ).copyWith(color: Appcolors.appTextColor.textDarkGrey),
                  ),
                ).paddingSymmetric(horizontal: 40),

                sizeBoxHeight(18),
                Center(
                  child: Text(
                    widget.isfortap == 1
                        ? "${widget.number}"
                        : "${widget.email}",
                    style: AppTypography.text14Medium(context).copyWith(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appTextColor.textBlack
                          : Appcolors.appTextColor.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                sizeBoxHeight(15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Pinput(
                    length: 4,
                    showCursor: true,
                    controller: otpcontroller,
                    autofocus: true,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ).paddingSymmetric(horizontal: 40),
                sizeBoxHeight(25),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentSeconds == 300) {
                        setState(() {
                          _startTimer();
                        });
                        if (widget.isfortap == 1) {
                          // for mobile number
                          mobilecontro.registerNumberApi(
                            newmobile: widget.number!,
                            countrycode: '+$contrycode',
                          );
                        } else if (widget.isfortap == 2) {
                          forgotOtpController.forgotVerifyOtpApi(
                            email: widget.email!,
                          );
                        } else {
                          registercontro.registerApi(
                            username: widget.usernme,
                            firstname: widget.fname,
                            lastname: widget.lname,
                            newmobile: widget.number,
                            countrycode: '+$contrycode',
                            email: widget.email,
                            password: widget.passwrd,
                          );
                        }
                      }
                    },
                    child: Text(
                      "Resend OTP",
                      style: AppTypography.text14Medium(context).copyWith(
                        color: _currentSeconds == 300
                            ? Appcolors.appPriSecColor.appPrimblue
                            : Appcolors.grey,
                      ),
                    ),
                  ),
                ),
                sizeBoxHeight(12),
                Center(
                  child: Text(
                    "Resend Code in ${_formatTimer(_currentSeconds)}",
                    style: AppTypography.text12Ragular(context).copyWith(
                      color: Appcolors.appTextColor.textLighGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                sizeBoxHeight(30),
                Obx(() {
                  return otpcontro.isLoading.value ||
                          forgotOtpController.isLoading.value
                      ? commonLoading()
                      : GestureDetector(
                          onTap: () {
                            if (widget.isfortap == 1) {
                              otpcontro.otpApi(
                                mobile: widget.number!,
                                otp: otpcontroller.text,
                                email: '',
                                // Device: fcmToken,
                              );
                            } else if (widget.isfortap == 2) {
                              forgotOtpController.forgotVerifyOtpApi(
                                email: widget.email!,
                                otp: otpcontroller.text,
                              );
                            } else if (widget.isfortap == 0) {
                              otpcontro.otpApi(
                                email: widget.email,
                                otp: otpcontroller.text,
                                mobile: '',
                                // Device: fcmToken,
                              );
                            }
                          },
                          child: Container(
                            height: 50,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: otpcontroller.length == 4
                                  ? Appcolors.logoColork
                                  : Appcolors.logoColorWith60Opacityk,
                            ),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: AppTypography.text16(context).copyWith(
                                  color: Appcolors.appTextColor.textWhite,
                                ),
                              ),
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 50);
                }),
                SizedBox(height: Get.height * 0.18),
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
                        style: AppTypography.text14Medium(context).copyWith(
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
    );
  }
}
