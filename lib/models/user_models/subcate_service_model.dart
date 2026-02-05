class SubcatServiceModel {
  bool? status;
  String? message;
  int? subcategoryId;
  String? subcategoryName;
  List<FeaturedServices>? featuredServices;
  List<AllServices>? allServices;

  SubcatServiceModel({
    this.status,
    this.message,
    this.subcategoryId,
    this.subcategoryName,
    this.featuredServices,
    this.allServices,
  });

  SubcatServiceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    subcategoryId = json['subcategory_id'];
    subcategoryName = json['subcategory_name'];
    if (json['featured_services'] != null) {
      featuredServices = <FeaturedServices>[];
      json['featured_services'].forEach((v) {
        featuredServices!.add(FeaturedServices.fromJson(v));
      });
    }
    if (json['all_services'] != null) {
      allServices = <AllServices>[];
      json['all_services'].forEach((v) {
        allServices!.add(AllServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['subcategory_id'] = subcategoryId;
    data['subcategory_name'] = subcategoryName;
    if (featuredServices != null) {
      data['featured_services'] =
          featuredServices!.map((v) => v.toJson()).toList();
    }
    if (allServices != null) {
      data['all_services'] = allServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeaturedServices {
  int? id;
  int? categoryId;
  String? subcategoryId;
  String? serviceName;
  int? isFeatured;
  int? vendorId;
  String? address;
  String? lat;
  String? lon;
  String? closeTime;
  String? servicePhone;
  String? categoryName;
  String? subcategoryName;
  String? publishedMonth;
  String? publishedYear;
  int? totalReviewCount;
  String? totalAvgReview;
  String? serviceImages;
  int? isLike;
  int? totalYearsCount;
  String? priceRange;
  String? vendorFirstName;
  String? vendorLastName;
  String? vendorEmail;
  String? vendorImage;

  FeaturedServices({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.serviceName,
    this.isFeatured,
    this.vendorId,
    this.address,
    this.lat,
    this.lon,
    this.closeTime,
    this.servicePhone,
    this.categoryName,
    this.subcategoryName,
    this.publishedMonth,
    this.publishedYear,
    this.totalReviewCount,
    this.totalAvgReview,
    this.serviceImages,
    this.isLike,
    this.totalYearsCount,
    this.priceRange,
    this.vendorFirstName,
    this.vendorLastName,
    this.vendorEmail,
    this.vendorImage,
  });

  FeaturedServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    serviceName = json['service_name'];
    isFeatured = json['is_featured'];
    vendorId = json['vendor_id'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    closeTime = json['close_time'];
    servicePhone = json['service_phone'];
    categoryName = json['category_name'];
    subcategoryName = json['subcategory_name'];
    publishedMonth = json['published_month'];
    publishedYear = json['published_year'];
    totalReviewCount = json['totalReviewCount'];
    totalAvgReview = json['totalAvgReview'];
    serviceImages = json['service_images'];
    isLike = json['isLike'];
    totalYearsCount = json['total_years_count'];
    priceRange = json['price_range'];
    vendorFirstName = json['vendor_first_name'];
    vendorLastName = json['vendor_last_name'];
    vendorEmail = json['vendor_email'];
    vendorImage = json['vendor_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['service_name'] = serviceName;
    data['is_featured'] = isFeatured;
    data['vendor_id'] = vendorId;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['close_time'] = closeTime;
    data['service_phone'] = servicePhone;
    data['category_name'] = categoryName;
    data['subcategory_name'] = subcategoryName;
    data['published_month'] = publishedMonth;
    data['published_year'] = publishedYear;
    data['totalReviewCount'] = totalReviewCount;
    data['totalAvgReview'] = totalAvgReview;
    data['service_images'] = serviceImages;
    data['isLike'] = isLike;
    data['total_years_count'] = totalYearsCount;
    data['price_range'] = priceRange;
    data['vendor_first_name'] = vendorFirstName;
    data['vendor_last_name'] = vendorLastName;
    data['vendor_email'] = vendorEmail;
    data['vendor_image'] = vendorImage;
    return data;
  }
}

class AllServices {
  int? id;
  int? categoryId;
  String? subcategoryId;
  String? serviceName;
  String? address;
  String? lat;
  String? lon;
  int? vendorId;
  int? isFeatured;
  String? categoryName;
  String? subcategoryName;
  int? totalReviewCount;
  String? totalAvgReview;
  String? serviceImages;
  int? isLike;
  int? totalYearsCount;
  String? priceRange;
  String? vendorFirstName;
  String? vendorLastName;
  String? vendorEmail;
  String? vendorImage;

  AllServices({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.serviceName,
    this.address,
    this.lat,
    this.lon,
    this.vendorId,
    this.isFeatured,
    this.categoryName,
    this.subcategoryName,
    this.totalReviewCount,
    this.totalAvgReview,
    this.serviceImages,
    this.isLike,
    this.totalYearsCount,
    this.priceRange,
    this.vendorFirstName,
    this.vendorLastName,
    this.vendorEmail,
    this.vendorImage,
  });

  AllServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    serviceName = json['service_name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    vendorId = json['vendor_id'];
    isFeatured = json['is_featured'];
    categoryName = json['category_name'];
    subcategoryName = json['subcategory_name'];
    totalReviewCount = json['totalReviewCount'];
    totalAvgReview = json['totalAvgReview'];
    serviceImages = json['service_images'];
    isLike = json['isLike'];
    totalYearsCount = json['total_years_count'];
    priceRange = json['price_range'];
    vendorFirstName = json['vendor_first_name'];
    vendorLastName = json['vendor_last_name'];
    vendorEmail = json['vendor_email'];
    vendorImage = json['vendor_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['service_name'] = serviceName;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['vendor_id'] = vendorId;
    data['is_featured'] = isFeatured;
    data['category_name'] = categoryName;
    data['subcategory_name'] = subcategoryName;
    data['totalReviewCount'] = totalReviewCount;
    data['totalAvgReview'] = totalAvgReview;
    data['service_images'] = serviceImages;
    data['isLike'] = isLike;
    data['total_years_count'] = totalYearsCount;
    data['price_range'] = priceRange;
    data['vendor_first_name'] = vendorFirstName;
    data['vendor_last_name'] = vendorLastName;
    data['vendor_email'] = vendorEmail;
    data['vendor_image'] = vendorImage;
    return data;
  }
}
