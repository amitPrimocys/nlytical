class AllLoginStatusModel {
  String? responseCode;
  String? message;
  String? status;
  String? apple;
  String? google;
  String? email;
  String? mobileotp;

  AllLoginStatusModel({
    this.responseCode,
    this.message,
    this.status,
    this.apple,
    this.google,
    this.email,
    this.mobileotp,
  });

  AllLoginStatusModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    status = json['status'];
    apple = json['apple'];
    google = json['google'];
    email = json['email'];
    mobileotp = json['mobileotp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    data['status'] = status;
    data['apple'] = apple;
    data['google'] = google;
    data['email'] = email;
    data['mobileotp'] = mobileotp;
    return data;
  }
}
