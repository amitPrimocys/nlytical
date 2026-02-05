import 'package:flutter/material.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';

TextStyle poppinsFont(double fontSize, Color colorName, FontWeight weight) =>
    TextStyle(
      color: colorName,
      fontSize: fontSize,
      fontFamily: "Poppins",
      letterSpacing: 0.0,
      fontWeight: weight,
    );
TextStyle bostonFont(double fontSize, Color colorName, FontWeight weight) =>
    TextStyle(
      color: colorName,
      fontSize: fontSize,
      fontFamily: "boston",
      letterSpacing: 0.0,
      fontWeight: weight,
    );

class AppTypography {
  // Base text style that includes the font family
  static TextStyle _baseStyle(BuildContext context) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: themeContro.isLightMode.value
          ? Appcolors.appTextColor.textBlack
          : Appcolors.appTextColor.textWhite,
    );
  }

  //******************* Text Box **************************************************************************
  static TextStyle outerMedium(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 12, fontWeight: FontWeight.w500, height: 1.3);
  }

  static TextStyle innerMedium(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 11, fontWeight: FontWeight.w400, height: 1.3);
  }

  //******************* Headings ***************************************************************************
  static TextStyle h1(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
  }

  static TextStyle h2(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 20, fontWeight: FontWeight.w500, height: 1.3);
  }

  static TextStyle h3(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 16, fontWeight: FontWeight.w500, height: 1.3);
  }

  static TextStyle h4(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 16, fontWeight: FontWeight.w400, height: 1.3);
  }

  static TextStyle h5(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.3);
  }

  //***************************** Big text *****************************************************************
  static TextStyle bigText(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 18, fontWeight: FontWeight.w300, height: 1.5);
  }

  //***************************** */ Large, Medium, Small text **********************************************
  static TextStyle largeText(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 16, fontWeight: FontWeight.w300, height: 1.5);
  }

  static TextStyle mediumText(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 14, fontWeight: FontWeight.w300, height: 1.5);
  }

  static TextStyle smallText(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 12, fontWeight: FontWeight.w300, height: 1.5);
  }

  //************************* Menu ***************************************************************************
  static TextStyle menuText(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 9, fontWeight: FontWeight.w400, height: 1.2);
  }

  //************************* Inputs / Buttons ***************************************************************
  static TextStyle buttonText16(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4);
  }

  static TextStyle buttonText14(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4);
  }

  static TextStyle buttonText10(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 10, fontWeight: FontWeight.w500, height: 1.4);
  }

  static TextStyle buttonText12(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
  }

  static TextStyle inputPlaceholder(BuildContext context) {
    return _baseStyle(context).copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: Appcolors.appTextColor.textBlack,
    );
  }

  static TextStyle inputPlaceholderSmall(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
  }

  static TextStyle captionText(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
  }

  //*********************** Underlined text *****************************************************************
  static TextStyle underlinedTextMedium(BuildContext context) {
    return _baseStyle(context).copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle underlinedTextSmall(BuildContext context) {
    return _baseStyle(context).copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle subText(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 8, fontWeight: FontWeight.w400, height: 1.5);
  }

  //****************************** Text medium/ragular ***********************************
  static TextStyle text8Medium(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 8, fontWeight: FontWeight.w500);
  }

  static TextStyle text9Regular(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 9, fontWeight: FontWeight.w400);
  }

  static TextStyle text10Regular(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 10, fontWeight: FontWeight.w400);
  }

  static TextStyle text10Medium(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 10, fontWeight: FontWeight.w500);
  }

  static TextStyle text11Regular(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 11, fontWeight: FontWeight.w400);
  }

  static TextStyle text12Medium(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 12, fontWeight: FontWeight.w500);
  }

  static TextStyle text12Ragular(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 12, fontWeight: FontWeight.w400);
  }

  static TextStyle text14Medium(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  }

  static TextStyle text16(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  }

  static TextStyle text16Semi(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 16, fontWeight: FontWeight.w400);
  }

  // ************************ Footer menu **************************************************************************
  static TextStyle text8MediumMenu(BuildContext context) {
    return _baseStyle(
      context,
    ).copyWith(fontSize: 8, fontWeight: FontWeight.w500);
  }
}
