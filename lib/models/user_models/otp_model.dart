class OtpModel {
  bool? status;
  int? userId;
  String? firstName;
  String? mobile;
  String? email;
  String? role;
  String? token;
  String? message;
  int? userSubscription;
  String? serviceId;
  String? loginType;
  String? countryFlag;
  String? verifyOtp;
  String? mobileVerifyOtp;

  OtpModel({
    this.status,
    this.userId,
    this.firstName,
    this.mobile,
    this.email,
    this.role,
    this.token,
    this.message,
    this.userSubscription,
    this.serviceId,
    this.loginType,
    this.countryFlag,
    this.verifyOtp,
    this.mobileVerifyOtp,
  });

  OtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
    firstName = json['first_name'];
    mobile = json['mobile'];
    email = json['email'];
    role = json['role'];
    token = json['token'];
    message = json['message'];
    userSubscription = json['user_subscription'];
    serviceId = json['service_id'];
    loginType = json['login_type'];
    countryFlag = json['country_flag'];
    verifyOtp = json['verify_otp'];
    mobileVerifyOtp = json['mobile_verify_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['mobile'] = mobile;
    data['email'] = email;
    data['role'] = role;
    data['token'] = token;
    data['message'] = message;
    data['user_subscription'] = userSubscription;
    data['service_id'] = serviceId;
    data['login_type'] = loginType;
    data['country_flag'] = countryFlag;
    data['verify_otp'] = verifyOtp;
    data['mobile_verify_otp'] = mobileVerifyOtp;
    return data;
  }
}
