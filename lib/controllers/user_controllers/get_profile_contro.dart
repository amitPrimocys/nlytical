import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/remove_profile_model.dart';
import 'package:nlytical/models/user_models/get_profile_model.dart';
import 'package:nlytical/models/user_models/update_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/Vendor/screens/auth/subcription.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';

final ApiHelper apiHelper = ApiHelper();

class GetprofileContro extends GetxController {
  RxBool isprofile = false.obs;
  Rx<GetProfileModel?> getprofilemodel = GetProfileModel().obs;
  RxString countrycode = ''.obs;
  TextEditingController fnameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // TextEditingController countryCode = TextEditingController();
  // RxInt subscribedUser = 0.obs;
  // RxInt isStore = 0.obs;

  //get contrycode => null;

  Future<void> getprofileApi() async {
    try {
      await SecurePrefs.getLoadPrefs();
      isprofile(true);
      var uri = Uri.parse(apiHelper.getprofile);
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

      getprofilemodel.value = GetProfileModel.fromJson(userData);

      if (getprofilemodel.value!.userDetails!.loginType == "mobile") {
        await SecurePrefs.setBool(SecureStorageKeys.isPhoneVerify, true);
        final isPhoneVerifyx = (await SecurePrefs.getBool(
          SecureStorageKeys.isPhoneVerify,
        ))!;
        isPhoneVerify = isPhoneVerifyx;
      } else if (getprofilemodel.value!.userDetails!.loginType == "email") {
        await SecurePrefs.setBool(SecureStorageKeys.isEmailVerify, true);
        final isEmailVerifyx = (await SecurePrefs.getBool(
          SecureStorageKeys.isEmailVerify,
        ))!;
        isEmailVerify = isEmailVerifyx;
      } else {
        isEmailVerify = false;
        isPhoneVerify = false;
      }

      if (getprofilemodel.value!.userDetails!.countryFlag!.isNotEmpty) {
        await SecurePrefs.setString(
          SecureStorageKeys.COUINTRY_FLAG_CODE,
          getprofilemodel.value!.userDetails!.countryFlag.toString(),
        );
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.COUINTRY_FLAG_CODE: (v) => countryFlagCode = v!,
        });
      }

      await SecurePrefs.setMultiple({
        SecureStorageKeys.ROlE: getprofilemodel.value!.userDetails!.role
            .toString(),
        SecureStorageKeys.USER_NAME: getprofilemodel
            .value!
            .userDetails!
            .username
            .toString(),
        SecureStorageKeys.USER_FNAME: getprofilemodel
            .value!
            .userDetails!
            .firstName!
            .toString(),
        SecureStorageKeys.USER_LNAME: getprofilemodel
            .value!
            .userDetails!
            .lastName!
            .toString(),
        SecureStorageKeys.USER_EMAIL: getprofilemodel.value!.userDetails!.email!
            .toString(),
        SecureStorageKeys.COUINTRY_CODE: getprofilemodel
            .value!
            .userDetails!
            .countryCode
            .toString(),
        SecureStorageKeys.USER_MOBILE: getprofilemodel
            .value!
            .userDetails!
            .mobile!
            .toString(),
        SecureStorageKeys.IMAGE_STATUS: getprofilemodel
            .value!
            .userDetails!
            .imageStatus
            .toString(),
      });
      await SecurePrefs.getLoadPrefs();
      await SecurePrefs.getMultipleAndSetGlobalsWithMap({
        SecureStorageKeys.IMAGE_STATUS: (v) => image_status = v!,
      });
      fnameController.text = getprofilemodel.value!.userDetails!.firstName!
          .toString();
      lnameController.text = getprofilemodel.value!.userDetails!.lastName!
          .toString();
      emailcontroller.text = getprofilemodel.value!.userDetails!.email!
          .toString();
      countrycode.value = getprofilemodel.value!.userDetails!.countryCode!
          .toString();
      contrycode = getprofilemodel.value!.userDetails!.countryCode!.toString();
      userNameController.text = getprofilemodel.value!.userDetails!.username
          .toString();
      phoneController.text = getMobile(
        getprofilemodel.value!.userDetails!.mobile!.toString(),
      );

      if (getprofilemodel.value!.status == true) {
        isDemo = getprofilemodel.value!.isDemo.toString();
        userIMAGE = getprofilemodel.value!.userDetails!.image.toString();
        isprofile(false);
      } else {
        isprofile(false);
      }
    } catch (e) {
      isprofile(false);
    }
  }

  RxBool isupdate = false.obs;
  Rx<UpdateModel?> updatemodel = UpdateModel().obs;
  Future<void> updateApi({
    String? file,
    String? countryCode,
    String? fname,
    String? lname,
    String? email,
    String? phone,
    required bool isUpdateProfile,
  }) async {
    try {
      await SecurePrefs.getMultipleAndSetGlobalsWithMap({
        SecureStorageKeys.AUTH_TOKEN: (v) => authToken = v!,
      });
      isupdate(true);
      var uri = Uri.parse(apiHelper.update);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      if (isUpdateProfile == false) {
        request.fields['role'] = 'vendor';
      } else {
        request.fields['first_name'] = fnameController.text;
        request.fields['last_name'] = lnameController.text;
        request.fields['email'] = emailcontroller.text;
        request.fields['country_code'] = countryCode!;
        request.fields['country_flag'] = countryFlagCode;
        request.fields['mobile'] =
            "${countrycode.value}${phoneController.text}";
      }

      if (isUpdateProfile == true) {
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath('image', file));
        }
      }

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      updatemodel.value = UpdateModel.fromJson(userData);

      if (updatemodel.value!.status == true) {
        isDemo = updatemodel.value!.userdetails!.isDemo.toString();
        userIMAGE = updatemodel.value!.userdetails!.image.toString();
        if (updatemodel.value!.loginType == 'mobile') {
          await SecurePrefs.setBool(SecureStorageKeys.isPhoneVerify, true);
          final isPhoneVerifyx = (await SecurePrefs.getBool(
            SecureStorageKeys.isPhoneVerify,
          ))!;
          isPhoneVerify = isPhoneVerifyx;
        } else if (updatemodel.value!.loginType == 'email') {
          await SecurePrefs.setBool(SecureStorageKeys.isEmailVerify, true);
          final isEmailVerifyx = (await SecurePrefs.getBool(
            SecureStorageKeys.isEmailVerify,
          ))!;
          isEmailVerify = isEmailVerifyx;
        } else {
          isEmailVerify = false;
          isPhoneVerify = false;
        }

        if (updatemodel.value!.countryFlag!.isNotEmpty) {
          await SecurePrefs.setString(
            SecureStorageKeys.COUINTRY_FLAG_CODE,
            getprofilemodel.value!.userDetails!.countryFlag.toString(),
          );
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.COUINTRY_FLAG_CODE: (v) => countryFlagCode = v!,
          });
        }

        await SecurePrefs.setString(
          SecureStorageKeys.IMAGE_STATUS,
          updatemodel.value!.userdetails!.imageStatus.toString(),
        );
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.IMAGE_STATUS: (v) => image_status = v!,
        });
        getprofileApi();
        subscribedUserGlobal = updatemodel.value!.subscriberUser!;
        isStoreGlobal = updatemodel.value!.isStore!;
        // Navigator.pop(context);

        if (isUpdateProfile == true) {
          // user profile update
          Get.back();
          snackBar(
            languageController.textTranslate(
              "Your Profile Updated successfully",
            ),
          );
        } else {
          // vendor navigate
          await SecurePrefs.setString(SecureStorageKeys.ROlE, 'vendor');
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.ROlE: (v) => userRole = v!,
          });
          Get.offAll(
            () => const SubscriptionSceen(),
            transition: Transition.rightToLeft,
          );

          snackBar(languageController.textTranslate("Welcome to Vendor"));
        }

        isupdate(false);
      } else {
        isupdate(false);
      }
    } catch (e) {
      isupdate(false);
    }
  }

  Rx<UpdateModel?> updatemodel1 = UpdateModel().obs;
  Future<void> updateProfileOne() async {
    try {
      await SecurePrefs.getMultipleAndSetGlobalsWithMap({
        SecureStorageKeys.AUTH_TOKEN: (v) => authToken = v!,
      });
      isupdate(true);
      var uri = Uri.parse(apiHelper.update);
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

      updatemodel1.value = UpdateModel.fromJson(userData);

      if (updatemodel1.value!.status == true) {
        // subscribedUser.value = updatemodel1.value!.subscriberUser!;
        subscribedUserGlobal = updatemodel1.value!.subscriberUser!;
        // isStore.value = updatemodel1.value!.isStore!;
        isStoreGlobal = updatemodel1.value!.isStore!;

        await SecurePrefs.setString(
          SecureStorageKeys.IMAGE_STATUS,
          updatemodel1.value!.userdetails!.imageStatus.toString(),
        );
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.IMAGE_STATUS: (v) => image_status = v!,
        });
        isupdate(false);
      } else {
        isupdate(false);
      }
    } catch (e) {
      isupdate(false);
    }
  }

  RxBool isRemoveProfile = false.obs;
  Rx<RemoveProfileModel> removeProfileModel = RemoveProfileModel().obs;
  Future<bool> removeProfileApi() async {
    try {
      isRemoveProfile(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.removeUserimage,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
        formData: {},
        files: [],
      );

      removeProfileModel.value = RemoveProfileModel.fromJson(response);

      if (removeProfileModel.value.success == true) {
        isRemoveProfile(false);
        await SecurePrefs.setString(SecureStorageKeys.IMAGE_STATUS, "0");
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.IMAGE_STATUS: (v) => image_status = v!,
        });
        getprofileApi();
        snackBar(removeProfileModel.value.message.toString());
        return true;
      } else {
        isRemoveProfile(false);
        snackBar(removeProfileModel.value.message.toString());
        return false;
      }
    } catch (e) {
      isRemoveProfile(false);
      snackBar("Something went wrong, try again");
      return false;
    }
  }
}
