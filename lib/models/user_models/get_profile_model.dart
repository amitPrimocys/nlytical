class GetProfileModel {
  bool? status;
  String? message;
  UserDetails? userDetails;
  int? subscribedUser;
  SubscriptionDetails? subscriptionDetails;
  int? isStore;
  String? isDemo;

  GetProfileModel({
    this.status,
    this.message,
    this.userDetails,
    this.subscribedUser,
    this.subscriptionDetails,
    this.isStore,
    this.isDemo,
  });

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userDetails = json['UserDetails'] != null
        ? UserDetails.fromJson(json['UserDetails'])
        : null;
    subscribedUser = json['subscribed_user'];
    subscriptionDetails = json['subscriptionDetails'] != null
        ? SubscriptionDetails.fromJson(json['subscriptionDetails'])
        : null;
    isStore = json['is_store'];
    isDemo = json['is_demo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (userDetails != null) {
      data['UserDetails'] = userDetails!.toJson();
    }
    data['subscribed_user'] = subscribedUser;
    if (subscriptionDetails != null) {
      data['subscriptionDetails'] = subscriptionDetails!.toJson();
    }
    data['is_store'] = isStore;
    data['is_demo'] = isDemo;
    return data;
  }
}

class UserDetails {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? mobile;
  String? countryCode;
  String? image;
  String? imageStatus;
  String? loginType;
  String? countryFlag;
  String? verifyOtp;
  String? mobileVerifyOtp;
  String? role;

  UserDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.mobile,
    this.countryCode,
    this.image,
    this.imageStatus,
    this.loginType,
    this.countryFlag,
    this.verifyOtp,
    this.mobileVerifyOtp,
    this.role,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    image = json['image'];
    imageStatus = json['image_status'];
    loginType = json['login_type'];
    countryFlag = json['country_flag'];
    verifyOtp = json['verify_otp'];
    mobileVerifyOtp = json['mobile_verify_otp'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['email'] = email;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['image'] = image;
    data['image_status'] = imageStatus;
    data['login_type'] = loginType;
    data['country_flag'] = countryFlag;
    data['verify_otp'] = verifyOtp;
    data['mobile_verify_otp'] = mobileVerifyOtp;
    data['role'] = role;
    return data;
  }
}

class SubscriptionDetails {
  int? userId;
  String? planName;
  String? price;
  String? expireDate;
  String? planImage;

  SubscriptionDetails({
    this.userId,
    this.planName,
    this.price,
    this.expireDate,
    this.planImage,
  });

  SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    planName = json['plan_name'];
    price = json['price'];
    expireDate = json['expire_date'];
    planImage = json['plan_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['plan_name'] = planName;
    data['price'] = price;
    data['expire_date'] = expireDate;
    data['plan_image'] = planImage;
    return data;
  }
}
