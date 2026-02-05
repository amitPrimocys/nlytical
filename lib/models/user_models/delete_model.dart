// ignore_for_file: prefer_collection_literals

class DeleteModel {
  bool? status;
  String? message;

  DeleteModel({this.status, this.message});

  DeleteModel.fromJson(Map<String, dynamic> json) {
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
