class GeneralSettingModel {
  bool? status;
  String? message;
  Data? data;

  GeneralSettingModel({this.status, this.message, this.data});

  GeneralSettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? defaultCurrency;
  String? defaultCurrencyName;
  String? colorCode;
  String? copyrightText;
  String? lightLogoUrl;
  String? darkLogoUrl;
  String? favIconUrl;
  String? email;
  String? androidUrl;
  String? iosUrl;
  String? purchaseCode;
  bool? isPayment;

  Data({
    this.id,
    this.name,
    this.defaultCurrency,
    this.defaultCurrencyName,
    this.colorCode,
    this.copyrightText,
    this.lightLogoUrl,
    this.darkLogoUrl,
    this.favIconUrl,
    this.email,
    this.androidUrl,
    this.iosUrl,
    this.purchaseCode,
    this.isPayment,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    defaultCurrency = json['default_currency'];
    defaultCurrencyName = json['default_currency_name'];
    colorCode = json['color_code'];
    copyrightText = json['copyright_text'];
    lightLogoUrl = json['light_logo_url'];
    darkLogoUrl = json['dark_logo_url'];
    favIconUrl = json['fav_icon_url'];
    email = json['email'];
    androidUrl = json['android_url'];
    iosUrl = json['ios_url'];
    purchaseCode = json['purchase_code'];
    isPayment = json['is_payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['default_currency'] = defaultCurrency;
    data['default_currency_name'] = defaultCurrencyName;
    data['color_code'] = colorCode;
    data['copyright_text'] = copyrightText;
    data['light_logo_url'] = lightLogoUrl;
    data['dark_logo_url'] = darkLogoUrl;
    data['fav_icon_url'] = favIconUrl;
    data['email'] = email;
    data['android_url'] = androidUrl;
    data['ios_url'] = iosUrl;
    data['purchase_code'] = purchaseCode;
    data['is_payment'] = isPayment;
    return data;
  }
}
