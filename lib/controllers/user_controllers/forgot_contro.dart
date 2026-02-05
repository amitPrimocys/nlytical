import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/forgot_model.dart';
import 'package:nlytical/auth/otpscreen.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

class ForgotContro extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  var isObscureForSignUp = true.obs;
  Rx<ForgotModel?> forgotModel = ForgotModel().obs;

  Future<void> forgotApi({String? email}) async {
    isLoading.value = true;

    try {
      var uri = Uri.parse(apiHelper.forgot);
      var request = http.MultipartRequest("POST", uri);

      request.fields['email'] = '$email';

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);
      forgotModel.value = ForgotModel.fromJson(data);

      if (forgotModel.value!.status == true) {
        isLoading.value = false;

        snackBar(forgotModel.value!.message!);

        //navigate to cart
        Get.to(() => Otpscreen(email: email, devicetoken: 'ABC', isfortap: 2));
      } else {
        isLoading.value = false;
        snackBar(forgotModel.value!.message!);
      }
    } catch (e) {
      isLoading.value = false;
      snackBar(e.toString());
    }
  }
}
