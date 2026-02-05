import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/models/vendor_models/customersupport_model.dart';
import 'package:nlytical/models/vendor_models/faq_model.dart';
import 'package:http/http.dart' as http;

final ApiHelper apiHelper = ApiHelper();

class SupportController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<FaqModel?> faqmodel = FaqModel().obs;

  RxList<bool> isExpandedList = <bool>[].obs;

  Future<void> faqApi() async {
    isLoading.value = true;

    try {
      var uri = Uri.parse(apiHelper.supportfaqs);
      var request = http.MultipartRequest('GET', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      };

      request.headers.addAll(headers);

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      faqmodel.value = FaqModel.fromJson(userData);

      if (faqmodel.value!.status == true) {
        isExpandedList.value = List.filled(
          faqmodel.value?.data?.length ?? 0,
          false,
        );

        isLoading.value = false;
      } else {
        isLoading.value = false;
        (faqmodel.value!.message);
      }
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isLoading1 = false.obs;
  Rx<CustomerSupportModel?> cutomersupport = CustomerSupportModel().obs;

  Future<void> customersupportApi({
    String? name,
    String? email,
    String? phone,
    String? message,
  }) async {
    isLoading1.value = true;

    try {
      var uri = Uri.parse(apiHelper.customersupport);
      var request = http.MultipartRequest('POST', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);
      request.fields['name'] = name!;
      request.fields['email'] = email!;
      request.fields['phone'] = phone!;
      request.fields['message'] = message!;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      cutomersupport.value = CustomerSupportModel.fromJson(userData);

      if (cutomersupport.value!.status == true) {
        Get.back();
        snackBar(cutomersupport.value!.message!);
        isLoading1.value = false;
      } else {
        isLoading1.value = false;
        snackBar(cutomersupport.value!.message!);
        (cutomersupport.value!.message);
      }
    } catch (e) {
      isLoading1.value = false;
    } finally {
      isLoading1.value = false;
    }
  }
}
