class FavouriteModel {
  bool? status;
  String? message;
  List<ServiceLikedList>? serviceLikedList;

  FavouriteModel({this.status, this.message, this.serviceLikedList});

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['ServiceLikedList'] != null) {
      serviceLikedList = <ServiceLikedList>[];
      json['ServiceLikedList'].forEach((v) {
        serviceLikedList!.add(ServiceLikedList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (serviceLikedList != null) {
      data['ServiceLikedList'] =
          serviceLikedList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceLikedList {
  int? id;
  int? categoryId;
  String? serviceName;
  int? vendorId;
  String? address;
  String? lat;
  String? lon;
  int? isFeatured;
  String? publishedYear;
  String? categoryName;
  int? totalReviewCount;
  String? totalAvgReview;
  String? serviceImages;
  String? vendorFirstName;
  String? vendorLastName;
  String? vendorEmail;
  String? vendorImage;
  int? isLike;
  int? totalYearsCount;
  String? priceRange;

  ServiceLikedList(
      {this.id,
      this.categoryId,
      this.serviceName,
      this.vendorId,
      this.address,
      this.lat,
      this.lon,
      this.isFeatured,
      this.publishedYear,
      this.categoryName,
      this.totalReviewCount,
      this.totalAvgReview,
      this.serviceImages,
      this.vendorFirstName,
      this.vendorLastName,
      this.vendorEmail,
      this.vendorImage,
      this.isLike,
      this.totalYearsCount,
      this.priceRange});

  ServiceLikedList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    serviceName = json['service_name'];
    vendorId = json['vendor_id'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    isFeatured = json['is_featured'];
    publishedYear = json['published_year'];
    categoryName = json['category_name'];
    totalReviewCount = json['totalReviewCount'];
    totalAvgReview = json['totalAvgReview'];
    serviceImages = json['service_images'];
    vendorFirstName = json['vendor_first_name'];
    vendorLastName = json['vendor_last_name'];
    vendorEmail = json['vendor_email'];
    vendorImage = json['vendor_image'];
    isLike = json['isLike'];
    totalYearsCount = json['total_years_count'];
    priceRange = json['price_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['service_name'] = serviceName;
    data['vendor_id'] = vendorId;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['is_featured'] = isFeatured;
    data['published_year'] = publishedYear;
    data['category_name'] = categoryName;
    data['totalReviewCount'] = totalReviewCount;
    data['totalAvgReview'] = totalAvgReview;
    data['service_images'] = serviceImages;
    data['vendor_first_name'] = vendorFirstName;
    data['vendor_last_name'] = vendorLastName;
    data['vendor_email'] = vendorEmail;
    data['vendor_image'] = vendorImage;
    data['isLike'] = isLike;
    data['total_years_count'] = totalYearsCount;
    data['price_range'] = priceRange;
    return data;
  }
}
