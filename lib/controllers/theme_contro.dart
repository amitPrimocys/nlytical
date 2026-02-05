// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/theame_switch.dart';
import 'package:nlytical/utils/colors.dart';

class ThemeContro extends GetxController {
  RxBool isLightTheme = false.obs; // Default to light theme

  final RxBool _isLightMode = true.obs;

  // Getter for the current theme mode
  RxBool get isLightMode => _isLightMode;

  // Function to toggle the theme mode
  Future<void> toggleThemeMode(bool value) async {
    _isLightMode.value = value; // ✅ Set value properly

    await SecurePrefs.setBool(
      SecureStorageKeys.isLightMode,
      _isLightMode.value,
    );

    var isLight = await SecurePrefs.getBool(SecureStorageKeys.isLightMode);
  }

  void updateLightModeValue(bool value) {
    _isLightMode.value = value;
  }

  Widget lightDarkModeSwitch({required bool isVendor}) {
    return Container(
      height: 45,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: !isLightMode.value ? Appcolors.darkGray : Appcolors.white,
        boxShadow: [
          BoxShadow(
            color: !isLightMode.value
                ? Appcolors.darkShadowColor
                : Appcolors.grey300,
            blurRadius: 14.0,
            spreadRadius: 0.0,
            offset: const Offset(2.0, 4.0), // shadow direction: bottom right
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                AppAsstes.moon,
                height: 18,
                color: !isLightMode.value ? Appcolors.white : Appcolors.black,
              ),
              sizeBoxWidth(10),
              label(
                !isLightMode.value
                    ? languageController.textTranslate("Dark Mode")
                    : languageController.textTranslate("Light Mode"),
                fontSize: 12,
                textColor: !isLightMode.value
                    ? Appcolors.white
                    : Appcolors.black,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Obx(
            () => CustomSwitch(
              value: _isLightMode.value,
              onChanged: (bool value) {
                toggleThemeMode(value);
              },
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 15),
    ).paddingSymmetric(horizontal: isVendor ? 10 : 0);
  }
}
