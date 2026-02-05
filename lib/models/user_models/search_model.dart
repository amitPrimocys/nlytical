class SearchModel {
  bool? status;
  String? message;
  List<ServiceSearch>? serviceSearch;

  SearchModel({this.status, this.message, this.serviceSearch});

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['serviceSearch'] != null) {
      serviceSearch = <ServiceSearch>[];
      json['serviceSearch'].forEach((v) {
        serviceSearch!.add(ServiceSearch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (serviceSearch != null) {
      data['serviceSearch'] = serviceSearch!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceSearch {
  int? id;
  String? serviceName;
  String? categoryName;
  String? address;
  String? lat;
  String? lon;
  int? vendorId;
  int? isFeatured;
  String? vendorFirstName;
  String? vendorLastName;
  String? vendorEmail;
  String? vendorImage;
  int? totalYearsCount;
  List<String>? serviceImages;
  int? isLike;
  int? totalReviewCount;
  String? totalAvgReview;
  String? priceRange;

  ServiceSearch(
      {this.id,
      this.serviceName,
      this.categoryName,
      this.address,
      this.lat,
      this.lon,
      this.vendorId,
      this.isFeatured,
      this.vendorFirstName,
      this.vendorLastName,
      this.vendorEmail,
      this.vendorImage,
      this.totalYearsCount,
      this.serviceImages,
      this.isLike,
      this.totalReviewCount,
      this.totalAvgReview,
      this.priceRange});

  ServiceSearch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    categoryName = json['category_name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    vendorId = json['vendor_id'];
    isFeatured = json['is_featured'];
    vendorFirstName = json['vendor_first_name'];
    vendorLastName = json['vendor_last_name'];
    vendorEmail = json['vendor_email'];
    vendorImage = json['vendor_image'];
    totalYearsCount = json['total_years_count'];
    serviceImages = json['service_images'].cast<String>();
    isLike = json['isLike'];
    totalReviewCount = json['totalReviewCount'];
    totalAvgReview = json['totalAvgReview'];
    priceRange = json['price_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['category_name'] = categoryName;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['vendor_id'] = vendorId;
    data['is_featured'] = isFeatured;
    data['vendor_first_name'] = vendorFirstName;
    data['vendor_last_name'] = vendorLastName;
    data['vendor_email'] = vendorEmail;
    data['vendor_image'] = vendorImage;
    data['total_years_count'] = totalYearsCount;
    data['service_images'] = serviceImages;
    data['isLike'] = isLike;
    data['totalReviewCount'] = totalReviewCount;
    data['totalAvgReview'] = totalAvgReview;
    data['price_range'] = priceRange;
    return data;
  }
}
