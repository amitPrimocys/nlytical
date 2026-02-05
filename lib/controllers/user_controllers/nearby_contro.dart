import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/nearby_model.dart';
import 'package:nlytical/utils/api_helper.dart';

final ApiHelper apiHelper = ApiHelper();

class NearbyContro extends GetxController {
  RxBool isnear = false.obs;
  Rx<NearbyModel?> nearbymodel = NearbyModel().obs;
  RxList<NearbyService> nearbylist = <NearbyService>[].obs;
  RxInt currentpage = 1.obs;
  RxBool hasMoreData = true.obs;

  Future<NearbyModel?> nearbyApi({
    required String page,
    required String? latitudee,
    required String? longitudee,
  }) async {
    try {
      if (page == "1") {
        isnear.value = true;
      }

      var uri = Uri.parse(apiHelper.nearby);
      var request = http.MultipartRequest('POST', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };
      request.headers.addAll(headers);

      request.fields['lat'] = latitudee.toString();
      request.fields['lon'] = longitudee.toString();
      request.fields['page_no'] = page.isEmpty ? '1' : page;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      nearbymodel.value = NearbyModel.fromJson(userData);

      if (nearbymodel.value!.status == true) {
        List<NearbyService>? newData = nearbymodel.value!.nearbyService;

        if (page == "1") {
          nearbylist.value = newData ?? [];
        } else {
          if (newData?.isNotEmpty == true) {
            nearbylist.addAll(newData!);
          } else {
            hasMoreData.value = false;
          }
        }

        if (newData?.isEmpty ?? true) {
          hasMoreData.value = false;
        }
      } else {
        (nearbymodel.value!.message);
      }

      return nearbymodel.value;
    } catch (e) {
      return null;
    } finally {
      if (page == "1") {
        isnear.value = false;
      }
    }
  }
}
