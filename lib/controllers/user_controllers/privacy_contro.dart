import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/privacy_model.dart';
import 'package:nlytical/utils/api_helper.dart';

final ApiHelper apiHelper = ApiHelper();

class PrivacyPolicyContro extends GetxController {
  RxBool isprivacy = false.obs;
  Rx<PrivacyPolicyModel?> privacymodel = PrivacyPolicyModel().obs;

  Future<void> privacypolicyApi() async {
    isprivacy.value = true;

    try {
      var uri = Uri.parse(apiHelper.privacy);
      var request = http.MultipartRequest('GET', uri);

      // request.headers.addAll(headers);
      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      privacymodel.value = PrivacyPolicyModel.fromJson(userData);
      (request.fields);
      (responsData);
      ("status${response.statusCode}");

      if (privacymodel.value!.status == true) {
        isprivacy.value = false;
      } else {
        isprivacy.value = false;
        (privacymodel.value!.message);
      }
    } catch (e) {
      isprivacy.value = false;
    } finally {
      isprivacy.value = false;
    }
  }
}
