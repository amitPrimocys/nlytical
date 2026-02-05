import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nlytical/models/user_models/register_model.dart';
import 'package:nlytical/auth/otpscreen.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';

class MobileContro extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  Rx<RegisterModel?> registerModel = RegisterModel().obs;

  Future<void> registerNumberApi({
    required String newmobile,
    required String countrycode,
  }) async {
    try {
      isLoading.value = true;

      // API URL
      var url = Uri.parse(apiHelper.userRegister);

      // Request body
      Map<String, String> body = {
        'country_code': countrycode,
        'mobile': newmobile,
        'role': 'user',
        'country_flag': countryFlagCode,
      };

      // Sending a POST request
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      // Parsing response

      var data = json.decode(response.body);
      registerModel.value = RegisterModel.fromJson(data);

      if (registerModel.value?.status == true) {
        if (registerModel.value!.userBlock == 1) {
          // Navigate to OTP screen
          Get.to(
            () => Otpscreen(
              countryCode: countrycode,
              number: newmobile,
              devicetoken: 'KKK',
              isfortap: 1,
            ),
            transition: Transition.rightToLeft,
          );
          snackBar(registerModel.value!.message.toString());
        } else {
          userDisableSheet();
        }
      } else {
        snackBar(registerModel.value!.message.toString());
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      snackBar('Error: $e');
    }
  }
}
