class SubCategoryModel {
  bool? status;
  String? message;
  List<SubCategoryData>? subCategoryData;

  SubCategoryModel({this.status, this.message, this.subCategoryData});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['subCategoryData'] != null) {
      subCategoryData = <SubCategoryData>[];
      json['subCategoryData'].forEach((v) {
        subCategoryData!.add(SubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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

  SubCategoryData({this.id, this.categoryId, this.subcategoryName});

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryName = json['subcategory_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['subcategory_name'] = subcategoryName;
    return data;
  }
}
