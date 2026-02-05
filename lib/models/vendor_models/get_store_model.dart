class GetStoreDetailModel {
  bool? status;
  String? message;
  String? firstName;
  List<ServiceDetails>? serviceDetails;

  GetStoreDetailModel(
      {this.status, this.message, this.firstName, this.serviceDetails});

  GetStoreDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    firstName = json['first_name'];
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
    data['first_name'] = firstName;
    if (serviceDetails != null) {
      data['serviceDetails'] = serviceDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceDetails {
  BusinessDetails? businessDetails;
  ContactDetails? contactDetails;
  BusinessTime? businessTime;
  Otherdetails? otherdetails;

  ServiceDetails(
      {this.businessDetails,
      this.contactDetails,
      this.businessTime,
      this.otherdetails});

  ServiceDetails.fromJson(Map<String, dynamic> json) {
    businessDetails = json['businessDetails'] != null
        ? BusinessDetails.fromJson(json['businessDetails'])
        : null;
    contactDetails = json['contactDetails'] != null
        ? ContactDetails.fromJson(json['contactDetails'])
        : null;
    businessTime = json['businessTime'] != null
        ? BusinessTime.fromJson(json['businessTime'])
        : null;
    otherdetails = json['otherdetails'] != null
        ? Otherdetails.fromJson(json['otherdetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (businessDetails != null) {
      data['businessDetails'] = businessDetails!.toJson();
    }
    if (contactDetails != null) {
      data['contactDetails'] = contactDetails!.toJson();
    }
    if (businessTime != null) {
      data['businessTime'] = businessTime!.toJson();
    }
    if (otherdetails != null) {
      data['otherdetails'] = otherdetails!.toJson();
    }
    return data;
  }
}

class BusinessDetails {
  int? id;
  int? vendorId;
  String? serviceName;
  String? serviceDescription;
  List<ServiceImages>? serviceImages;
  String? videoThumbnail;
  String? aspectRatio;
  String? video;
  int? categoryId;
  String? subcategoryId;
  int? requestApproval;

  BusinessDetails(
      {this.id,
      this.vendorId,
      this.serviceName,
      this.serviceDescription,
      this.serviceImages,
      this.videoThumbnail,
      this.aspectRatio,
      this.video,
      this.categoryId,
      this.subcategoryId,
      this.requestApproval});

  BusinessDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    serviceName = json['service_name'];
    serviceDescription = json['service_description'];
    if (json['service_images'] != null) {
      serviceImages = <ServiceImages>[];
      json['service_images'].forEach((v) {
        serviceImages!.add(ServiceImages.fromJson(v));
      });
    }
    videoThumbnail = json['video_thumbnail'];
    aspectRatio = json['aspect_ratio'];
    video = json['video'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    requestApproval = json['request_approval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['service_name'] = serviceName;
    data['service_description'] = serviceDescription;
    if (serviceImages != null) {
      data['service_images'] = serviceImages!.map((v) => v.toJson()).toList();
    }
    data['video_thumbnail'] = videoThumbnail;
    data['aspect_ratio'] = aspectRatio;
    data['video'] = video;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['request_approval'] = requestApproval;
    return data;
  }
}

class ServiceImages {
  int? id;
  String? url;

  ServiceImages({this.id, this.url});

  ServiceImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class ContactDetails {
  String? serviceWebsite;
  String? serviceCountryCode;
  String? servicePhone;
  String? serviceEmail;
  String? address;
  String? lat;
  String? lon;
  String? instagramLink;
  String? facebookLink;
  String? whatsappLink;
  String? twitterLink;

  ContactDetails(
      {this.serviceWebsite,
      this.serviceCountryCode,
      this.servicePhone,
      this.serviceEmail,
      this.address,
      this.lat,
      this.lon,
      this.instagramLink,
      this.facebookLink,
      this.whatsappLink,
      this.twitterLink});

  ContactDetails.fromJson(Map<String, dynamic> json) {
    serviceWebsite = json['service_website'];
    serviceCountryCode = json['service_country_code'];
    servicePhone = json['service_phone'];
    serviceEmail = json['service_email'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    instagramLink = json['instagram_link'];
    facebookLink = json['facebook_link'];
    whatsappLink = json['whatsapp_link'];
    twitterLink = json['twitter_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_website'] = serviceWebsite;
    data['service_country_code'] = serviceCountryCode;
    data['service_phone'] = servicePhone;
    data['service_email'] = serviceEmail;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['instagram_link'] = instagramLink;
    data['facebook_link'] = facebookLink;
    data['whatsapp_link'] = whatsappLink;
    data['twitter_link'] = twitterLink;
    return data;
  }
}

class BusinessTime {
  String? openDays;
  String? openTime;
  String? closeTime;
  String? closedDays;
  String? employeeStrength;
  String? publishedMonth;
  String? publishedYear;

  BusinessTime(
      {this.openDays,
      this.openTime,
      this.closeTime,
      this.closedDays,
      this.employeeStrength,
      this.publishedMonth,
      this.publishedYear});

  BusinessTime.fromJson(Map<String, dynamic> json) {
    openDays = json['open_days'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    closedDays = json['closed_days'];
    employeeStrength = json['employee_strength'];
    publishedMonth = json['published_month'];
    publishedYear = json['published_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open_days'] = openDays;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['closed_days'] = closedDays;
    data['employee_strength'] = employeeStrength;
    data['published_month'] = publishedMonth;
    data['published_year'] = publishedYear;
    return data;
  }
}

class Otherdetails {
  int? totalReviewCount;
  String? totalAvgReview;
  String? categoryName;

  Otherdetails({this.totalReviewCount, this.totalAvgReview, this.categoryName});

  Otherdetails.fromJson(Map<String, dynamic> json) {
    totalReviewCount = json['totalReviewCount'];
    totalAvgReview = json['totalAvgReview'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalReviewCount'] = totalReviewCount;
    data['totalAvgReview'] = totalAvgReview;
    data['category_name'] = categoryName;
    return data;
  }
}
