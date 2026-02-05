// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/terms_model.dart';
import 'package:nlytical/utils/api_helper.dart';

final ApiHelper apiHelper = ApiHelper();

class TermsContro extends GetxController {
  RxBool isterms = false.obs;
  Rx<TermsModel?> termsandcondimodel = TermsModel().obs;
  RxList<Data> termsdata = <Data>[].obs;

  Future<void> termsandcondiApi() async {
    isterms.value = true;

    try {
      var uri = Uri.parse(apiHelper.terms);
      var request = http.MultipartRequest('GET', uri);

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      termsandcondimodel.value = TermsModel.fromJson(userData);
      termsdata.clear();

      if (termsandcondimodel.value!.status == true) {
        termsdata.addAll(termsandcondimodel.value!.data!);
        isterms.value = false;
      } else {
        isterms.value = false;
        (termsandcondimodel.value!.message);
      }
    } catch (e) {
      isterms.value = false;
    } finally {
      isterms.value = false;
    }
  }
}
