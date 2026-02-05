// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/review_model.dart';
import 'package:nlytical/utils/api_helper.dart';

final ApiHelper apiHelper = ApiHelper();

class ReviewContro extends GetxController {
  RxBool isfav = false.obs;
  Rx<ReviewModel?> riviewmodel = ReviewModel().obs;
  RxList<Reviewlist> riviewlist = <Reviewlist>[].obs;

  Future<void> reviewApi({required String page}) async {
    isfav.value = true;

    try {
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
      }
    } catch (e) {
      isfav.value = false;
    } finally {
      isfav.value = false;
    }
  }
}
