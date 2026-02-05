// ignore_for_file: prefer_collection_literals

class ResetModel {
  bool? status;
  String? message;

  ResetModel({this.status, this.message});

  ResetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
