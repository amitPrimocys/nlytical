class LocationListApiModel {
  bool? status;
  String? message;
  List<String>? countriesList;

  LocationListApiModel({this.status, this.message, this.countriesList});

  LocationListApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    countriesList = json['countriesList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['countriesList'] = countriesList;
    return data;
  }
}
