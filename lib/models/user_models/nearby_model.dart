// class NearbyModel {
//   bool? status;
//   String? message;
//   int? guestUser;
//   List<NearbyService>? nearbyService;
//   int? totalPage;

//   NearbyModel(
//       {this.status,
//       this.message,
//       this.guestUser,
//       this.nearbyService,
//       this.totalPage});

//   NearbyModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     guestUser = json['guest_user'];
//     if (json['NearbyService'] != null) {
//       nearbyService = <NearbyService>[];
//       json['NearbyService'].forEach((v) {
//         nearbyService!.add(new NearbyService.fromJson(v));
//       });
//     }
//     totalPage = json['total_page'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['status'] = status;
//     data['message'] = message;
//     data['guest_user'] = guestUser;
//     if (nearbyService != null) {
//       data['NearbyService'] =
//           nearbyService!.map((v) => v.toJson()).toList();
//     }
//     data['total_page'] = totalPage;
//     return data;
//   }
// }

// class NearbyService {
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

//   NearbyService(
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

//   NearbyService.fromJson(Map<String, dynamic> json) {
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

class NearbyModel {
  bool? status;
  String? message;
  List<NearbyService>? nearbyService;
  int? totalPage;

  NearbyModel({this.status, this.message, this.nearbyService, this.totalPage});

  NearbyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['NearbyService'] != null) {
      nearbyService = <NearbyService>[];
      json['NearbyService'].forEach((v) {
        nearbyService!.add(NearbyService.fromJson(v));
      });
    }
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (nearbyService != null) {
      data['NearbyService'] = nearbyService!.map((v) => v.toJson()).toList();
    }
    data['total_page'] = totalPage;
    return data;
  }
}

class NearbyService {
  int? id;
  String? serviceName;
  String? address;
  int? categoryId;
  int? vendorId;
  String? categoryName;
  String? lat;
  String? lon;
  int? isFeatured;
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

  NearbyService(
      {this.id,
      this.serviceName,
      this.address,
      this.categoryId,
      this.vendorId,
      this.categoryName,
      this.lat,
      this.lon,
      this.isFeatured,
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

  NearbyService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    address = json['address'];
    categoryId = json['category_id'];
    vendorId = json['vendor_id'];
    categoryName = json['category_name'];
    lat = json['lat'];
    lon = json['lon'];
    isFeatured = json['is_featured'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['address'] = address;
    data['category_id'] = categoryId;
    data['vendor_id'] = vendorId;
    data['category_name'] = categoryName;
    data['lat'] = lat;
    data['lon'] = lon;
    data['is_featured'] = isFeatured;
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
