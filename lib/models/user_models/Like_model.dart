// ignore_for_file: prefer_collection_literals, file_names

class LikeModel {
  bool? status;
  String? message;
  Likeddata? likeddata;

  LikeModel({this.status, this.message, this.likeddata});

  LikeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    likeddata = json['Likeddata'] != null
        ? Likeddata.fromJson(json['Likeddata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (likeddata != null) {
      data['Likeddata'] = likeddata!.toJson();
    }
    return data;
  }
}

class Likeddata {
  int? userId;
  int? serviceId;
  String? createdAt;
  String? updatedAt;
  int? id;

  Likeddata(
      {this.userId, this.serviceId, this.createdAt, this.updatedAt, this.id});

  Likeddata.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    serviceId = json['service_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = userId;
    data['service_id'] = serviceId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['id'] = id;
    return data;
  }
}
