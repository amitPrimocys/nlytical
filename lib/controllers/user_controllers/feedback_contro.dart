import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/feedback_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

final ApiHelper apiHelper = ApiHelper();

class FeedbackContro extends GetxController {
  RxBool isfeedback = false.obs;

  Rx<FeedbackModel?> feedbackmodel = FeedbackModel().obs;

  Future<bool> feedbackApi(String feedstar, String feedmsg) async {
    try {
      isfeedback.value = true;
      var uri = Uri.parse(apiHelper.addfeedback);
      var request = http.MultipartRequest("POST", uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['feedback_star'] = feedstar;
      request.fields['feedback_review'] = feedmsg;

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      feedbackmodel.value = FeedbackModel.fromJson(data);

      if (feedbackmodel.value!.status == true) {
        isfeedback.value = false;
        snackBar(feedbackmodel.value!.message!);
        return true;
      } else {
        snackBar(feedbackmodel.value!.message!);
        isfeedback.value = false;
        return false;
      }
    } catch (e) {
      isfeedback.value = false;
      snackBar(e.toString());
      return false;
    }
  }
}
