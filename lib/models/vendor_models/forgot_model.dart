class ForgotModel {
  bool? status;
  int? userId;
  String? email;
  String? message;

  ForgotModel({this.status, this.userId, this.email, this.message});

  ForgotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
    email = json['email'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_id'] = userId;
    data['email'] = email;
    data['message'] = message;
    return data;
  }
}
