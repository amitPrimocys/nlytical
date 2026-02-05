class PaymentGetwayModel {
  String? success;
  String? message;
  Data? data;

  PaymentGetwayModel({this.success, this.message, this.data});

  PaymentGetwayModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  RazorPay? razorPay;
  RazorPay? flutterwave;
  RazorPay? stripe;
  RazorPay? paypal;
  RazorPay? googlePay;
  RazorPay? applepay;

  Data({
    this.razorPay,
    this.flutterwave,
    this.stripe,
    this.paypal,
    this.googlePay,
    this.applepay,
  });

  Data.fromJson(Map<String, dynamic> json) {
    razorPay =
        json['Razor Pay'] != null ? RazorPay.fromJson(json['Razor Pay']) : null;
    flutterwave =
        json['Flutterwave'] != null
            ? RazorPay.fromJson(json['Flutterwave'])
            : null;
    stripe = json['Stripe'] != null ? RazorPay.fromJson(json['Stripe']) : null;
    paypal = json['Paypal'] != null ? RazorPay.fromJson(json['Paypal']) : null;
    googlePay =
        json['Google Pay'] != null
            ? RazorPay.fromJson(json['Google Pay'])
            : null;
    applepay =
        json['Applepay'] != null ? RazorPay.fromJson(json['Applepay']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (razorPay != null) {
      data['Razor Pay'] = razorPay!.toJson();
    }
    if (flutterwave != null) {
      data['Flutterwave'] = flutterwave!.toJson();
    }
    if (stripe != null) {
      data['Stripe'] = stripe!.toJson();
    }
    if (paypal != null) {
      data['Paypal'] = paypal!.toJson();
    }
    if (googlePay != null) {
      data['Google Pay'] = googlePay!.toJson();
    }
    if (applepay != null) {
      data['Applepay'] = applepay!.toJson();
    }
    return data;
  }
}

class RazorPay {
  String? publicKey;
  String? secretKey;
  String? mode;
  String? countryCode;
  String? currencyCode;
  int? status;

  RazorPay({
    this.publicKey,
    this.secretKey,
    this.mode,
    this.countryCode,
    this.currencyCode,
    this.status,
  });

  RazorPay.fromJson(Map<String, dynamic> json) {
    publicKey = json['public_key'];
    secretKey = json['secret_key'];
    mode = json['mode'];
    countryCode = json['country_code'];
    currencyCode = json['currency_code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['public_key'] = publicKey;
    data['secret_key'] = secretKey;
    data['mode'] = mode;
    data['country_code'] = countryCode;
    data['currency_code'] = currencyCode;
    data['status'] = status;
    return data;
  }
}
