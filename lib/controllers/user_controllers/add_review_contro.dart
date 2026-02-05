import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/controllers/user_controllers/service_contro.dart';
import 'package:nlytical/models/user_models/add_review_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

final ApiHelper apiHelper = ApiHelper();

class AddreviewContro extends GetxController {
  RxBool isaddreview = false.obs;
  ServiceContro servicecontro = Get.find();
  Rx<AddReviewModel?> addreviewmodel = AddReviewModel().obs;

  Future<bool> addreviewApi(
    String serviceId,
    String rewstar,
    String rewmsg,
  ) async {
    isaddreview.value = true;

    try {
      var uri = Uri.parse(apiHelper.addreview);
      var request = http.MultipartRequest("POST", uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['service_id'] = serviceId;
      request.fields['review_star'] = rewstar;
      request.fields['review_message'] = rewmsg;

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      addreviewmodel.value = AddReviewModel.fromJson(data);

      if (addreviewmodel.value!.status == true) {
        addreviewmodel.refresh();

        await servicecontro.servicedetailApi(
          serviceID: serviceId,
          isVendorService: false,
        );

        snackBar("Your review added successfully");
        isaddreview.value = false;
        return true;
      } else {
        snackBar(addreviewmodel.value!.message!);
        isaddreview.value = false;
        return false;
      }
    } catch (e) {
      isaddreview.value = false;
      snackBar(e.toString());
      return false;
    }
  }
}
