// // ignore_for_file: unnecessary_this, prefer_collection_literals

// class SubCategoriesModel {
//   bool? status;
//   String? message;
//   List<SubCategoryData>? subCategoryData;

//   SubCategoriesModel({this.status, this.message, this.subCategoryData});

//   SubCategoriesModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['subCategoryData'] != null) {
//       subCategoryData = <SubCategoryData>[];
//       json['subCategoryData'].forEach((v) {
//         subCategoryData!.add(SubCategoryData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.subCategoryData != null) {
//       data['subCategoryData'] =
//           this.subCategoryData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class SubCategoryData {
//   int? id;
//   int? categoryId;
//   String? subcategoryName;

//   SubCategoryData({this.id, this.categoryId, this.subcategoryName});

//   SubCategoryData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryId = json['category_id'];
//     subcategoryName = json['subcategory_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = this.id;
//     data['category_id'] = this.categoryId;
//     data['subcategory_name'] = this.subcategoryName;
//     return data;
//   }
// }

// ignore_for_file: prefer_collection_literals

// class SubCategoriesModel {
//   bool? status;
//   String? message;
//   int? totalSubCategoryCount;
//   List<SubCategoryData>? subCategoryData;

//   SubCategoriesModel(
//       {this.status,
//       this.message,
//       this.totalSubCategoryCount,
//       this.subCategoryData});

//   SubCategoriesModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     totalSubCategoryCount = json['totalSubCategoryCount'];
//     if (json['subCategoryData'] != null) {
//       subCategoryData = <SubCategoryData>[];
//       json['subCategoryData'].forEach((v) {
//         // ignore: unnecessary_new
//         subCategoryData!.add(new SubCategoryData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['status'] = status;
//     data['message'] = message;
//     data['totalSubCategoryCount'] = totalSubCategoryCount;
//     if (subCategoryData != null) {
//       data['subCategoryData'] =
//           subCategoryData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class SubCategoryData {
//   int? id;
//   int? categoryId;
//   String? subcategoryName;

//   SubCategoryData({this.id, this.categoryId, this.subcategoryName});

//   SubCategoryData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryId = json['category_id'];
//     subcategoryName = json['subcategory_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = id;
//     data['category_id'] = categoryId;
//     data['subcategory_name'] = subcategoryName;
//     return data;
//   }
// }

class SubCategoriesModel {
  bool? status;
  String? message;
  int? totalSubCategoryCount;
  List<SubCategoryData>? subCategoryData;

  SubCategoriesModel(
      {this.status,
      this.message,
      this.totalSubCategoryCount,
      this.subCategoryData});

  SubCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalSubCategoryCount = json['totalSubCategoryCount'];
    if (json['subCategoryData'] != null) {
      subCategoryData = <SubCategoryData>[];
      json['subCategoryData'].forEach((v) {
        subCategoryData!.add(SubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['totalSubCategoryCount'] = totalSubCategoryCount;
    if (subCategoryData != null) {
      data['subCategoryData'] =
          subCategoryData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryData {
  int? id;
  int? categoryId;
  String? subcategoryName;
  String? subcategoryImage;
  int? servicesCount;

  SubCategoryData(
      {this.id,
      this.categoryId,
      this.subcategoryName,
      this.subcategoryImage,
      this.servicesCount});

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryName = json['subcategory_name'];
    subcategoryImage = json['subcategory_image'];
    servicesCount = json['services_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['category_id'] = categoryId;
    data['subcategory_name'] = subcategoryName;
    data['subcategory_image'] = subcategoryImage;
    data['services_count'] = servicesCount;
    return data;
  }
}
