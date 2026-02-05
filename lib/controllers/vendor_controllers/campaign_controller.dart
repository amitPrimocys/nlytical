import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/models/vendor_models/add_campaign_model.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/vendor_models/get_campaign_model.dart';

final ApiHelper apiHelper = ApiHelper();

class CampaignController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<AddCamoaignModel?> addcampmodel = AddCamoaignModel().obs;

  Future<void> addCampaignApi({
    String? campaignName,
    String? addres,
    String? lat,
    String? lon,
    String? areadistance,
  }) async {
    try {
      isLoading.value = true;
      var uri = Uri.parse(apiHelper.addcampaign);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['service_id'] = userStoreID;
      request.fields['campaign_name'] = campaignName!;
      request.fields['address'] = addres!;
      request.fields['lat'] = lat!;
      request.fields['lon'] = lon!;
      request.fields['area_distance'] = areadistance!;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      addcampmodel.value = AddCamoaignModel.fromJson(userData);

      if (addcampmodel.value!.status == true) {
        isLoading.value = false;

        Get.back();
        snackBar("Campaign added successfully!");
        getCampaignApi(isHome: true);
      } else {
        isLoading.value = false;
        snackBar(addcampmodel.value!.message!);
      }
    } catch (e) {
      isLoading.value = false;
      snackBar("Something went wrong, try again");
    }
  }

  RxBool getLoading = false.obs;
  Rx<GetCampaignModel?> getcampaignmodel = GetCampaignModel().obs;
  RxList<CampaignData> camplist = <CampaignData>[].obs;

  RxList<bool> istapList = <bool>[].obs;
  RxnInt selectedIndex = RxnInt(null);

  void toggleTap(int index) {
    istapList[index] = !istapList[index];
  }

  Future<void> getCampaignApi({required bool isHome}) async {
    try {
      getLoading.value = true;

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.getcampaign,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
        files: [],
        formData: {},
      );

      getcampaignmodel.value = GetCampaignModel.fromJson(response);
      camplist.clear();

      if (getcampaignmodel.value!.status == true) {
        camplist.addAll(getcampaignmodel.value!.campaignData!);
        getLoading.value = false;
      } else {
        getLoading.value = false;
        if (isHome == false) {
          snackBar(getcampaignmodel.value!.message!);
        }
      }
    } catch (e) {
      getLoading.value = false;
      if (isHome == false) {
        snackBar("Something went wrong, try again");
      }
    }
  }
}
