// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/reset_model.dart';
import 'package:nlytical/auth/login.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

class ResetContro extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  var isObscureForSignUp = true.obs;
  Rx<ResetModel?> registerModel = ResetModel().obs;

  Future<void> resetApi({
    String? ConfirmPassword,
    String? Email,
    String? Password,
  }) async {
    isLoading.value = true;

    try {
      var uri = Uri.parse(apiHelper.reset);
      var request = http.MultipartRequest("POST", uri);

      request.fields['email'] = '$Email';
      request.fields['password'] = '$Password';
      request.fields['confirm_password'] = '$ConfirmPassword';

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);
      registerModel.value = ResetModel.fromJson(data);

      if (registerModel.value!.status == true) {
        isLoading.value = false;

        snackBar(registerModel.value!.message!);

        Get.offAll(() => Login(isLogin: false));
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
}
