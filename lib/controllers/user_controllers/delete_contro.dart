// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/auth/google_signin.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/user_models/delete_model.dart';
import 'package:nlytical/auth/welcome.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/global.dart';

final ApiHelper apiHelper = ApiHelper();

class DeleteController extends GetxController {
  RxBool isdelete = false.obs;
  Rx<DeleteModel?> deletemodel = DeleteModel().obs;
  RxBool isLogout = false.obs;
  Future<void> deleteApi() async {
    try {
      isdelete.value = true;
      var uri = Uri.parse(apiHelper.delete);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      deletemodel.value = DeleteModel.fromJson(userData);

      if (deletemodel.value!.status == true) {
        userEmail = '';
        userIMAGE = '';
        image_status = '';
        subscribedUserGlobal = 0;
        isStoreGlobal = 0;
        await SecurePrefs.clear();
        await SecurePrefs.setString(SecureStorageKeys.lnId, "1");
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.lnId: (v) => userLangID = v!,
        });
        await languageController.getLanguageTranslation(lnId: "1");
        languageController.updateTextDirection();
        languageController.languageTranslationsData.refresh();
        if (!themeContro.isLightMode.value) {
          await themeContro.toggleThemeMode(true);
        }

        signOutGoogle();
        await FirebaseMessaging.instance.deleteToken();
        roleController.isUserSelected();
        isdelete.value = false;
        Get.offAll(() => const Welcome());

        snackBar("Delete Successfully");
      } else {
        isdelete.value = false;

        snackBar(deletemodel.value!.message!);
      }
    } catch (e) {
      isdelete.value = false;
      snackBar(
        languageController.textTranslate("Something went wrong try again"),
      );
    } finally {
      isdelete.value = false;
    }
  }
}
