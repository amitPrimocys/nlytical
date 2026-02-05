// ignore_for_file: unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/models/vendor_models/feedback_model.dart';
import 'package:nlytical/models/vendor_models/review_model.dart';
import 'package:nlytical/utils/common_widgets.dart';

final ApiHelper apiHelper = ApiHelper();

class ReviewControvendor extends GetxController {
  RxBool isfav = false.obs;
  Rx<ReviewModel?> riviewmodel = ReviewModel().obs;
  RxList<Reviewlist> riviewlist = <Reviewlist>[].obs;

  Future<void> reviewApi({required String page}) async {
    try {
      isfav.value = true;
      var uri = Uri.parse(apiHelper.reviewlist);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['page_no'] = page.isEmpty ? '1' : page;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      riviewmodel.value = ReviewModel.fromJson(userData);

      if (riviewmodel.value!.status == true) {
        if (page == "1") {
          // For the first page, clear the existing list
          riviewlist.value = riviewmodel.value!.reviewlist!;
        } else {
          // For the subsequent pages, add the new items to the existing list
          riviewlist.addAll(riviewmodel.value!.reviewlist!);
          riviewlist.toSet().toList();
        }

        isfav.value = false;
      } else {
        isfav.value = false;
        (riviewmodel.value!.message);
      }
    } catch (e) {
      isfav.value = false;
    } finally {
      isfav.value = false;
    }
  }

  RxBool isfeedback = false.obs;
  Rx<FeedbackModel?> feedbackmodel = FeedbackModel().obs;

  Future<void> feedbackApi(String feedstar, String feedmsg) async {
    isfeedback.value = true;

    try {
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
        snackBar(feedbackmodel.value!.message!);
        feedbackmodel.refresh();

        Get.back();
        isfeedback.value = false;
        snackBar(feedbackmodel.value!.message!);
        //navigate to cart
      } else {
        snackBar(feedbackmodel.value!.message!);
        isfeedback.value = false;
      }
    } catch (e) {
      isfeedback.value = false;
      snackBar(e.toString());
    } finally {
      isfeedback.value = false;
    }
  }
}
