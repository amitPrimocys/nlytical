import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/forgot_verify_model.dart';
import 'package:nlytical/auth/resetpass.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

class ForgotOtpController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  Rx<ForgotVerifyModel?> otpmodel = ForgotVerifyModel().obs;

  Future<void> forgotVerifyOtpApi({String? email, String? otp}) async {
    isLoading.value = true;

    try {
      var uri = Uri.parse(apiHelper.forgotVerify);
      var request = http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      };

      request.headers.addAll(headers);

      request.fields['email'] = '$email';
      request.fields['otp'] = '$otp';

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);
      otpmodel.value = ForgotVerifyModel.fromJson(data);

      if (otpmodel.value!.status == true) {
        isLoading.value = false;

        Get.to(Resetpass(email: email));
      } else {
        snackBar(otpmodel.value!.message!);
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      snackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
