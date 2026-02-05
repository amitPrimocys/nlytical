class GetProfileModel {
  bool? status;
  String? message;
  int? guestUser;
  UserDetails? userDetails;
  int? subscribedUser;
  SubscriptionDetails? subscriptionDetails;

  GetProfileModel(
      {this.status,
      this.message,
      this.guestUser,
      this.userDetails,
      this.subscribedUser,
      this.subscriptionDetails});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    guestUser = json['guest_user'];
    userDetails = json['UserDetails'] != null
        ? UserDetails.fromJson(json['UserDetails'])
        : null;
    subscribedUser = json['subscribed_user'];
    subscriptionDetails = json['subscriptionDetails'] != null
        ? SubscriptionDetails.fromJson(json['subscriptionDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['guest_user'] = guestUser;
    if (userDetails != null) {
      data['UserDetails'] = userDetails!.toJson();
    }
    data['subscribed_user'] = subscribedUser;
    if (subscriptionDetails != null) {
      data['subscriptionDetails'] = subscriptionDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? countryCode;
  String? image;

  UserDetails(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.countryCode,
      this.image});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['image'] = image;
    return data;
  }
}

class SubscriptionDetails {
  int? userId;
  String? planName;
  String? price;
  String? expireDate;
  String? planImage;

  SubscriptionDetails(
      {this.userId,
      this.planName,
      this.price,
      this.expireDate,
      this.planImage});

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
