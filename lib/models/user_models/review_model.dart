// ignore_for_file: unnecessary_this, prefer_collection_literals

class ReviewModel {
  bool? status;
  String? message;
  List<Reviewlist>? reviewlist;

  ReviewModel({this.status, this.message, this.reviewlist});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['reviewlist'] != null) {
      reviewlist = <Reviewlist>[];
      json['reviewlist'].forEach((v) {
        reviewlist!.add(Reviewlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.reviewlist != null) {
      data['reviewlist'] = this.reviewlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviewlist {
  int? id;
  int? userId;
  int? serviceId;
  String? reviewStar;
  String? reviewMessage;
  String? createdAt;
  String? serviceName;
  String? categoryName;
  List<String>? serviceImages;

  Reviewlist(
      {this.id,
      this.userId,
      this.serviceId,
      this.reviewStar,
      this.reviewMessage,
      this.createdAt,
      this.serviceName,
      this.categoryName,
      this.serviceImages});

  Reviewlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    reviewStar = json['review_star'];
    reviewMessage = json['review_message'];
    createdAt = json['created_at'];
    serviceName = json['service_name'];
    categoryName = json['category_name'];
    serviceImages = json['service_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['service_id'] = this.serviceId;
    data['review_star'] = this.reviewStar;
    data['review_message'] = this.reviewMessage;
    data['created_at'] = this.createdAt;
    data['service_name'] = this.serviceName;
    data['category_name'] = this.categoryName;
    data['service_images'] = this.serviceImages;
    return data;
  }
}
