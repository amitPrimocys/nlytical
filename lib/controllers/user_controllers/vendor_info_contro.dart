import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nlytical/models/user_models/vendor_info_model.dart';
import 'package:nlytical/utils/api_helper.dart';

ApiHelper apiHelper = ApiHelper();

class VendorInfoContro extends GetxController {
  RxBool isfav = false.obs;
  Rx<VendorInfoModel> vendorlistmodel = VendorInfoModel().obs;
  RxList<ServiceDetails> vendorlist = <ServiceDetails>[].obs;

  Future<void> vendorApi({String? toUSerID}) async {
    isfav.value = true;

    try {
      var uri = Uri.parse(apiHelper.vendorinfo);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['vendor_id'] = toUSerID!;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      vendorlistmodel.value = VendorInfoModel.fromJson(userData);
      vendorlist.clear();

      if (vendorlistmodel.value.status == true) {
        vendorlist.addAll(vendorlistmodel.value.serviceDetails!);
        isfav.value = false;
      } else {
        isfav.value = false;
        (vendorlistmodel.value.message);
      }
    } catch (e) {
      isfav.value = false;
    }
  }
}
