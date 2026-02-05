import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/models/vendor_models/add_goal_model.dart';
import 'package:nlytical/models/vendor_models/get_budget_model.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/Vendor/screens/new_tabber.dart/sponsor/price_details.dart';

ApiHelper apiHelper = ApiHelper();

class BudgetController extends GetxController {
  RxBool isloading = false.obs;
  Rx<GetBudgetModel?> getbudgetmodel = GetBudgetModel().obs;
  RxList<Data> getbudget = <Data>[].obs;

  Future<void> getbudgetAPI() async {
    isloading.value = true;

    try {
      var uri = Uri.parse(apiHelper.getbudgett);
      var request = http.MultipartRequest('GET', uri);

      var response = await request.send();
      var responsdata = await response.stream.transform(utf8.decoder).join();
      var userdata = json.decode(responsdata);

      getbudgetmodel.value = GetBudgetModel.fromJson(userdata);

      getbudget.clear();

      if (getbudgetmodel.value!.status = true) {
        getbudget.addAll(getbudgetmodel.value!.data!);
        isloading.value = false;
      } else {
        isloading.value = false;
        (getbudgetmodel.value!.message);
      }
    } catch (e) {
      isloading.value = false;
    }
  }

  RxBool isLoading = false.obs;
  Rx<AddGoalsModel?> addcampmodel = AddGoalsModel().obs;

  Future<void> addBudgetApi({
    String? campaignID,
    String? startDate,
    String? endDate,
    String? dayss,
    String? pricee,
  }) async {
    isLoading.value = true;

    try {
      var uri = Uri.parse(apiHelper.addgoal);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['campaign_id'] = campaignID!;
      request.fields['start_date'] = startDate!;
      request.fields['end_date'] = endDate!;
      request.fields['days'] = dayss!;
      request.fields['price'] = pricee!;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      addcampmodel.value = AddGoalsModel.fromJson(userData);

      if (addcampmodel.value!.status == true) {
        isLoading.value = false;

        snackBar(
          languageController.textTranslate("Your Budget added successfully!"),
        );
        Get.to(
          () => PriceDetails(
            startdate: addcampmodel.value!.goal!.startDate!.toString(),
            enddate: addcampmodel.value!.goal!.endDate!.toString(),
            price: addcampmodel.value!.goal!.price!.toString(),
            totaldays: addcampmodel.value!.goal!.days!.toString(),
            goalId: addcampmodel.value!.goal!.id.toString(),
          ),
        );
        // GetCampaignApi();
      } else {
        isLoading.value = false;
        snackBar(addcampmodel.value!.message.toString());
      }
    } catch (e) {
      isLoading.value = false;
      snackBar("something went wrong, try again");
    }
  }
}
