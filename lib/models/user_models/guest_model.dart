// ignore_for_file: prefer_collection_literals

class GuestModel {
  bool? status;
  String? message;
  User? user;

  GuestModel({this.status, this.message, this.user});

  GuestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? ipAddress;
  String? role;
  int? guestUser;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? profilePhotoUrl;

  User(
      {this.ipAddress,
      this.role,
      this.guestUser,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.profilePhotoUrl});

  User.fromJson(Map<String, dynamic> json) {
    ipAddress = json['ip_address'];
    role = json['role'];
    guestUser = json['guest_user'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ip_address'] = ipAddress;
    data['role'] = role;
    data['guest_user'] = guestUser;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['profile_photo_url'] = profilePhotoUrl;
    return data;
  }
}
