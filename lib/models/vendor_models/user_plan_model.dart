class UserPlanModel {
  bool? status;
  String? message;
  Subscription? subscription;

  UserPlanModel({this.status, this.message, this.subscription});

  UserPlanModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    subscription = json["subscription"] == null
        ? null
        : Subscription.fromJson(json["subscription"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (subscription != null) {
      data["subscription"] = subscription?.toJson();
    }
    return data;
  }
}

class Subscription {
  int? id;
  int? userId;
  String? planName;
  String? price;
  String? startDate;
  String? expireDate;
  String? paymentMode;
  int? status;
  String? createdAt;
  String? updatedAt;

  Subscription(
      {this.id,
      this.userId,
      this.planName,
      this.price,
      this.startDate,
      this.expireDate,
      this.paymentMode,
      this.status,
      this.createdAt,
      this.updatedAt});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["user_id"];
    planName = json["plan_name"];
    price = json["price"];
    startDate = json["start_date"];
    expireDate = json["expire_date"];
    paymentMode = json["payment_mode"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["user_id"] = userId;
    data["plan_name"] = planName;
    data["price"] = price;
    data["start_date"] = startDate;
    data["expire_date"] = expireDate;
    data["payment_mode"] = paymentMode;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
