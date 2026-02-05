import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/Like_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

final ApiHelper apiHelper = ApiHelper();

class LikeContro extends GetxController {
  RxBool islike = false.obs;
  Rx<LikeModel?> likemodel = LikeModel().obs;

  Future<void> likeApi(String serviceId) async {
    try {
      islike.value = true;
      var uri = Uri.parse(apiHelper.like);
      var request = http.MultipartRequest("POST", uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['service_id'] = serviceId;

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      likemodel.value = LikeModel.fromJson(data);

      if (likemodel.value!.status == true) {
        islike.value = false;

        snackBar(likemodel.value!.message!);
      } else {
        snackBar(likemodel.value!.message!);
        islike.value = false;
      }
    } catch (e) {
      islike.value = false;
      snackBar(e.toString());
    } finally {
      islike.value = false;
    }
  }
}
