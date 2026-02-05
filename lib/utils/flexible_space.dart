import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';

Widget flexibleSpace() {
  return Container(
    decoration: BoxDecoration(color: Appcolors.appPriSecColor.appPrimblue),
    child: Image.asset(
      AppAsstes.line_design,
      fit: BoxFit.cover,
      color: Appcolors.white,
    ),
  );
}

Widget innerContainer({required Widget child}) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(color: Appcolors.appPriSecColor.appPrimblue),
    child: Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.appBgColor.white
            : Appcolors.appBgColor.darkMainBlack,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: child,
    ),
  );
}
