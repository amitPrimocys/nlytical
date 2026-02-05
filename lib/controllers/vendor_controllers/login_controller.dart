// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/auth/google_signin.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/auth/welcome.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/controllers/vendor_controllers/payment_controller.dart';
import 'package:nlytical/models/payment_success_model.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/models/vendor_models/delete_model.dart';
import 'package:nlytical/models/vendor_models/login_model.dart';
import 'package:nlytical/models/vendor_models/subscription_plan_model.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';

class LoginContro1 extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  var isObscureForSignUp = true.obs;
  Rx<LoginModel> loginModel = LoginModel().obs;
  StoreController storeController = Get.put(StoreController());
  PaymentController paymentCtrl = Get.find();
  GetprofileContro getprofilecontro = Get.find();

  @override
  void onInit() {
    subscriptionPlanDetails(isHome: true);
    super.onInit();
  }

  //============================================= SUBSCRIPTION PLAN =======================================================
  final RxString selectedPayment = "Credit or Debit Card".obs;

  RxList<Map<String, String>> paymentOptions = [
    {
      "title": "Credit or Debit Card",
      "value": "credit_debit",
      "image": "assets/images/cr&deb.png",
    },
    {
      "title": "PayPal",
      "value": "paypal",
      "image": "assets/images/paypal_image.png",
    },
    {"title": "Gpay", "value": "gpay", "image": "assets/images/gpay.png"},
    {
      "title": "Apple Pay",
      "value": "apple pay",
      "image": "assets/images/apple.png",
    },
    {
      "title": "Razorpay",
      "value": "razorpay",
      "image": "assets/images/razorpay.png",
    },
    {
      "title": "Flutterwave",
      "value": "flutterwave",
      "image": "assets/images/flutterwave_logo.png",
    },
  ].obs;

  RxBool isSubscriptionDetailLoading = false.obs;
  RxBool isPaymentSuccessLoading = false.obs;

  RxList<SubscriptionDetail> subscriptionDetailsData =
      <SubscriptionDetail>[].obs;
  Rx<SubscriptionDetailModel> subscriptionDetailModel =
      SubscriptionDetailModel().obs;

  RxInt selectedPlanIndex = 0.obs;

  Future<void> subscriptionPlanDetails({required bool isHome}) async {
    try {
      isSubscriptionDetailLoading(true);
      final responseJson = await apiHelper.postMethod(
        url: apiHelper.subscriptionPlan,
        requestBody: {},
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );

      subscriptionDetailModel.value = SubscriptionDetailModel.fromJson(
        responseJson,
      );
      subscriptionDetailsData.clear();
      if (subscriptionDetailModel.value.status == true) {
        subscriptionDetailsData.addAll(
          subscriptionDetailModel.value.subscriptionDetail!,
        );

        isSubscriptionDetailLoading(false);
      } else {
        isSubscriptionDetailLoading(false);
        if (isHome == false) {
          snackBar(subscriptionDetailModel.value.message!);
        }
      }
    } catch (e) {
      isSubscriptionDetailLoading(false);
      if (isHome == false) {
        snackBar("Something went wrong, try again");
      }
    }
  }

  Rx<PaymentSuccessModel> paymentSuccessModel = PaymentSuccessModel().obs;
  Future<bool> paymentSuccess({
    required String paymentType,
    String appleIAPPlan = '',
  }) async {
    try {
      isPaymentSuccessLoading.value = true;
      final responseJson = await apiHelper.multipartPostMethod(
        url: apiHelper.paymentSuccess,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
        formData: {
          if (appleIAPPlan.isEmpty)
            "subscription_id": subscriptionDetailsData[selectedPlanIndex.value]
                .id
                .toString(),
          "plan_name": appleIAPPlan.isNotEmpty
              ? appleIAPPlan
              : subscriptionDetailsData[selectedPlanIndex.value].planName!,
          if (appleIAPPlan.isEmpty)
            "price": subscriptionDetailsData[selectedPlanIndex.value].price!
                .replaceAll(RegExp(r'[^\d.]'), ''),
          "payment_mode": paymentType,
        },
        files: [],
      );
      paymentSuccessModel.value = PaymentSuccessModel.fromJson(responseJson);
      if (paymentSuccessModel.value.status == true) {
        Get.find<GetprofileContro>().updateProfileOne();
        Get.find<GetprofileContro>().updatemodel1.refresh();
        await SecurePrefs.setString(SecureStorageKeys.SUBSCRIBE, "1");
      }
      isPaymentSuccessLoading.value = false;
      return true;
    } catch (e) {
      isPaymentSuccessLoading.value = false;
      return false;
    }
  }

  //==================================================== LOGIN CONTROLLER ======================================================================
  RxBool isdelete = false.obs;
  Rx<DeleteModel> deletemodel = DeleteModel().obs;
  RxBool isLogout = false.obs;

  Future<void> deleteApi() async {
    try {
      isdelete.value = true;
      var uri = Uri.parse(apiHelper.delete);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      deletemodel.value = DeleteModel.fromJson(userData);

      if (deletemodel.value.status == true) {
        await SecurePrefs.setString(SecureStorageKeys.lnId, "1");
        await languageController.getLanguageTranslation(lnId: "1");
        if (!themeContro.isLightMode.value) {
          await themeContro.toggleThemeMode(true);
        }
        languageController.updateTextDirection();
        languageController.languageTranslationsData.refresh();
        await SecurePrefs.clear();
        userEmail = '';
        userIMAGE = '';
        signOutGoogle();
        isdelete.value = false;
        Get.offAll(() => const Welcome());

        snackBar("Delete Successfully");
      } else {
        isdelete.value = false;
        (deletemodel.value.message);
      }
    } catch (e) {
      isdelete.value = false;
      (e.toString());
    }
  }
}
