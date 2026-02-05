import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/user_models/update_model.dart';
import 'package:nlytical/auth/profile_details.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

class ProfileDetailContro extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  Rx<UpdateModel?> updatemodel = UpdateModel().obs;

  Future<void> newupdateApi({
    required String uname,
    required String fname,
    required String laname,
    required bool isEmail,
    String? email,
    String? number,
    String? code,
    String? file,
  }) async {
    try {
      isLoading.value = true;

      var url = Uri.parse(apiHelper.update);

      var request = http.MultipartRequest('POST', url);
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      if (isEmail == false) {
        request.fields.addAll({
          'username': uname,
          'first_name': fname,
          'last_name': laname,
          'email': email!,
        });
      } else {
        request.fields.addAll({
          'username': uname,
          'first_name': fname,
          'last_name': laname,
          'email': email!,
          'country_code': "$code",
          'mobile': "$code${number!}",
          'country_flag': countryFlagCode,
        });
      }

      if (file != null && file.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', file));
      }

      var response = await request.send();

      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      updatemodel.value = UpdateModel.fromJson(userData);

      if (updatemodel.value?.status == true) {
        isLoading.value = false;

        await SecurePrefs.setString(
          SecureStorageKeys.ROlE,
          updatemodel.value!.userdetails!.role!,
        );
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.ROlE: (v) => userRole = v!,
        });

        if (updatemodel.value!.loginType == 'mobile') {
          await SecurePrefs.setBool(SecureStorageKeys.isPhoneVerify, true);
          isPhoneVerify = (await SecurePrefs.getBool(
            SecureStorageKeys.isPhoneVerify,
          ))!;
        } else if (updatemodel.value!.loginType == 'email') {
          await SecurePrefs.setBool(SecureStorageKeys.isEmailVerify, true);
          isEmailVerify = (await SecurePrefs.getBool(
            SecureStorageKeys.isEmailVerify,
          ))!;
        } else {
          isEmailVerify = false;
          isPhoneVerify = false;
        }

        if (updatemodel.value!.countryFlag!.isNotEmpty) {
          await SecurePrefs.setMultiple({
            SecureStorageKeys.COUINTRY_FLAG_CODE: updatemodel.value!.countryFlag
                .toString(),
          });
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.COUINTRY_FLAG_CODE: (v) => countryFlagCode = v!,
          });
        }

        await SecurePrefs.setMultiple({
          SecureStorageKeys.USER_NAME: updatemodel.value!.userdetails!.username
              .toString(),
          SecureStorageKeys.USER_FNAME: updatemodel
              .value!
              .userdetails!
              .firstName
              .toString(),
          SecureStorageKeys.USER_EMAIL: updatemodel.value!.userdetails!.email
              .toString(),
          SecureStorageKeys.COUINTRY_CODE:
              updatemodel.value!.userdetails!.countryCode!,
          SecureStorageKeys.USER_MOBILE:
              updatemodel.value!.userdetails!.mobile!,
        });
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.COUINTRY_CODE: (v) => contrycode = v!,
          SecureStorageKeys.USER_FNAME: (v) => userFirstName = v!,
          SecureStorageKeys.USER_EMAIL: (v) => userEmail = v!,
        });

        if (userFirstName.isEmpty && userEmail.isEmpty) {
          Get.offAll(
            () => ProfileDetails(
              number: updatemodel.value!.userdetails!.mobile.toString(),
            ),
          );
        } else {
          roleController.isUserSelected();
          Get.offAll(() => TabbarScreen(currentIndex: 0));
        }
      } else {
        isLoading.value = false;
        snackBar(updatemodel.value?.message ?? 'Something went wrong');
      }
    } catch (e) {
      isLoading.value = false;
      snackBar('Error: $e');
    }
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Future<void> createProfileApi({
    required String uname,
    required String fname,
    required String laname,
    required bool isEmail,
    String? email,
    String? number,
    String? code,
    String? file,
  }) async {
    try {
      isLoading.value = true;

      var url = Uri.parse(apiHelper.update);

      var request = http.MultipartRequest('POST', url);
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      if (isEmail == false) {
        if (uname.isNotEmpty &&
            fname.isNotEmpty &&
            laname.isNotEmpty &&
            email!.isNotEmpty) {
          request.fields.addAll({
            'username': uname,
            'first_name': fname,
            'last_name': laname,
            'email': email,
          });
        } else {
          snackBar("Please fill the mandatory fields");
        }
      } else {
        if (uname.isNotEmpty &&
            fname.isNotEmpty &&
            laname.isNotEmpty &&
            email!.isNotEmpty &&
            number!.isNotEmpty) {
          request.fields.addAll({
            'username': uname,
            'first_name': fname,
            'last_name': laname,
            'email': email,
            'country_code': "$code",
            'mobile': "$code$number",
            'country_flag': countryFlagCode,
          });
        } else {
          snackBar("Please fill the mandatory fields");
        }
      }

      if (file != null && file.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', file));
      }

      var response = await request.send();

      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      updatemodel.value = UpdateModel.fromJson(userData);

      if (updatemodel.value?.status == true) {
        await SecurePrefs.setString(
          SecureStorageKeys.ROlE,
          updatemodel.value!.userdetails!.role!,
        );
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.ROlE: (v) => userRole = v!,
        });

        await SecurePrefs.setString(
          SecureStorageKeys.USER_NAME,
          updatemodel.value!.userdetails!.username.toString(),
        );

        if (updatemodel.value!.loginType == 'mobile') {
          await SecurePrefs.setBool(SecureStorageKeys.isPhoneVerify, true);
          isPhoneVerify = (await SecurePrefs.getBool(
            SecureStorageKeys.isPhoneVerify,
          ))!;
        } else if (updatemodel.value!.loginType == 'email') {
          await SecurePrefs.setBool(SecureStorageKeys.isEmailVerify, true);
          isEmailVerify = (await SecurePrefs.getBool(
            SecureStorageKeys.isEmailVerify,
          ))!;
        } else {
          isEmailVerify = false;
          isPhoneVerify = false;
        }

        if (updatemodel.value!.countryFlag!.isNotEmpty) {
          await SecurePrefs.setString(
            SecureStorageKeys.COUINTRY_FLAG_CODE,
            updatemodel.value!.countryFlag.toString(),
          );
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.COUINTRY_FLAG_CODE: (v) => countryFlagCode = v!,
          });
        }

        await SecurePrefs.setMultiple({
          SecureStorageKeys.USER_FNAME: updatemodel
              .value!
              .userdetails!
              .firstName
              .toString(),
          SecureStorageKeys.USER_EMAIL: updatemodel.value!.userdetails!.email
              .toString(),
          SecureStorageKeys.COUINTRY_CODE:
              updatemodel.value!.userdetails!.countryCode!,
          SecureStorageKeys.USER_MOBILE:
              updatemodel.value!.userdetails!.mobile!,
        });
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.COUINTRY_CODE: (v) => contrycode = v!,
          SecureStorageKeys.USER_FNAME: (v) => userFirstName = v!,
          SecureStorageKeys.USER_EMAIL: (v) => userEmail = v!,
        });

        if (userFirstName.isEmpty && userEmail.isEmpty) {
          Get.offAll(
            () => ProfileDetails(
              number: updatemodel.value!.userdetails!.mobile.toString(),
            ),
          );
        } else {
          roleController.isUserSelected();
          Get.offAll(() => TabbarScreen(currentIndex: 0));
        }
        isLoading.value = false;
      } else {
        isLoading.value = false;
        snackBar(updatemodel.value?.message ?? 'Something went wrong');
      }
    } catch (e) {
      isLoading.value = false;
      snackBar('Something went wrong, try again');
    }
  }
}
