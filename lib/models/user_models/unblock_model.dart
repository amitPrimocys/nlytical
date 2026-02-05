class UnBlockModel {
  String? message;
  int? response;
  bool? status;

  UnBlockModel({this.message, this.response, this.status});

  UnBlockModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    response = json['response'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['response'] = response;
    data['status'] = status;
    return data;
  }
}
