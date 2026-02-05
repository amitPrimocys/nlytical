class UpdateStoreModel {
  bool? status;
  String? message;
  int? serviceId;

  UpdateStoreModel({this.status, this.message, this.serviceId});

  UpdateStoreModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    serviceId = json["service_id"];
  }

  static List<UpdateStoreModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UpdateStoreModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    data["service_id"] = serviceId;
    return data;
  }
}
