class UserNameCheckModel {
  bool? status;
  String? message;
  String? username;

  UserNameCheckModel({this.status, this.message, this.username});

  UserNameCheckModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['username'] = username;
    return data;
  }
}
