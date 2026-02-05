import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/all_login_status_model.dart';
import 'package:nlytical/models/default_lang_model.dart';
import 'package:nlytical/models/general_setting_model.dart';
import 'package:nlytical/models/language_list_model.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/colors.dart';
import 'dart:ui' as ui;
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';

class LanguageController extends GetxController {
  ApiHelper apiHelper = ApiHelper();
  @override
  void onInit() {
    generalSettingApi();
    allLoginStatusApi();
    getLanguageTranslation();
    getLanguages();
    loadTextDirection();
    super.onInit();
  }

  RxBool isLanguagLoading = false.obs;
  RxBool isGetLanguagsLoading = false.obs;
  RxBool isAppSettingsLoading = false.obs;

  Rx<LanguageListModel> langListModel = LanguageListModel().obs;
  RxList<Languages> languagesList = <Languages>[].obs;

  Rx<DefaulLangModel> languageTranslationsData = DefaulLangModel().obs;

  Rx<TextDirection> currentDirection = TextDirection.ltr.obs;

  void updateTextDirection() async {
    currentDirection.value =
        languageTranslationsData.value.languageAlignment == null ||
            languageTranslationsData.value.languageAlignment!.isEmpty
        ? ui.TextDirection.ltr
        : (languageTranslationsData.value.languageAlignment == "ltr")
        ? TextDirection.ltr
        : TextDirection.rtl;

    await SecurePrefs.setString(
      SecureStorageKeys.textDirection,
      currentDirection.value == TextDirection.rtl ? "rtl" : "ltr",
    );
    userTextDirection = (await SecurePrefs.getString(
      SecureStorageKeys.textDirection,
    ))!;
  }

  void loadTextDirection() async {
    String? savedDirection = await SecurePrefs.getString(
      SecureStorageKeys.textDirection,
    );
    userTextDirection = savedDirection ?? "ltr";
    currentDirection.value = userTextDirection == "rtl"
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  // lang list api
  Future<void> getLanguages() async {
    try {
      isGetLanguagsLoading.value = true;

      final responseJson = await apiHelper.postMethod(
        url: apiHelper.listAllLanguages,
        requestBody: {},
      );
      languagesList.clear();
      if (responseJson["success"] == true) {
        languagesList.value = LanguageListModel.fromJson(
          responseJson,
        ).languages!.where((element) => element.status == 1).toList();
      }

      isGetLanguagsLoading.value = false;
    } catch (e) {
      isGetLanguagsLoading.value = false;
    }
  }

  Future<void> getLanguageTranslation({String? lnId}) async {
    try {
      isLanguagLoading.value = true;

      final responseJson = await apiHelper.postMethod(
        url: apiHelper.defaultLanguage,
        headers: {},
        requestBody: lnId == null ? {'status_id': "1"} : {'status_id': lnId},
      );

      if (responseJson["success"] == true) {
        languageTranslationsData.value = DefaulLangModel.fromJson(responseJson);
        await SecurePrefs.setString(
          SecureStorageKeys.textDirection,
          languageTranslationsData.value.languageAlignment.toString(),
        );
        userTextDirection = (await SecurePrefs.getString(
          SecureStorageKeys.textDirection,
        ))!;

        isLanguagLoading.value = false;
      } else {
        isLanguagLoading.value = false;
        snackBar(responseJson["message"].toString());
      }
    } catch (e) {
      isLanguagLoading.value = false;
      snackBar(
        languageController.textTranslate("Something went wrong, try again"),
      );
    } finally {
      isLanguagLoading.value = false;
    }
  }

  String textTranslate(String text) {
    return languageTranslationsData.value.results == null ||
            languageTranslationsData.value.results!.isEmpty
        ? text
        : languageTranslationsData.value.results!
              .where((element) => element.key == text)
              .isEmpty
        ? text
        : languageTranslationsData.value.results!
                  .where((element) => element.key == text)
                  .first
                  .translation ==
              null
        ? text
        : languageTranslationsData.value.results!
              .where((element) => element.key == text)
              .first
              .translation!;
  }

  TextDirection textDirection() {
    return languageTranslationsData.value.languageAlignment == null ||
            languageTranslationsData.value.languageAlignment!.isEmpty
        ? ui.TextDirection.ltr
        : languageTranslationsData.value.languageAlignment == "ltr"
        ? ui.TextDirection.ltr
        : ui.TextDirection.rtl;
  }

  RxBool isSetting = false.obs;
  Rx<GeneralSettingModel> settingModel = GeneralSettingModel().obs;
  Future<void> generalSettingApi() async {
    try {
      isSetting(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.generalSetting,
        headers: {},
        formData: {},
        files: [],
      );

      settingModel.value = GeneralSettingModel.fromJson(response);

      if (settingModel.value.status == true) {
        appLogo = settingModel.value.data!.lightLogoUrl!;
        appColorCode = settingModel.value.data!.colorCode!;
        appColorCode = appColorCode.replaceAll("#", "");
        int colorInt = int.parse("0xFF$appColorCode");
        Appcolors.appPriSecColor.appPrimblue = Color(colorInt);
        appName = settingModel.value.data!.name!;
        appAndroidUrl = settingModel.value.data!.androidUrl!;
        appIOSurl = settingModel.value.data!.iosUrl!;
        appPayment = settingModel.value.data!.isPayment!;
        isSetting(false);
      } else {
        isSetting(false);
      }
    } catch (e) {
      isSetting(false);
    }
  }

  RxBool isLoginStatusLoading = false.obs;
  Rx<AllLoginStatusModel> allLoginStatusModel = AllLoginStatusModel().obs;
  Future<void> allLoginStatusApi() async {
    try {
      isLoginStatusLoading(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.allLoginStatus,
        headers: {},
        formData: {},
        files: [],
      );

      allLoginStatusModel.value = AllLoginStatusModel.fromJson(response);

      if (allLoginStatusModel.value.responseCode == "1") {
        appleLoginStatus = allLoginStatusModel.value.apple.toString();
        googleLoginStatus = allLoginStatusModel.value.google.toString();
        emailLoginStatus = allLoginStatusModel.value.email.toString();
        mobileLoginStatus = allLoginStatusModel.value.mobileotp.toString();
        isLoginStatusLoading(false);
      } else {
        isLoginStatusLoading(false);
      }
    } catch (e) {
      isLoginStatusLoading(false);
    }
  }
}
