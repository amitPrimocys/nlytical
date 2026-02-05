class LoginModel {
  bool? status;
  String? token;
  int? userId;
  String? email;
  String? firstName;
  String? lastName;
  String? username;
  String? mobile;
  String? countryCode;
  String? image;
  int? subscribedUser;
  String? serviceId;
  int? isStore;
  int? storeApproval;
  String? loginType;
  String? role;
  int? userBlock;
  String? countryFlag;
  String? verifyOtp;
  String? mobileVerifyOtp;
  String? message;

  LoginModel({
    this.status,
    this.token,
    this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.mobile,
    this.countryCode,
    this.image,
    this.subscribedUser,
    this.serviceId,
    this.isStore,
    this.storeApproval,
    this.loginType,
    this.role,
    this.userBlock,
    this.countryFlag,
    this.verifyOtp,
    this.mobileVerifyOtp,
    this.message,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    userId = json['user_id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    image = json['image'];
    subscribedUser = json['subscribed_user'];
    serviceId = json['service_id'];
    isStore = json['is_store'];
    storeApproval = json['store_approval'];
    loginType = json['login_type'];
    role = json['role'];
    userBlock = json['user_block'];
    countryFlag = json['country_flag'];
    verifyOtp = json['verify_otp'];
    mobileVerifyOtp = json['mobile_verify_otp'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    data['user_id'] = userId;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['image'] = image;
    data['subscribed_user'] = subscribedUser;
    data['service_id'] = serviceId;
    data['is_store'] = isStore;
    data['store_approval'] = storeApproval;
    data['login_type'] = loginType;
    data['role'] = role;
    data['user_block'] = userBlock;
    data['country_flag'] = countryFlag;
    data['verify_otp'] = verifyOtp;
    data['mobile_verify_otp'] = mobileVerifyOtp;
    data['message'] = message;
    return data;
  }
}
