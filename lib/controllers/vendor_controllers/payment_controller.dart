// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/campaign_controller.dart';
import 'package:nlytical/models/payment_getway_list_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/models/vendor_models/getpaymentmodel.dart';
import 'package:nlytical/utils/global.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

ApiHelper apiHelper = ApiHelper();

class PaymentController extends GetxController {
  @override
  void onInit() {
    getPaymentList();
    super.onInit();
  }

  // RxBool isloading = false.obs;
  Rx<GetPaymentModel?> paymentmodel = GetPaymentModel().obs;

  RxBool isPayment = false.obs;
  Rx<PaymentGetwayModel> model = PaymentGetwayModel().obs;
  Future<void> getPaymentList() async {
    try {
      isPayment(true);

      var uri = Uri.parse(apiHelper.paymentconfig);
      var request = http.MultipartRequest('Get', uri);
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      };

      request.headers.addAll(headers);

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);
      model.value = PaymentGetwayModel.fromJson(userData);
      if (model.value.success == "true") {
        final stripeKey = model.value.data?.stripe?.publicKey;
        if (stripeKey != null && stripeKey.isNotEmpty) {
          Stripe.publishableKey = stripeKey;
          await Stripe.instance.applySettings();
        } else {}
        isPayment(false);
      } else {
        isPayment(false);
      }
    } catch (e) {
      isPayment(false);
    }
  }

  RxBool isStripeLoading = false.obs;
  RxBool isPaypalLoading = false.obs;
  RxBool isRazorPayLoading = false.obs;
  RxBool isGooglePayLoading = false.obs;
  RxBool isApplePayLoading = false.obs;
  RxBool isFlutterWaveLoading = false.obs;

  Future<bool> paymentApi({
    required String goalId,
    required String price,
    required String paymentType,
  }) async {
    try {
      if (paymentType == "stripe") {
        isStripeLoading(true);
      } else if (paymentType == "razorpay") {
        isRazorPayLoading(true);
      } else if (paymentType == "googlepay") {
        isGooglePayLoading(true);
      } else if (paymentType == "apple pay") {
        isApplePayLoading(true);
      } else if (paymentType == "flutterwave") {
        isFlutterWaveLoading(true);
      }

      var uri = Uri.parse(apiHelper.addpayment);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['goal_id'] = goalId;
      request.fields['payment_mode'] = paymentType;
      request.fields['service_id'] = userStoreID;
      request.fields['price'] = price.replaceAll(RegExp(r'[^\d.]'), '');

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      paymentmodel.value = GetPaymentModel.fromJson(userData);

      if (paymentmodel.value!.status == true) {
        if (paymentType == "stripe") {
          isStripeLoading(false);
        } else if (paymentType == "razorpay") {
          isRazorPayLoading(false);
        } else if (paymentType == "googlepay") {
          isGooglePayLoading(false);
        } else if (paymentType == "apple pay") {
          isApplePayLoading(false);
        } else if (paymentType == "flutterwave") {
          isFlutterWaveLoading(false);
        }

        Get.find<CampaignController>().getCampaignApi(isHome: true);
        paymentDialogSucess();

        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
          roleController.isVendorSelected();
          Get.offAll(() => TabbarScreen(currentIndex: 0));
        });
        return true;
      } else {
        if (paymentType == "stripe") {
          isStripeLoading(false);
        } else if (paymentType == "razorpay") {
          isRazorPayLoading(false);
        } else if (paymentType == "googlepay") {
          isGooglePayLoading(false);
        } else if (paymentType == "apple pay") {
          isApplePayLoading(false);
        } else if (paymentType == "flutterwave") {
          isFlutterWaveLoading(false);
        }
        (paymentmodel.value!.message);
        return false;
      }
    } catch (e) {
      if (paymentType == "stripe") {
        isStripeLoading(false);
      } else if (paymentType == "razorpay") {
        isRazorPayLoading(false);
      } else if (paymentType == "googlepay") {
        isGooglePayLoading(false);
      } else if (paymentType == "apple pay") {
        isApplePayLoading(false);
      } else if (paymentType == "flutterwave") {
        isFlutterWaveLoading(false);
      }
      snackBar(
        languageController.textTranslate("Something went wrong, try again"),
      );
      return false;
    }
  }

  //================================================================ STRIPE PAYMENT METHOD ===========================================================
  //================================================================ STRIPE PAYMENT METHOD ===========================================================
  Map<String, dynamic>? customer;
  Map<String, dynamic>? paymentIntent;

  Future<void> makeStripePayment({
    required String goalId,
    required String price,
    required String key,
    required String mode,
  }) async {
    isStripeLoading.value = true;

    int stripeAmountInCents = (double.parse(price) * 100).round();
    // Find the matching currency code
    String currencyCode = "USD"; // Default currency

    try {
      // Call createCustomer API
      customer = await createCustomer(key);

      // Check if the customer creation was successful
      if (customer != null && customer!.containsKey('id')) {
        // Get the customer ID
        String customerId = customer!['id'];

        paymentIntent = await createPaymentIntent(
          stripeAmountInCents.toString(),
          currencyCode,
          customerId,
          key,
        );

        var gpay = PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          currencyCode: currencyCode,
          testEnv: true,
        );

        // STEP 2: Initialize Payment Sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            merchantDisplayName: 'Merchant Name',
            style: ThemeMode.light,
            googlePay: gpay,
            allowsDelayedPaymentMethods: true,
          ),
        );

        // STEP 3: Display Payment sheet
        displayPaymentSheet(
          goalId: goalId,
          price: stripeAmountInCents.toString(),
        );

        isStripeLoading.value = false; // Stop showing loader
      } else {
        isStripeLoading.value = false; // Stop showing loader
      }
    } catch (err) {
      isStripeLoading.value = false; // Stop showing loader
    }
  }

  Future<void> displayPaymentSheet({
    required String goalId,
    required String price,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        final success = await paymentApi(
          goalId: goalId,
          price: price,
          paymentType: "stripe",
        );

        if (success) {
          paymentDialogSucess();

          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
          });
        } else {
          Get.back();
        }
        isStripeLoading.value = false;
      });
    } catch (e) {
      isStripeLoading.value = false;
      ('$e');
    }
  }

  Future<dynamic> createPaymentIntent(
    String amount,
    String currency,
    String customerId,
    String key,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency.toUpperCase(),
        'customer': customerId,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      (json.decode(response.body));
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<dynamic> createCustomer(String key) async {
    try {
      Map<String, dynamic> body = {'email': "demo2@gmail.com"};

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: json.encode(body),
      );
      return json.decode(response.body);
    } catch (err) {
      (err.toString());
      throw Exception(err.toString());
    }
  }

  //============================================= RAZORPAY ===============================================================================================
  //============================================= RAZORPAY ===============================================================================================
  RxString selectedGoalId = "".obs;
  RxString selectedPrice = "".obs;
  void rezorPay({
    required String goalId,
    required String price,
    required String key,
  }) {
    isRazorPayLoading(true);
    selectedGoalId.value = goalId;
    selectedPrice.value = price;

    Razorpay razorpay = Razorpay();
    var options = {
      'key': key,
      'amount': int.parse(price.replaceAll(RegExp(r'[^\d.]'), '')) * 100,
      'name': "Nlytical app",
      'description': "",
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm'],
      },
      "currency": 'USD',
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    isRazorPayLoading(false);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    final success = await paymentApi(
      goalId: selectedGoalId.value,
      price: selectedPrice.value,
      paymentType: "razorpay",
    );

    if (success) {
      paymentDialogSucess();

      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    }
    isRazorPayLoading(false);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    isRazorPayLoading(false);
  }

  Future<double> convertUSDtoOTHER(double amount, String currencyCode) async {
    try {
      // Fetch live exchange rate (Replace with your API Key)
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$currencyCode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double exchangeRate = data["rates"]["USD"]; // Get CNY to USD rate
        return amount * exchangeRate;
      } else {
        throw Exception("Failed to load exchange rate");
      }
    } catch (e) {
      ("Exchange Rate Error: $e");
      return amount * 0.138; // Default fallback conversion rate
    }
  }
}
