// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/user_models/get_profile_model.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/models/vendor_models/update_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';

class ProfileCotroller extends GetxController {
  ApiHelper apiHelper = ApiHelper();
  final userNameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  RxString contrycode = ''.obs;

  RxBool isGetData = false.obs;
  Rx<GetProfileModel> getDataModel = GetProfileModel().obs;

  Future<void> getProfleApi() async {
    try {
      isGetData(true);

      var uri = Uri.parse(apiHelper.getProfile);
      var request = http.MultipartRequest("POST", uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      getDataModel.value = GetProfileModel.fromJson(data);

      (request.fields);

      if (getDataModel.value.status == true) {
        isGetData(false);
        userNameController.text = getDataModel.value.userDetails!.username
            .toString();
        fnameController.text = getDataModel.value.userDetails!.firstName
            .toString();
        lnameController.text = getDataModel.value.userDetails!.lastName
            .toString();
        emailController.text = getDataModel.value.userDetails!.email.toString();
        contrycode.value = getDataModel.value.userDetails!.countryCode!;
        phoneController.text = getMobile(
          getDataModel.value.userDetails!.mobile!.toString(),
        );

        if (userName.isNotEmpty) {
          userNameController.text = userName;
        }

        await SecurePrefs.setMultiple({
          SecureStorageKeys.USER_FNAME: getDataModel
              .value
              .userDetails!
              .firstName
              .toString(),
          SecureStorageKeys.USER_LNAME: getDataModel.value.userDetails!.lastName
              .toString(),
          SecureStorageKeys.LOGGED_IN_USERIMAGE: getDataModel
              .value
              .userDetails!
              .image
              .toString(),
        });
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.USER_FNAME: (v) => userFirstName = v!,
          SecureStorageKeys.USER_LNAME: (v) => userLastName = v!,
          SecureStorageKeys.LOGGED_IN_USERIMAGE: (v) => userIMAGE = v!,
        });
      } else {
        isGetData(false);
        snackBar(getDataModel.value.message!);
      }
    } catch (e) {
      isGetData(false);
      (e.toString());
    }
  }

  RxBool isUpdate = false.obs;
  Rx<UpdateProfileModel> updateModel = UpdateProfileModel().obs;

  Future<void> updateProfileApi(
    image, {
    required String username,
    required String fname,
    required String lname,
    required String email,
    required String countryCode,
    required String phone,
  }) async {
    try {
      isUpdate(true);

      var uri = Uri.parse(apiHelper.updateUserprofile);
      var request = http.MultipartRequest("POST", uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };
      request.headers.addAll(headers);
      request.fields['first_name'] = fname;
      request.fields['last_name'] = lname;
      request.fields['email'] = email;
      request.fields['country_code'] = countryCode;
      request.fields['username'] = username;
      request.fields['mobile'] = "$countryCode$phone";
      request.fields['role'] = "vendor";

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image));
      }

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      updateModel.value = UpdateProfileModel.fromJson(data);

      if (updateModel.value.status == true) {
        userNameController.text = updateModel.value.userdetails!.username
            .toString();
        await SecurePrefs.setString(
          SecureStorageKeys.USER_NAME,
          updateModel.value.userdetails!.username.toString(),
        );
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.USER_NAME: (v) => userName = v!,
        });
        snackBar(
          languageController.textTranslate("Your profile updated successfully"),
        );
        getProfleApi();
        isUpdate(false);
      } else {
        isUpdate(false);
        snackBar(updateModel.value.message!);
      }
    } catch (e) {
      isUpdate(false);
      (e.toString());
      snackBar(
        languageController.textTranslate("Something went wrong, try again"),
      );
    }
  }

  Future<void> updateProfileApi1() async {
    try {
      isUpdate(true);

      var uri = Uri.parse(apiHelper.updateUserprofile);
      var request = http.MultipartRequest("POST", uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);
      request.fields['role'] = "vendor";

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      updateModel.value = UpdateProfileModel.fromJson(data);

      if (updateModel.value.status == true) {
        getProfleApi();
        isUpdate(false);
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
    }
  }
}
