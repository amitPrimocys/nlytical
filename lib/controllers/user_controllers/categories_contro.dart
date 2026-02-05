import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/cate_model.dart';
import 'package:nlytical/models/user_models/subcate_model.dart';
import 'package:nlytical/utils/api_helper.dart';

final ApiHelper apiHelper = ApiHelper();

class CategoriesContro extends GetxController {
  TextEditingController searchCategoriesCtrl = TextEditingController();
  TextEditingController searchSubCategoriesCtrl = TextEditingController();
  RxBool iscat = false.obs;
  Rx<CategoriesModel?> catemodel = CategoriesModel().obs;
  RxList<Data> catelist = <Data>[].obs;

  Future<void> cateApi() async {
    try {
      iscat.value = true;
      var uri = Uri.parse(apiHelper.categories);
      var request = http.MultipartRequest('GET', uri);

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      catemodel.value = CategoriesModel.fromJson(userData);

      catelist.clear();

      if (catemodel.value!.status == true) {
        catelist.addAll(catemodel.value!.data!);
        iscat.value = false;
      } else {
        iscat.value = false;
      }
    } catch (e) {
      iscat.value = false;
    }
  }

  void filterSearchPeople() {
    if (searchCategoriesCtrl.text.isEmpty) {
      catemodel.value!.data = List.from(catelist);
    } else {
      catemodel.value!.data = catelist.where((element) {
        return element.categoryName!.toLowerCase().contains(
          searchCategoriesCtrl.text.toLowerCase(),
        );
      }).toList();
    }
    refresh();
    update();
  }

  RxBool issubcat = false.obs;
  Rx<SubCategoriesModel?> subcatemodel = SubCategoriesModel().obs;
  RxList<SubCategoryData> subcatelist = <SubCategoryData>[].obs;

  Future<void> subcateApi({required String catId}) async {
    issubcat.value = true;

    try {
      var uri = Uri.parse(apiHelper.subcategories);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      };

      request.headers.addAll(headers);

      request.fields['category_id'] = catId;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      subcatemodel.value = SubCategoriesModel.fromJson(userData);

      subcatelist.clear();

      if (subcatemodel.value!.status == true) {
        subcatelist.addAll(subcatemodel.value!.subCategoryData!);
        issubcat.value = false;
      } else {
        issubcat.value = false;
      }
    } catch (e) {
      issubcat.value = false;
    }
  }

  void filterSearchSubCate() {
    if (searchSubCategoriesCtrl.text.isEmpty) {
      subcatemodel.value!.subCategoryData = List.from(subcatelist);
    } else {
      subcatemodel.value!.subCategoryData = subcatelist.where((element) {
        return element.subcategoryName!.toLowerCase().contains(
          searchSubCategoriesCtrl.text.toLowerCase(),
        );
      }).toList();
    }
    refresh();
    update();
  }
}
