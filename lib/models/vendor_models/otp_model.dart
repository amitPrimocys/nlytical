class OtpModel {
  bool? status;
  int? userId;
  String? firstName;
  String? email;
  String? role;
  String? token;
  String? message;

  OtpModel(
      {this.status,
      this.userId,
      this.firstName,
      this.email,
      this.role,
      this.token,
      this.message});

  OtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
    firstName = json['first_name'];
    email = json['email'];
    role = json['role'];
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['email'] = email;
    data['role'] = role;
    data['token'] = token;
    data['message'] = message;
    return data;
  }
}
