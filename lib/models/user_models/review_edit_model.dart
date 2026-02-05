class ReviewEditModel {
  bool? status;
  String? message;
  Reviewdata? reviewdata;

  ReviewEditModel({this.status, this.message, this.reviewdata});

  ReviewEditModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    reviewdata = json['reviewdata'] != null
        ? Reviewdata.fromJson(json['reviewdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (reviewdata != null) {
      data['reviewdata'] = reviewdata!.toJson();
    }
    return data;
  }
}

class Reviewdata {
  int? reviewId;
  int? userId;
  int? serviceId;
  String? reviewStar;
  String? reviewMessage;

  Reviewdata(
      {this.reviewId,
      this.userId,
      this.serviceId,
      this.reviewStar,
      this.reviewMessage});

  Reviewdata.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    reviewStar = json['review_star'];
    reviewMessage = json['review_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review_id'] = reviewId;
    data['user_id'] = userId;
    data['service_id'] = serviceId;
    data['review_star'] = reviewStar;
    data['review_message'] = reviewMessage;
    return data;
  }
}
