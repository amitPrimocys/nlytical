class UpdateProfileModel {
  bool? status;
  String? message;
  Userdetails? userdetails;
  SubscriptionDetails? subscriptionDetails;
  int? isStore;
  String? serviceId;
  int? storeApproval;
  int? campaign;
  int? subscriberUser;

  UpdateProfileModel({
    this.status,
    this.message,
    this.userdetails,
    this.subscriptionDetails,
    this.isStore,
    this.serviceId,
    this.storeApproval,
    this.campaign,
    this.subscriberUser,
  });

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userdetails =
        json['userdetails'] != null
            ? Userdetails.fromJson(json['userdetails'])
            : null;
    subscriptionDetails =
        json['subscriptionDetails'] != null
            ? SubscriptionDetails.fromJson(json['subscriptionDetails'])
            : null;
    isStore = json['is_store'];
    serviceId = json['service_id'];
    storeApproval = json['store_approval'];
    campaign = json['campaign'];
    subscriberUser = json['subscriber_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (userdetails != null) {
      data['userdetails'] = userdetails!.toJson();
    }
    if (subscriptionDetails != null) {
      data['subscriptionDetails'] = subscriptionDetails!.toJson();
    }
    data['is_store'] = isStore;
    data['service_id'] = serviceId;
    data['store_approval'] = storeApproval;
    data['campaign'] = campaign;
    data['subscriber_user'] = subscriberUser;
    return data;
  }
}

class Userdetails {
  int? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? password;
  String? username;
  String? countryCode;
  String? role;
  String? image;
  int? subscribedUser;

  Userdetails({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.password,
    this.username,
    this.countryCode,
    this.role,
    this.image,
    this.subscribedUser,
  });

  Userdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    username = json['username'];
    countryCode = json['country_code'];
    role = json['role'];
    image = json['image'];
    subscribedUser = json['subscribed_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['mobile'] = mobile;
    data['email'] = email;
    data['password'] = password;
    data['username'] = username;
    data['country_code'] = countryCode;
    data['role'] = role;
    data['image'] = image;
    data['subscribed_user'] = subscribedUser;
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
