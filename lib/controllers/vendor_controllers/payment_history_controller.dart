import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:nlytical/models/vendor_models/get_subscription_model.dart';
import 'package:nlytical/models/vendor_models/payment_history_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

class PaymentHistoryController extends GetxController {
  ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  Rx<PaymentHistoryModel> model = PaymentHistoryModel().obs;
  RxList<GoalData> goalData = <GoalData>[].obs;
  RxList<bool> isExpandedList = <bool>[].obs;
  RxList<bool> isExpandedList1 = <bool>[].obs;

  Future<void> getPaymentHistory({required bool isHome}) async {
    try {
      isLoading.value = true;
      final responseJson = await apiHelper.multipartPostMethod(
        url: apiHelper.getGoalspayment,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
        formData: {},
        files: [],
      );
      model.value = PaymentHistoryModel.fromJson(responseJson);
      goalData.clear();
      isExpandedList.clear();
      if (model.value.status == true) {
        goalData.addAll(model.value.goalData!);
        isExpandedList.addAll(List.generate(goalData.length, (index) => false));
      } else {
        if (isHome == false) {
          snackBar(model.value.message!);
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      goalData.clear();
      isExpandedList.clear();
      if (isHome == false) {
        snackBar("Something went wrong, try again");
      }
    }
  }

  RxBool isSubscribe = false.obs;
  Rx<GetSubscriptionModel> getModel = GetSubscriptionModel().obs;
  RxList<Data> subscriPaymentList = <Data>[].obs;
  Future<void> getSubscriptionApi() async {
    try {
      isSubscribe(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.getSubscri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
        formData: {},
        files: [],
      );
      getModel.value = GetSubscriptionModel.fromJson(response);
      subscriPaymentList.clear();
      isExpandedList1.clear();
      if (getModel.value.status == true) {
        subscriPaymentList.addAll(getModel.value.data!);
        isExpandedList1.addAll(
          List.generate(subscriPaymentList.length, (index) => false),
        );
        isSubscribe(false);
      } else {
        isSubscribe(false);
      }
    } catch (e) {
      isSubscribe(false);
    }
  }
}
