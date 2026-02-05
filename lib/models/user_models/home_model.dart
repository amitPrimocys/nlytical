// // ignore_for_file: prefer_collection_literals

// class HomeModel {
//   bool? status;
//   String? message;
//   String? firstName;
//   String? lastName;
//   int? guestUser;
//   List<String>? slides;
//   List<Categories>? categories;
//   List<AllServices>? allServices;

//   HomeModel(
//       {this.status,
//       this.message,
//       this.firstName,
//       this.lastName,
//       this.guestUser,
//       this.slides,
//       this.categories,
//       this.allServices});

//   HomeModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     guestUser = json['guest_user'];
//     slides = json['slides'].cast<String>();
//     if (json['categories'] != null) {
//       categories = <Categories>[];
//       json['categories'].forEach((v) {
//         categories!.add(Categories.fromJson(v));
//       });
//     }
//     if (json['all_services'] != null) {
//       allServices = <AllServices>[];
//       json['all_services'].forEach((v) {
//         allServices!.add(AllServices.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['status'] = status;
//     data['message'] = message;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['guest_user'] = guestUser;
//     data['slides'] = slides;
//     if (categories != null) {
//       data['categories'] = categories!.map((v) => v.toJson()).toList();
//     }
//     if (allServices != null) {
//       data['all_services'] = allServices!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Categories {
//   int? id;
//   String? categoryName;
//   String? categoryImage;

//   Categories({this.id, this.categoryName, this.categoryImage});

//   Categories.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryName = json['category_name'];
//     categoryImage = json['category_image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = id;
//     data['category_name'] = categoryName;
//     data['category_image'] = categoryImage;
//     return data;
//   }
// }

// class AllServices {
//   int? id;
//   String? serviceName;
//   String? address;
//   int? categoryId;
//   int? vendorId;
//   String? categoryName;
//   String? lat;
//   String? lon;
//   String? distance;
//   List<String>? serviceImages;
//   int? isLike;
//   int? totalReviewCount;
//   String? totalAvgReview;

//   AllServices(
//       {this.id,
//       this.serviceName,
//       this.address,
//       this.categoryId,
//       this.vendorId,
//       this.categoryName,
//       this.lat,
//       this.lon,
//       this.distance,
//       this.serviceImages,
//       this.isLike,
//       this.totalReviewCount,
//       this.totalAvgReview});

//   AllServices.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     serviceName = json['service_name'];
//     address = json['address'];
//     categoryId = json['category_id'];
//     vendorId = json['vendor_id'];
//     categoryName = json['category_name'];
//     lat = json['lat'];
//     lon = json['lon'];
//     distance = json['distance'];
//     serviceImages = json['service_images'].cast<String>();
//     isLike = json['isLike'];
//     totalReviewCount = json['totalReviewCount'];
//     totalAvgReview = json['totalAvgReview'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = id;
//     data['service_name'] = serviceName;
//     data['address'] = address;
//     data['category_id'] = categoryId;
//     data['vendor_id'] = vendorId;
//     data['category_name'] = categoryName;
//     data['lat'] = lat;
//     data['lon'] = lon;
//     data['distance'] = distance;
//     data['service_images'] = serviceImages;
//     data['isLike'] = isLike;
//     data['totalReviewCount'] = totalReviewCount;
//     data['totalAvgReview'] = totalAvgReview;
//     return data;
//   }
// }




// ignore_for_file: prefer_collection_literals

class HomeModel {
  bool? status;
  String? message;
  String? firstName;
  String? lastName;
  List<String>? slides;
  List<Categories>? categories;
  List<NearbyStores>? nearbyStores;
  List<LatestService>? latestService;

  HomeModel(
      {this.status,
      this.message,
      this.firstName,
      this.lastName,
      this.slides,
      this.categories,
      this.nearbyStores,
      this.latestService});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    slides = json['slides'].cast<String>();
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['nearby_stores'] != null) {
      nearbyStores = <NearbyStores>[];
      json['nearby_stores'].forEach((v) {
        nearbyStores!.add(NearbyStores.fromJson(v));
      });
    }
    if (json['latest_service'] != null) {
      latestService = <LatestService>[];
      json['latest_service'].forEach((v) {
        latestService!.add(LatestService.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['slides'] = slides;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (nearbyStores != null) {
      data['nearby_stores'] =
          nearbyStores!.map((v) => v.toJson()).toList();
    }
    if (latestService != null) {
      data['latest_service'] =
          latestService!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? categoryName;
  String? categoryImage;
  int? subcategoryCount;

  Categories(
      {this.id, this.categoryName, this.categoryImage, this.subcategoryCount});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
    subcategoryCount = json['subcategory_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['category_name'] = categoryName;
    data['category_image'] = categoryImage;
    data['subcategory_count'] = subcategoryCount;
    return data;
  }
}

class NearbyStores {
  int? id;
  String? serviceName;
  String? address;
  int? categoryId;
  int? vendorId;
  String? categoryName;
  String? lat;
  int? isFeatured;
  String? lon;
  String? distance;
  List<String>? serviceImages;
  int? isLike;
  int? totalReviewCount;
  String? totalAvgReview;
  String? vendorFirstName;
  String? vendorLastName;
  String? vendorEmail;
  String? vendorImage;
  int? totalYearsCount;
  String? priceRange;

  NearbyStores(
      {this.id,
      this.serviceName,
      this.address,
      this.categoryId,
      this.vendorId,
      this.categoryName,
      this.lat,
      this.isFeatured,
      this.lon,
      this.distance,
      this.serviceImages,
      this.isLike,
      this.totalReviewCount,
      this.totalAvgReview,
      this.vendorFirstName,
      this.vendorLastName,
      this.vendorEmail,
      this.vendorImage,
      this.totalYearsCount,
      this.priceRange});

  NearbyStores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    address = json['address'];
    categoryId = json['category_id'];
    vendorId = json['vendor_id'];
    categoryName = json['category_name'];
    lat = json['lat'];
    isFeatured = json['is_featured'];
    lon = json['lon'];
    distance = json['distance'];
    serviceImages = json['service_images'].cast<String>();
    isLike = json['isLike'];
    totalReviewCount = json['totalReviewCount'];
    totalAvgReview = json['totalAvgReview'];
    vendorFirstName = json['vendor_first_name'];
    vendorLastName = json['vendor_last_name'];
    vendorEmail = json['vendor_email'];
    vendorImage = json['vendor_image'];
    totalYearsCount = json['total_years_count'];
    priceRange = json['price_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['service_name'] = serviceName;
    data['address'] = address;
    data['category_id'] = categoryId;
    data['vendor_id'] = vendorId;
    data['category_name'] = categoryName;
    data['lat'] = lat;
    data['is_featured'] = isFeatured;
    data['lon'] = lon;
    data['distance'] = distance;
    data['service_images'] = serviceImages;
    data['isLike'] = isLike;
    data['totalReviewCount'] = totalReviewCount;
    data['totalAvgReview'] = totalAvgReview;
    data['vendor_first_name'] = vendorFirstName;
    data['vendor_last_name'] = vendorLastName;
    data['vendor_email'] = vendorEmail;
    data['vendor_image'] = vendorImage;
    data['total_years_count'] = totalYearsCount;
    data['price_range'] = priceRange;
    return data;
  }
}

class LatestService {
  int? id;
  String? serviceName;
  String? address;
  String? lat;
  String? lon;
  int? categoryId;
  int? vendorId;
  int? isFeatured;
  String? categoryName;
  String? vendorFirstName;
  String? vendorLastName;
  String? vendorEmail;
  List<String>? serviceImages;
  int? isLike;
  int? totalReviewCount;
  String? totalAvgReview;
  String? vendorImage;
  int? totalYearsCount;
  String? priceRange;

  LatestService(
      {this.id,
      this.serviceName,
      this.address,
      this.lat,
      this.lon,
      this.categoryId,
      this.vendorId,
      this.isFeatured,
      this.categoryName,
      this.vendorFirstName,
      this.vendorLastName,
      this.vendorEmail,
      this.serviceImages,
      this.isLike,
      this.totalReviewCount,
      this.totalAvgReview,
      this.vendorImage,
      this.totalYearsCount,
      this.priceRange});

  LatestService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    categoryId = json['category_id'];
    vendorId = json['vendor_id'];
    isFeatured = json['is_featured'];
    categoryName = json['category_name'];
    vendorFirstName = json['vendor_first_name'];
    vendorLastName = json['vendor_last_name'];
    vendorEmail = json['vendor_email'];
    serviceImages = json['service_images'].cast<String>();
    isLike = json['isLike'];
    totalReviewCount = json['totalReviewCount'];
    totalAvgReview = json['totalAvgReview'];
    vendorImage = json['vendor_image'];
    totalYearsCount = json['total_years_count'];
    priceRange = json['price_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['service_name'] = serviceName;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['category_id'] = categoryId;
    data['vendor_id'] = vendorId;
    data['is_featured'] = isFeatured;
    data['category_name'] = categoryName;
    data['vendor_first_name'] = vendorFirstName;
    data['vendor_last_name'] = vendorLastName;
    data['vendor_email'] = vendorEmail;
    data['service_images'] = serviceImages;
    data['isLike'] = isLike;
    data['totalReviewCount'] = totalReviewCount;
    data['totalAvgReview'] = totalAvgReview;
    data['vendor_image'] = vendorImage;
    data['total_years_count'] = totalYearsCount;
    data['price_range'] = priceRange;
    return data;
  }
}
