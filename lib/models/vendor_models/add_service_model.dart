class AddServiceModel {
  bool? status;
  String? message;
  int? serviceId;

  AddServiceModel({this.status, this.message, this.serviceId});

  AddServiceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    serviceId = json['service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['service_id'] = serviceId;
    return data;
  }
}
