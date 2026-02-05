class BlockModel {
  String? message;
  int? response;
  bool? status;

  BlockModel({this.message, this.response, this.status});

  BlockModel.fromJson(Map<String, dynamic> json) {
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
