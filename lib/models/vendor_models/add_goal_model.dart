class AddGoalsModel {
  bool? status;
  String? message;
  Goal? goal;

  AddGoalsModel({this.status, this.message, this.goal});

  AddGoalsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    goal = json['goal'] != null ? Goal.fromJson(json['goal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (goal != null) {
      data['goal'] = goal!.toJson();
    }
    return data;
  }
}

class Goal {
  String? startDate;
  String? campaignId;
  String? endDate;
  String? days;
  String? price;
  String? updatedAt;
  String? createdAt;
  int? id;

  Goal(
      {this.startDate,
      this.campaignId,
      this.endDate,
      this.days,
      this.price,
      this.updatedAt,
      this.createdAt,
      this.id});

  Goal.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    campaignId = json['campaign_id'];
    endDate = json['end_date'];
    days = json['days'];
    price = json['price'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_date'] = startDate;
    data['campaign_id'] = campaignId;
    data['end_date'] = endDate;
    data['days'] = days;
    data['price'] = price;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
