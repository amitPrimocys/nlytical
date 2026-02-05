class ServiceDetailModel {
  bool? status;
  String? message;
  int? vendor;
  VendorDetails? vendorDetails;
  ServiceDetail? serviceDetail;
  List<Stores>? stores;

  ServiceDetailModel({
    this.status,
    this.message,
    this.vendor,
    this.vendorDetails,
    this.serviceDetail,
    this.stores,
  });

  ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    vendor = json['vendor'];
    vendorDetails =
        json['vendorDetails'] != null
            ? VendorDetails.fromJson(json['vendorDetails'])
            : null;
    serviceDetail =
        json['serviceDetail'] != null
            ? ServiceDetail.fromJson(json['serviceDetail'])
            : null;
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['vendor'] = vendor;
    if (vendorDetails != null) {
      data['vendorDetails'] = vendorDetails!.toJson();
    }
    if (serviceDetail != null) {
      data['serviceDetail'] = serviceDetail!.toJson();
    }
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorDetails {
  int? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? vendorEmail;
  String? image;
  String? lastSeen;
  int? isBlock;
  String? employeeStrength;

  VendorDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.vendorEmail,
    this.image,
    this.lastSeen,
    this.isBlock,
    this.employeeStrength,
  });

  VendorDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    vendorEmail = json['vendor_email'];
    image = json['image'];
    lastSeen = json['last_seen'];
    isBlock = json['is_block'];
    employeeStrength = json['employee_strength'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['mobile'] = mobile;
    data['vendor_email'] = vendorEmail;
    data['image'] = image;
    data['last_seen'] = lastSeen;
    data['is_block'] = isBlock;
    data['employee_strength'] = employeeStrength;
    return data;
  }
}

class ServiceDetail {
  int? id;
  int? vendorId;
  int? categoryId;
  String? serviceName;
  String? serviceDescription;
  String? serviceWebsite;
  String? servicePhone;
  String? address;
  String? lat;
  String? lon;
  List<String>? openDays;
  List<String>? closedDays;
  String? openTime;
  String? closeTime;
  String? videoThumbnail;
  String? video;
  String? videoUrl;
  String? instagramLink;
  String? facebookLink;
  String? whatsappLink;
  String? twitterLink;
  String? subcategoryId;
  String? serviceEmail;
  String? coverImage;
  String? employeeStrength;
  String? publishedMonth;
  String? publishedYear;
  String? metaTitle;
  String? metaDescription;
  int? isFeatured;
  String? priceRange;
  int? totalStoresCount;
  int? totalYearsCount;
  String? distance;
  String? categoryName;
  List<String>? subcategoryNames;
  String? vendorEmail;
  List<String>? serviceImages;
  int? isLike;
  int? totalReviewCount;
  String? totalAvgReview;
  List<Reviews>? reviews;

  ServiceDetail({
    this.id,
    this.vendorId,
    this.categoryId,
    this.serviceName,
    this.serviceDescription,
    this.serviceWebsite,
    this.servicePhone,
    this.address,
    this.lat,
    this.lon,
    this.openDays,
    this.closedDays,
    this.openTime,
    this.closeTime,
    this.videoThumbnail,
    this.video,
    this.videoUrl,
    this.instagramLink,
    this.facebookLink,
    this.whatsappLink,
    this.twitterLink,
    this.subcategoryId,
    this.serviceEmail,
    this.coverImage,
    this.employeeStrength,
    this.publishedMonth,
    this.publishedYear,
    this.metaTitle,
    this.metaDescription,
    this.isFeatured,
    this.priceRange,
    this.totalStoresCount,
    this.totalYearsCount,
    this.distance,
    this.categoryName,
    this.subcategoryNames,
    this.vendorEmail,
    this.serviceImages,
    this.isLike,
    this.totalReviewCount,
    this.totalAvgReview,
    this.reviews,
  });

  ServiceDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    categoryId = json['category_id'];
    serviceName = json['service_name'];
    serviceDescription = json['service_description'];
    serviceWebsite = json['service_website'];
    servicePhone = json['service_phone'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    openDays = json['open_days'].cast<String>();
    closedDays = json['closed_days'].cast<String>();
    openTime = json['open_time'];
    closeTime = json['close_time'];
    videoThumbnail = json['video_thumbnail'];
    video = json['video'];
    videoUrl = json['video_url'];
    instagramLink = json['instagram_link'];
    facebookLink = json['facebook_link'];
    whatsappLink = json['whatsapp_link'];
    twitterLink = json['twitter_link'];
    subcategoryId = json['subcategory_id'];
    serviceEmail = json['service_email'];
    coverImage = json['cover_image'];
    employeeStrength = json['employee_strength'];
    publishedMonth = json['published_month'];
    publishedYear = json['published_year'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    isFeatured = json['is_featured'];
    priceRange = json['price_range'];
    totalStoresCount = json['total_stores_count'];
    totalYearsCount = json['total_years_count'];
    distance = json['distance'];
    categoryName = json['category_name'];
    subcategoryNames = json['subcategory_names'].cast<String>();
    vendorEmail = json['vendor_email'];
    serviceImages = json['service_images'].cast<String>();
    isLike = json['isLike'];
    totalReviewCount = json['totalReviewCount'];
    totalAvgReview = json['totalAvgReview'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['category_id'] = categoryId;
    data['service_name'] = serviceName;
    data['service_description'] = serviceDescription;
    data['service_website'] = serviceWebsite;
    data['service_phone'] = servicePhone;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['open_days'] = openDays;
    data['closed_days'] = closedDays;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['video_thumbnail'] = videoThumbnail;
    data['video'] = video;
    data['video_url'] = videoUrl;
    data['instagram_link'] = instagramLink;
    data['facebook_link'] = facebookLink;
    data['whatsapp_link'] = whatsappLink;
    data['twitter_link'] = twitterLink;
    data['subcategory_id'] = subcategoryId;
    data['service_email'] = serviceEmail;
    data['cover_image'] = coverImage;
    data['employee_strength'] = employeeStrength;
    data['published_month'] = publishedMonth;
    data['published_year'] = publishedYear;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['is_featured'] = isFeatured;
    data['price_range'] = priceRange;
    data['total_stores_count'] = totalStoresCount;
    data['total_years_count'] = totalYearsCount;
    data['distance'] = distance;
    data['category_name'] = categoryName;
    data['subcategory_names'] = subcategoryNames;
    data['vendor_email'] = vendorEmail;
    data['service_images'] = serviceImages;
    data['isLike'] = isLike;
    data['totalReviewCount'] = totalReviewCount;
    data['totalAvgReview'] = totalAvgReview;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  int? id;
  int? serviceId;
  int? userId;
  String? reviewStar;
  String? reviewMessage;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? image;

  Reviews({
    this.id,
    this.serviceId,
    this.userId,
    this.reviewStar,
    this.reviewMessage,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.image,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
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

class Stores {
  int? id;
  String? storeName;
  String? storeDescription;
  String? price;
  String? mobile;
  String? category;
  List<String>? storeImages;
  List<String>? storeAttachments;

  Stores({
    this.id,
    this.storeName,
    this.storeDescription,
    this.price,
    this.mobile,
    this.category,
    this.storeImages,
    this.storeAttachments,
  });

  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['store_name'];
    storeDescription = json['store_description'];
    price = json['price'];
    mobile = json['mobile'];
    category = json['category'];
    storeImages = json['store_images'].cast<String>();
    storeAttachments = json['store_attachments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_name'] = storeName;
    data['store_description'] = storeDescription;
    data['price'] = price;
    data['mobile'] = mobile;
    data['category'] = category;
    data['store_images'] = storeImages;
    data['store_attachments'] = storeAttachments;
    return data;
  }
}
