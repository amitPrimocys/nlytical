class PaymentHistoryModel {
  bool? status;
  String? message;
  List<GoalData>? goalData;

  PaymentHistoryModel({this.status, this.message, this.goalData});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['GoalData'] != null) {
      goalData = <GoalData>[];
      json['GoalData'].forEach((v) {
        goalData!.add(GoalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (goalData != null) {
      data['GoalData'] = goalData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoalData {
  int? id;
  int? campaignId;
  String? startDate;
  String? endDate;
  String? days;
  String? price;
  int? status;
  String? createdAt;
  String? updatedAt;

  GoalData(
      {this.id,
      this.campaignId,
      this.startDate,
      this.endDate,
      this.days,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt});

  GoalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    campaignId = json['campaign_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    days = json['days'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['campaign_id'] = campaignId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['days'] = days;
    data['price'] = price;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
