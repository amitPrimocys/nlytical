import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/subcate_service_model.dart';
import 'package:nlytical/utils/api_helper.dart';

final ApiHelper apiHelper = ApiHelper();

class SubcateserviceContro extends GetxController {
  RxBool issubcat = false.obs;
  Rx<SubcatServiceModel?> subcateservicemodel = SubcatServiceModel().obs;
  RxList<FeaturedServices> subcatelist = <FeaturedServices>[].obs;
  RxList<AllServices> allcatelist = <AllServices>[].obs;

  Future<SubcatServiceModel?> subcateserviceApi({
    required String page,
    required String? catId,
    required String? subcatId,
  }) async {
    issubcat.value = true;

    try {
      var uri = Uri.parse(apiHelper.subcategoryservices);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['category_id'] = '$catId';
      request.fields['subcategory_id'] = '$subcatId';
      request.fields['page_no'] = page.isEmpty ? '1' : page;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      subcateservicemodel.value = SubcatServiceModel.fromJson(userData);

      subcatelist.clear();

      if (subcateservicemodel.value!.status == true) {
        subcatelist.addAll(subcateservicemodel.value!.featuredServices!);
        if (page == "1") {
          allcatelist.value = subcateservicemodel.value!.allServices!
              .where((element) => element.isFeatured == 0)
              .toList();
        } else {
          allcatelist.addAll(
            subcateservicemodel.value!.allServices!.where(
              (element) => element.isFeatured == 0,
            ),
          );
        }
        issubcat.value = false;
      } else {
        issubcat.value = false;
        (subcateservicemodel.value!.message);
      }

      return subcateservicemodel.value;
    } catch (e) {
      issubcat.value = false;
      return null;
    } finally {
      issubcat.value = false;
    }
  }
}
