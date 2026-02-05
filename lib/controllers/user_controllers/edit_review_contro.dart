// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/review_contro.dart';
import 'package:nlytical/models/user_models/delete_model.dart';
import 'package:nlytical/models/user_models/review_edit_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/utils/common_widgets.dart';

final ApiHelper apiHelper = ApiHelper();

class EditReviewContro extends GetxController {
  RxBool isedit = false.obs;
  Rx<ReviewEditModel?> revieweditmodel = ReviewEditModel().obs;
  final msgController = TextEditingController();
  RxDouble rateValue = 0.0.obs;
  ReviewContro reviewcontro = Get.find();
  RxInt page = 1.obs;

  Future<void> reviewEditApi({
    String? reviewid,
    String? reviewstar,
    String? review_messsage,
    required bool isupdate,
    String? serviceId,
  }) async {
    isedit.value = true;

    try {
      var uri = Uri.parse(apiHelper.revieweditlist);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      if (isupdate == true) {
        request.fields['id'] = reviewid!;
        request.fields['service_id'] = serviceId!;
      } else {
        request.fields['id'] = reviewid!;
        request.fields['service_id'] = serviceId!;
        request.fields['review_star'] = reviewstar!;
        request.fields['review_message'] = review_messsage!;
      }

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      revieweditmodel.value = ReviewEditModel.fromJson(userData);

      if (revieweditmodel.value!.status == true) {
        if (isupdate == true) {
          msgController.text = revieweditmodel.value!.reviewdata!.reviewMessage
              .toString();
          rateValue.value = double.parse(
            revieweditmodel.value!.reviewdata!.reviewStar.toString(),
          );

          snackBar(languageController.textTranslate("Your Review Updated"));
        } else {}
        isedit.value = false;
      }
    } catch (e) {
      isedit.value = false;
    } finally {
      isedit.value = false;
    }
  }

  RxBool isdelete = false.obs;
  Rx<DeleteModel?> deletemodel = DeleteModel().obs;
  Future<bool> reviewdelete({String? reviewid}) async {
    isdelete.value = true;

    try {
      var uri = Uri.parse(apiHelper.deletereview);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['id'] = reviewid!;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      deletemodel.value = DeleteModel.fromJson(userData);

      if (deletemodel.value!.status == true) {
        snackBar(
          languageController.textTranslate("Delete Review successfully"),
        );
        Get.back();
        isdelete.value = false;
        return true;
      } else {
        snackBar(deletemodel.value!.message.toString());
        isdelete.value = false;

        return false;
      }
    } catch (e) {
      isdelete.value = false;
      snackBar("Something went wrong");

      return false;
    }
  }
}
