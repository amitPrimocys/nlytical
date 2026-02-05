class GetSubscriptionModel {
  bool? status;
  String? message;
  List<Data>? data;

  GetSubscriptionModel({this.status, this.message, this.data});

  GetSubscriptionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? userId;
  String? planName;
  String? price;
  String? startDate;
  String? expireDate;
  String? paymentMode;
  int? status;
  int? isRead;
  int? isColor;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.planName,
    this.price,
    this.startDate,
    this.expireDate,
    this.paymentMode,
    this.status,
    this.isRead,
    this.isColor,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planName = json['plan_name'];
    price = json['price'];
    startDate = json['start_date'];
    expireDate = json['expire_date'];
    paymentMode = json['payment_mode'];
    status = json['status'];
    isRead = json['is_read'];
    isColor = json['is_color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['plan_name'] = planName;
    data['price'] = price;
    data['start_date'] = startDate;
    data['expire_date'] = expireDate;
    data['payment_mode'] = paymentMode;
    data['status'] = status;
    data['is_read'] = isRead;
    data['is_color'] = isColor;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
