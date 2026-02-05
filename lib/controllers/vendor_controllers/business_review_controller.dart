import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/models/vendor_models/business_review_model.dart';
import 'package:nlytical/utils/common_widgets.dart';

final ApiHelper apiHelper = ApiHelper();

class BusinessReviewController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<BusinessReviewModel?> businessriviewmodel = BusinessReviewModel().obs;
  RxList<UserReviews> reviewList = <UserReviews>[].obs;
  RxString bussinessName = ''.obs;
  RxString bussinessReview = ''.obs;
  RxList<String> bussinessImage = <String>[].obs;
  RxInt businessReviewCount = 0.obs;

  Future<void> businessReviewApi() async {
    try {
      isLoading.value = true;
      var uri = Uri.parse(apiHelper.businessreviewlist);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['service_id'] = userStoreID;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      businessriviewmodel.value = BusinessReviewModel.fromJson(userData);
      reviewList.clear();
      bussinessImage.clear();

      if (businessriviewmodel.value!.status == true) {
        reviewList.addAll(businessriviewmodel.value!.userReviews!);
        bussinessName.value = businessriviewmodel
            .value!
            .serviceDetails!
            .serviceName!
            .toString();
        bussinessReview.value = businessriviewmodel
            .value!
            .serviceDetails!
            .totalAvgReview!
            .toString();
        bussinessImage.addAll(
          businessriviewmodel.value!.serviceDetails!.serviceImages!,
        );
        businessReviewCount.value =
            businessriviewmodel.value!.serviceDetails!.totalReviewCount!;

        isLoading.value = false;
      } else {
        isLoading.value = false;
        snackBar(businessriviewmodel.value!.message.toString());
      }
    } catch (e) {
      isLoading.value = false;
      reviewList.clear();
      snackBar(e.toString());
    }
  }
}
