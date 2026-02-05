class BusinessReviewModel {
  bool? status;
  String? message;
  ServiceDetails? serviceDetails;
  List<UserReviews>? userReviews;

  BusinessReviewModel(
      {this.status, this.message, this.serviceDetails, this.userReviews});

  BusinessReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    serviceDetails = json['service_details'] != null
        ? ServiceDetails.fromJson(json['service_details'])
        : null;
    if (json['userReviews'] != null) {
      userReviews = <UserReviews>[];
      json['userReviews'].forEach((v) {
        userReviews!.add(UserReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (serviceDetails != null) {
      data['service_details'] = serviceDetails!.toJson();
    }
    if (userReviews != null) {
      data['userReviews'] = userReviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceDetails {
  String? serviceName;
  String? serviceDescription;
  List<String>? serviceImages;
  String? totalAvgReview;
  int? totalReviewCount;

  ServiceDetails(
      {this.serviceName,
      this.serviceDescription,
      this.serviceImages,
      this.totalAvgReview,
      this.totalReviewCount});

  ServiceDetails.fromJson(Map<String, dynamic> json) {
    serviceName = json['service_name'];
    serviceDescription = json['service_description'];
    serviceImages = json['service_images'].cast<String>();
    totalAvgReview = json['totalAvgReview'];
    totalReviewCount = json['totalReviewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_name'] = serviceName;
    data['service_description'] = serviceDescription;
    data['service_images'] = serviceImages;
    data['totalAvgReview'] = totalAvgReview;
    data['totalReviewCount'] = totalReviewCount;
    return data;
  }
}

class UserReviews {
  int? id;
  int? serviceId;
  int? userId;
  String? reviewStar;
  String? reviewMessage;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? image;

  UserReviews(
      {this.id,
      this.serviceId,
      this.userId,
      this.reviewStar,
      this.reviewMessage,
      this.createdAt,
      this.firstName,
      this.lastName,
      this.image});

  UserReviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    userId = json['user_id'];
    reviewStar = json['review_star'];
    reviewMessage = json['review_message'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_id'] = serviceId;
    data['user_id'] = userId;
    data['review_star'] = reviewStar;
    data['review_message'] = reviewMessage;
    data['created_at'] = createdAt;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
    return data;
  }
}
