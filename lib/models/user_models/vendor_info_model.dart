class VendorInfoModel {
  bool? status;
  String? message;
  Vendordetails? vendordetails;
  List<ServiceDetails>? serviceDetails;

  VendorInfoModel(
      {this.status, this.message, this.vendordetails, this.serviceDetails});

  VendorInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    vendordetails = json['Vendordetails'] != null
        ? Vendordetails.fromJson(json['Vendordetails'])
        : null;
    if (json['serviceDetails'] != null) {
      serviceDetails = <ServiceDetails>[];
      json['serviceDetails'].forEach((v) {
        serviceDetails!.add(ServiceDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (vendordetails != null) {
      data['Vendordetails'] = vendordetails!.toJson();
    }
    if (serviceDetails != null) {
      data['serviceDetails'] = serviceDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendordetails {
  int? id;
  String? firstName;
  String? lastName;
  String? address;
  String? lat;
  String? lon;
  String? mobile;
  String? countryCode;
  String? image;
  int? totalReviews;
  String? averageRating;

  Vendordetails(
      {this.id,
      this.firstName,
      this.lastName,
      this.address,
      this.lat,
      this.lon,
      this.mobile,
      this.countryCode,
      this.image,
      this.totalReviews,
      this.averageRating});

  Vendordetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    image = json['image'];
    totalReviews = json['total_reviews'];
    averageRating = json['average_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['image'] = image;
    data['total_reviews'] = totalReviews;
    data['average_rating'] = averageRating;
    return data;
  }
}

class ServiceDetails {
  int? id;
  int? vendorId;
  int? categoryId;
  String? categoryName;
  String? subcategoryId;
  String? serviceName;
  String? address;
  String? lat;
  String? lon;
  int? isFeatured;
  String? publishedMonth;
  String? publishedYear;
  List<String>? serviceImages;
  int? totalReviews;
  String? averageRating;
  String? priceRange;
  String? vendorFirstName;
  String? vendorLastName;
  String? vendorEmail;
  String? vendorImage;
  int? isLike;

  ServiceDetails(
      {this.id,
      this.vendorId,
      this.categoryId,
      this.categoryName,
      this.subcategoryId,
      this.serviceName,
      this.address,
      this.lat,
      this.lon,
      this.isFeatured,
      this.publishedMonth,
      this.publishedYear,
      this.serviceImages,
      this.totalReviews,
      this.averageRating,
      this.priceRange,
      this.vendorFirstName,
      this.vendorLastName,
      this.vendorEmail,
      this.vendorImage,
      this.isLike});

  ServiceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    subcategoryId = json['subcategory_id'];
    serviceName = json['service_name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    isFeatured = json['is_featured'];
    publishedMonth = json['published_month'];
    publishedYear = json['published_year'];
    serviceImages = json['service_images'].cast<String>();
    totalReviews = json['total_reviews'];
    averageRating = json['average_rating'];
    priceRange = json['price_range'];
    vendorFirstName = json['vendor_first_name'];
    vendorLastName = json['vendor_last_name'];
    vendorEmail = json['vendor_email'];
    vendorImage = json['vendor_image'];
    isLike = json['isLike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['subcategory_id'] = subcategoryId;
    data['service_name'] = serviceName;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['is_featured'] = isFeatured;
    data['published_month'] = publishedMonth;
    data['published_year'] = publishedYear;
    data['service_images'] = serviceImages;
    data['total_reviews'] = totalReviews;
    data['average_rating'] = averageRating;
    data['price_range'] = priceRange;
    data['vendor_first_name'] = vendorFirstName;
    data['vendor_last_name'] = vendorLastName;
    data['vendor_email'] = vendorEmail;
    data['vendor_image'] = vendorImage;
    data['isLike'] = isLike;
    return data;
  }
}
