// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/models/vendor_models/add_service_model.dart';
import 'package:nlytical/models/vendor_models/delete_service_model.dart';
import 'package:nlytical/models/vendor_models/service_detail_model.dart';
import 'package:nlytical/models/vendor_models/service_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/utils/common_widgets.dart';

class ServiceController extends GetxController {
  ApiHelper apiHelper = ApiHelper();
  RxBool isloading = false.obs;
  Rx<AddServiceModel> addServiceModel = AddServiceModel().obs;
  final searchController = TextEditingController();
  // RxBool isSelected = false.obs;
  RxInt selectedTabIndex = 0.obs;

  Future<void> addServiceApi({
    required String name,
    required String desc,
    required String price,
    List<String>? storeImages,
    List<String>? storeAttachment,
  }) async {
    try {
      isloading(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.addServiceUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
        formData: {
          "service_id": userStoreID,
          "store_name": name,
          "store_description": desc,
          "price": price,
        },
        files: [
          if (storeImages!.length == 1)
            await http.MultipartFile.fromPath('store_images[]', storeImages[0])
          // Otherwise, iterate through the list of images.
          else
            for (String image in storeImages)
              await http.MultipartFile.fromPath('store_images[]', image),
          // service attachment
          if (storeAttachment!.length == 1)
            await http.MultipartFile.fromPath(
              'store_attachments[]',
              storeAttachment[0],
            )
          // Otherwise, iterate through the list of images.
          else
            for (String image in storeAttachment)
              await http.MultipartFile.fromPath('store_attachments[]', image),
        ],
      );

      addServiceModel.value = AddServiceModel.fromJson(response);

      if (addServiceModel.value.status == true) {
        isloading(false);
        Get.back();
        snackBar(
          languageController.textTranslate("Your Service successfully added"),
        );
        serviceListApi();
      } else {
        isloading(false);
        snackBar(addServiceModel.value.message!);
      }
    } catch (e) {
      isloading(false);
      snackBar(
        languageController.textTranslate("Something went wrong, try again"),
      );
    }
  }

  RxBool isGetData = false.obs;
  Rx<ServiceListModel> serviceListModel = ServiceListModel().obs;
  RxList<ServiceList> serviceList = <ServiceList>[].obs;
  RxInt serviceIndex = (-1).obs;

  Future<void> serviceListApi() async {
    try {
      isGetData(true);

      var uri = Uri.parse(apiHelper.storelist);
      var request = http.MultipartRequest("POST", uri);

      request.fields['service_id'] = userStoreID;

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      serviceListModel.value = ServiceListModel.fromJson(data);
      serviceList.clear();
      if (serviceListModel.value.status == true) {
        serviceList.addAll(serviceListModel.value.serviceList!);
        filterSearchPeople();
        isGetData(false);
      } else {
        isGetData(false);

        snackBar(serviceListModel.value.message!);
      }
    } catch (e) {
      isGetData(false);

      snackBar("Something went wrong, try again");
    }
  }

  void filterSearchPeople() {
    if (searchController.text.isEmpty) {
      serviceListModel.value.serviceList = List.from(serviceList);
    } else {
      serviceListModel.value.serviceList = serviceList.where((element) {
        return element.storeName!.toLowerCase().contains(
          searchController.text.toLowerCase(),
        );
      }).toList();
    }
    refresh();
    update();
  }

  RxBool isdelete = false.obs;
  Rx<DeleteServiceModel?> deletemodel = DeleteServiceModel().obs;
  Future<void> deleteserviceApi({String? storeid}) async {
    isdelete.value = true;

    try {
      var uri = Uri.parse(apiHelper.deleteService);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      };

      request.headers.addAll(headers);

      request.fields['store_id'] = storeid!;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      deletemodel.value = DeleteServiceModel.fromJson(userData);

      if (deletemodel.value!.status == true) {
        isdelete.value = false;
      } else {
        isdelete.value = false;

        snackBar(deletemodel.value!.message!);
      }
    } catch (e) {
      isdelete.value = false;
    }
  }

  RxBool isUpdate = false.obs;
  Future<void> updateServiceApi({
    required String serviceID,
    required String name,
    required String desc,
    required String price,
    List<String>? storeImages,
    List<String>? storeAttachment,
  }) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateService,
        headers: {},
        formData: {
          "store_id": serviceID,
          "store_name": name,
          "store_description": desc,
          "price": price,
        },
        files: [
          if (storeImages!.length == 1)
            await http.MultipartFile.fromPath('store_images[]', storeImages[0])
          // Otherwise, iterate through the list of images.
          else
            for (String image in storeImages)
              await http.MultipartFile.fromPath('store_images[]', image),
          // service attachment
          if (storeAttachment!.length == 1)
            await http.MultipartFile.fromPath(
              'store_attachments[]',
              storeAttachment[0],
            )
          // Otherwise, iterate through the list of images.
          else
            for (String image in storeAttachment)
              await http.MultipartFile.fromPath('store_attachments[]', image),
        ],
      );

      if (response['status'] == true) {
        isUpdate(false);
        Get.back();
        snackBar(
          languageController.textTranslate("Your service successfully updated"),
        );
        serviceListApi();
        serviceListModel.refresh();
        serviceList.refresh();
      } else {
        isUpdate(false);
        snackBar(response['message']);
      }
    } catch (e) {
      isUpdate(false);
      snackBar(
        languageController.textTranslate("Something went wrong, try again"),
      );
    }
  }

  RxBool isRemoveImg = false.obs;

  Future<void> removeServiceImgApi({
    required String serviceID,
    required String serviceIMGID,
  }) async {
    isRemoveImg(true);
    final responseJson = await apiHelper.multipartPostMethod(
      url: apiHelper.imgRemoveService,
      formData: {"store_id": serviceID, "store_image_id": serviceIMGID},
      files: [],
      headers: {},
    );

    if (responseJson['status'] == true) {
      isRemoveImg(false);
    } else {
      isRemoveImg(false);
      (responseJson['message']);
    }
  }

  RxBool isRemoveAttach = false.obs;

  Future<void> removeServiceAttachApi({
    required String serviceID,
    required String serviceIMGID,
  }) async {
    isRemoveAttach(true);
    final responseJson = await apiHelper.multipartPostMethod(
      url: apiHelper.attachRemoveService,
      formData: {"store_id": serviceID, "store_attach_id": serviceIMGID},
      files: [],
      headers: {},
    );

    if (responseJson['status'] == true) {
      isRemoveAttach(false);
    } else {
      isRemoveAttach(false);
      (responseJson['message']);
    }
  }

  //========================================== service detail
  RxBool isservice = false.obs;
  Rx<ServiceDetailModel?> servicemodel = ServiceDetailModel().obs;

  Future<void> servicedetailApi() async {
    isservice.value = true;

    try {
      var uri = Uri.parse(apiHelper.getServicedetail);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      };

      request.headers.addAll(headers);
      request.fields['service_id'] = userStoreID;
      request.fields['lat'] = userLatitude;
      request.fields['lon'] = userLongitude;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      servicemodel.value = ServiceDetailModel.fromJson(userData);

      if (servicemodel.value!.status == true) {
        isservice.value = false;
      } else {
        isservice.value = false;
        (servicemodel.value!.message);
      }
    } catch (e) {
      isservice.value = false;
      snackBar("Something went wrong, try again...!");
    }
  }
}
