import 'package:nlytical/models/vendor_models/sub_cate_model.dart';
// import 'package:nlytical_vendor/models/sub_cate_model.dart';

class CategoryModel {
  bool? status;
  String? message;
  List<Data>? data;

  CategoryModel({this.status, this.message, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? categoryName;
  String? categoryImage;
  List<SubCategoryData>? subCategoryData;

  Data({this.id, this.categoryName, this.categoryImage, this.subCategoryData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
    subCategoryData = json["subCategoryData"] == null
        ? []
        : (json["subCategoryData"] as List)
              .map((e) => SubCategoryData.fromJson(e))
              .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['category_image'] = categoryImage;
    if (subCategoryData != null) {
      data["subCategoryData"] = subCategoryData!
          .map((e) => e.toJson())
          .toList();
    }
    return data;
  }
}
