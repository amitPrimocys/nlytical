import 'dart:async';
import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/register_model.dart';
import 'package:nlytical/auth/otpscreen.dart';
import 'package:nlytical/models/user_name_check_model.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

class RegisterContro extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  var isObscureForSignUp = true.obs;
  Rx<RegisterModel?> registerModel = RegisterModel().obs;

  @override
  void onInit() {
    userNameStatus.value = UserNameStatus.initial;
    super.onInit();
  }

  Future<void> registerApi({
    String? username,
    String? firstname,
    String? lastname,
    String? newmobile,
    String? countrycode,
    String? email,
    String? password,
  }) async {
    isLoading.value = true;

    try {
      var uri = Uri.parse(apiHelper.userRegister);
      var request = http.MultipartRequest("POST", uri);

      request.fields['username'] = '$username';
      request.fields['first_name'] = '$firstname';
      request.fields['last_name'] = '$lastname';
      request.fields['new_mobile'] = '$countrycode$newmobile';
      request.fields['country_code'] = '$countrycode';
      request.fields['email'] = '$email';
      request.fields['password'] = '$password';
      request.fields['role'] = 'user';
      request.fields['country_flag'] = countryFlagCode;

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);
      registerModel.value = RegisterModel.fromJson(data);

      if (registerModel.value!.status == true) {
        await SecurePrefs.clear();
        isLoading.value = false;

        snackBar(registerModel.value!.message!);
        await SecurePrefs.setMultiple({
          SecureStorageKeys.USER_NAME: username.toString(),
          SecureStorageKeys.COUINTRY_CODE: "$countrycode",
          SecureStorageKeys.USER_MOBILE: '$countrycode$newmobile',
        });
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.USER_NAME: (v) => userName = v!,
          SecureStorageKeys.COUINTRY_CODE: (v) => contrycode = v!,
          SecureStorageKeys.USER_MOBILE: (v) => userMobileNum = v!,
        });

        Get.to(() => Otpscreen(email: email, devicetoken: 'KKK', isfortap: 0));
      } else {
        isLoading.value = false;
        snackBar(registerModel.value!.message!);
      }
    } catch (e) {
      isLoading.value = false;
      snackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isUserName = false.obs;
  Rx<UserNameCheckModel> userNameCheckModel = UserNameCheckModel().obs;
  Timer? _debounce;
  Rx<UserNameStatus> userNameStatus = UserNameStatus.initial.obs;
  RxString userNameError = ''.obs;
  RxString currentUserName = ''.obs;

  Future<void> userNameCheckApi(String username) async {
    if (username.trim().isEmpty) {
      userNameError.value = '';
      userNameStatus.value = UserNameStatus.initial;
      return;
    }
    try {
      isUserName(true);
      await Future.delayed(Duration(milliseconds: 1000));

      userNameStatus.value = UserNameStatus.initial;

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.userNameCheck,
        files: [],
        headers: {},
        formData: {"username": username},
      );
      userNameCheckModel.value = UserNameCheckModel.fromJson(response);

      if (userNameCheckModel.value.status == true) {
        userNameStatus.value = UserNameStatus.success;
        userNameError.value = "";
        isUserName(false);
      } else {
        userNameStatus.value = UserNameStatus.error;
        userNameError.value = userNameCheckModel.value.message.toString();
        isUserName(false);
      }
    } catch (e) {
      userNameStatus.value = UserNameStatus.error;
      userNameError.value = "Please enter your user name";
      isUserName(false);
    }
  }

  void onUserNameChanged(String value) {
    currentUserName.value = value;

    if (value.trim().isEmpty) {
      userNameStatus.value = UserNameStatus.error;
      userNameError.value = "Please enter your user name";
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      return;
    }

    userNameStatus.value = UserNameStatus.loading;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      userNameCheckApi(value);
    });
  }
}

enum UserNameStatus { initial, loading, success, error }
