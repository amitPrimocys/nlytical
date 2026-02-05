// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/user_models/otp_model.dart';
import 'package:nlytical/auth/profile_details.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

class OtpController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  Rx<OtpModel?> otpmodel = OtpModel().obs;

  Future<void> otpApi({
    required String? email,
    required String? mobile,
    required String? otp,
    String deviceToken = 'KKK',
  }) async {
    try {
      isLoading.value = true;
      // API URL
      var url = Uri.parse(apiHelper.otp);

      // Constructing request body
      Map<String, String> body = {
        'otp': otp ?? '',
        'device_token': deviceToken,
      };

      if (email != null && email.isNotEmpty) {
        body['email'] = email;
        body['device_token'] = deviceToken;
      } else if (mobile != null && mobile.isNotEmpty) {
        body['mobile'] = mobile;
        body['device_token'] = deviceToken;
      }

      // Sending POST request
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      var data = json.decode(response.body);
      otpmodel.value = OtpModel.fromJson(data);

      if (otpmodel.value?.status == true) {
        await SecurePrefs.setMultiple({
          SecureStorageKeys.AUTH_TOKEN: otpmodel.value!.token,
        });
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.AUTH_TOKEN: (v) => authToken = v!,
        });
        if (email != null && email.isNotEmpty) {
          await SecurePrefs.setMultiple({
            SecureStorageKeys.USER_EMAIL: otpmodel.value!.email!,
          });
        } else if (mobile != null && mobile.isNotEmpty) {
          await SecurePrefs.setMultiple({
            SecureStorageKeys.USER_MOBILE: otpmodel.value!.mobile!,
          });
        }

        if (otpmodel.value!.loginType == 'mobile') {
          await SecurePrefs.setMultiple({
            SecureStorageKeys.isPhoneVerify: true,
          });
          isPhoneVerify = (await SecurePrefs.getBool(
            SecureStorageKeys.isPhoneVerify,
          ))!;
        } else if (otpmodel.value!.loginType == 'email') {
          await SecurePrefs.setMultiple({
            SecureStorageKeys.isEmailVerify: true,
          });
          isEmailVerify = (await SecurePrefs.getBool(
            SecureStorageKeys.isEmailVerify,
          ))!;
        } else {
          isEmailVerify = false;
          isPhoneVerify = false;
        }

        if (otpmodel.value!.countryFlag!.isNotEmpty) {
          await SecurePrefs.setMultiple({
            SecureStorageKeys.COUINTRY_FLAG_CODE: otpmodel.value!.countryFlag
                .toString(),
          });
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.COUINTRY_FLAG_CODE: (v) => countryFlagCode = v!,
          });
        }

        if (otpmodel.value!.role!.toLowerCase() == "user") {
          await SecurePrefs.setMultiple({
            SecureStorageKeys.USER_ID: otpmodel.value!.userId.toString(),
            SecureStorageKeys.USER_FNAME: otpmodel.value!.firstName.toString(),
          });
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.USER_ID: (v) => userID = v!,
            SecureStorageKeys.USER_FNAME: (v) => userFirstName = v!,
          });

          if (userFirstName.isEmpty) {
            Get.to(
              () => ProfileDetails(number: otpmodel.value!.mobile, email: ""),
            );
          } else {
            roleController.isUserSelected();
            Get.offAll(() => TabbarScreen(currentIndex: 0));
          }
        } else {
          await SecurePrefs.remove(SecureStorageKeys.USER_ID);
          userID = "";
          await SecurePrefs.setMultiple({
            SecureStorageKeys.USER_ID: otpmodel.value!.userId.toString(),
            SecureStorageKeys.STORE_ID: otpmodel.value!.serviceId.toString(),
            SecureStorageKeys.SUBSCRIBE: otpmodel.value!.userSubscription
                .toString(),
          });
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.USER_ID: (v) => userID = v!,
            SecureStorageKeys.STORE_ID: (v) => userStoreID = v!,
          });
          // Get.offAll(() => VendorNewTabar(currentIndex: 0));
          roleController.isVendorSelected();
          Get.offAll(() => TabbarScreen(currentIndex: 0));
        }
        snackBar("Login Successfully".tr);

        // Navigate to TabbarScreen
      } else {
        snackBar(otpmodel.value?.message ?? "Invalid response");
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      snackBar('Error: $e');
    }
  }
}
