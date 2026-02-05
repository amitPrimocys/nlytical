class SocialLoginModel {
  bool? status;
  String? message;
  User? user;
  String? usernameExists;

  SocialLoginModel({this.status, this.message, this.user, this.usernameExists});

  SocialLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    usernameExists = json['username_exists'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['username_exists'] = usernameExists;
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? loginType;
  String? role;
  String? firstName;
  String? lastName;
  String? username;
  int? userBlock;
  String? serviceId;
  int? isStore;
  int? isSubscriber;
  String? mobile;
  String? countryCode;
  String? countryFlag;
  String? verifyOtp;
  String? mobileVerifyOtp;
  String? token;

  User({
    this.id,
    this.email,
    this.loginType,
    this.role,
    this.firstName,
    this.lastName,
    this.username,
    this.userBlock,
    this.serviceId,
    this.isStore,
    this.isSubscriber,
    this.mobile,
    this.countryCode,
    this.countryFlag,
    this.verifyOtp,
    this.mobileVerifyOtp,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    loginType = json['login_type'];
    role = json['role'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    userBlock = json['user_block'];
    serviceId = json['service_id'];
    isStore = json['is_store'];
    isSubscriber = json['is_subscriber'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    countryFlag = json['country_flag'];
    verifyOtp = json['verify_otp'];
    mobileVerifyOtp = json['mobile_verify_otp'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['login_type'] = loginType;
    data['role'] = role;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['user_block'] = userBlock;
    data['service_id'] = serviceId;
    data['is_store'] = isStore;
    data['is_subscriber'] = isSubscriber;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['country_flag'] = countryFlag;
    data['verify_otp'] = verifyOtp;
    data['mobile_verify_otp'] = mobileVerifyOtp;
    data['token'] = token;
    return data;
  }
}
