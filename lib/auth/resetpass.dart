// ignore_for_file: must_be_immutable

import 'dart:ui';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/password_contro.dart';
import 'package:nlytical/controllers/user_controllers/reset_contro.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class Resetpass extends StatefulWidget {
  String? email;
  Resetpass({super.key, this.email});

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {
  TextEditingController conformcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  final cfmPassFieldKey = GlobalKey<FormFieldState>();
  final passFieldKey = GlobalKey<FormFieldState>();

  FocusNode passFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode conformpassFocusNode = FocusNode();
  FocusNode conformpasswordFocusNode = FocusNode();

  // ResetContro resetcontro = Get.find();
  ResetContro resetcontro = Get.put(ResetContro());
  PassCheckController passCheckCtrl = Get.find();
  // final GlobalKey<FormState> _keyform = GlobalKey();

  bool isselected = false;

  void fieldcheck() {
    setState(() {
      isselected =
          passcontroller.text.isNotEmpty &&
          passcontroller.text.contains(
            RegExp(r'[A-Za-z0-9@#$%^&+=]'),
          ) && // Specific characters
          passcontroller.text.length >= 8 && // Minimum length
          conformcontroller.text.isNotEmpty && // Confirm password not empty
          passcontroller.text ==
              conformcontroller.text; // Confirm matches new password
    });
  }

  @override
  void initState() {
    conformcontroller.addListener(fieldcheck);
    passcontroller.addListener(fieldcheck);

    super.initState();
  }

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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(
                        'New Password',
                        style: AppTypography.outerMedium(context).copyWith(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      sizeBoxWidth(3),
                      label(
                        ' *',
                        textColor: Appcolors.appTextColor.textRedColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(4),
                passwordField().paddingSymmetric(horizontal: 10),
                sizeBoxHeight(15),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(
                        'Confirm Password',
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
                confirm().paddingSymmetric(horizontal: 20),
                sizeBoxHeight(25),
                Obx(() {
                  return resetcontro.isLoading.value
                      ? commonLoading()
                      : GestureDetector(
                          onTap: () {
                            final isEmailValid =
                                passFieldKey.currentState?.validate() ?? false;
                            final isPasswordValid =
                                cfmPassFieldKey.currentState?.validate() ??
                                false;
                            if (isEmailValid && isPasswordValid) {
                              resetcontro.resetApi(
                                Email: widget.email,
                                Password: passcontroller.text,
                                ConfirmPassword: conformcontroller.text,
                              );
                            } else {
                              snackBar("Please fill the mandatory fields");
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: isselected
                                  ? Appcolors.logoColork
                                  : Appcolors.logoColorWith60Opacityk,
                            ),
                            child: Center(
                              child: label(
                                "Sign In",
                                style: AppTypography.text16(context).copyWith(
                                  color: Appcolors.appTextColor.textWhite,
                                ),
                              ),
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 50);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget confirm() {
    return TextFormField(
      key: cfmPassFieldKey,
      cursorColor: themeContro.isLightMode.value
          ? Appcolors.appPriSecColor.appPrimblue
          : Appcolors.white,
      autofocus: false,
      style: AppTypography.text11Regular(context).copyWith(
        color: themeContro.isLightMode.value
            ? Appcolors.appTextColor.textBlack
            : Appcolors.appTextColor.textWhite,
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          cfmPassFieldKey.currentState?.validate();
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: conformcontroller,
      readOnly: false,
      keyboardType: TextInputType.text,
      // Toggle obscure text
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Appcolors.appPriSecColor.appPrimblue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: themeContro.isLightMode.value
                ? Appcolors.appStrokColor.cF0F0F0
                : Appcolors.darkBorder,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Appcolors.appTextColor.textRedColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Appcolors.appTextColor.textRedColor),
        ),
        hintText: "Confirm Password",
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
                'assets/images/lock.png',
                color: Appcolors.grey500,
                height: 20,
              ),
            ),
          ),
        ),
        errorStyle: poppinsFont(
          12,
          Appcolors.appTextColor.textRedColor,
          FontWeight.normal,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Re-Enter New Password';
        }

        if (passcontroller.text != conformcontroller.text) {
          return 'Password Does Not Match';
        }
        return null;
      },
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
                  key: passFieldKey,
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
                      passFieldKey.currentState?.validate();
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

                    hintText: "New Password",
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
                            : Appcolors.darkBorder,
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
                    labelStyle: poppinsFont(
                      12,
                      Appcolors.black,
                      FontWeight.w400,
                    ),
                  ),

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
