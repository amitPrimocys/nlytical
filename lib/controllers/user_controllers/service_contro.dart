import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/lead_model.dart';
import 'package:nlytical/models/user_models/service_detail_model.dart';
import 'package:nlytical/utils/api_helper.dart';

final ApiHelper apiHelper = ApiHelper();

class ServiceContro extends GetxController {
  RxBool isservice = false.obs;
  Rx<ServiceDetailModel?> servicemodel = ServiceDetailModel().obs;

  Future<void> servicedetailApi({
    required String serviceID,
    required bool isVendorService,
  }) async {
    try {
      isservice.value = true;
      var uri = Uri.parse(apiHelper.servicedetail);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      isVendorService
          ? request.fields['service_id'] = userStoreID
          : request.fields['service_id'] = serviceID;

      request.fields['lat'] = userLatitude;
      request.fields['lon'] = userLongitude;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      servicemodel.value = ServiceDetailModel.fromJson(userData);

      if (servicemodel.value!.status == true) {
        isservice.value = false;
      } else {
        isservice.value = false;
        (servicemodel.value!.message);
      }
    } catch (e) {
      isservice.value = false;
    } finally {
      isservice.value = false;
    }
  }

  RxBool isLead = false.obs;
  Rx<ServiceLeadModel> serviceModel = ServiceLeadModel().obs;
  Future<void> leadApi({required String serviceID}) async {
    try {
      isLead(true);

      var uri = Uri.parse(apiHelper.count);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);
      request.fields['service_id'] = serviceID;
      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);
      serviceModel.value = ServiceLeadModel.fromJson(userData);

      if (serviceModel.value.status == true) {
        isLead(false);
      } else {
        isLead(false);
      }
    } catch (e) {
      isLead(false);
    }
  }
}
