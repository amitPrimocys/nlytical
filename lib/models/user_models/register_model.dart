// ignore_for_file: prefer_collection_literals

class RegisterModel {
  bool? status;
  int? userId;
  String? email;
  String? message;
  int? userBlock;

  RegisterModel({
    this.status,
    this.userId,
    this.email,
    this.message,
    this.userBlock,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
    email = json['email'];
    message = json['message'];
    userBlock = json['user_block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['user_id'] = userId;
    data['email'] = email;
    data['message'] = message;
    data['user_block'] = userBlock;
    return data;
  }
}
