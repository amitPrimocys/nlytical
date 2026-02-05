// ignore_for_file: prefer_collection_literals

class OnlineModel {
  bool? status;
  String? message;
  String? isOnline;

  OnlineModel({this.status, this.message, this.isOnline});

  OnlineModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['is_online'] = isOnline;
    return data;
  }
}
