// ignore_for_file: deprecated_member_use, unused_local_variable

import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/user_models/filter_model.dart';
import 'package:nlytical/models/user_models/location_list_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';

final ApiHelper apiHelper = ApiHelper();

class FilterContro extends GetxController {
  RxBool isfilter = false.obs;
  RxBool isnavfilter = false.obs;
  Rx<FilterModel?> filtermodel = FilterModel().obs;
  // RxList<ServiceFilter> filterlist = <ServiceFilter>[].obs;
  RxString selectedCategories = "".obs; // Store selected category
  RxString selectedCategoriesID = "".obs;
  RxString selectedSubCate = "".obs; // Store selected category
  RxString selectedSubCateID = "".obs;
  RxString selectedLocation = "".obs; // Store selected category
  var selectedRating = 0.obs; // Store selected rating
  var selectedPrice = 0.obs;
  // RxList<String> selectedType = <String>[].obs;
  RxString location = ''.obs;
  RxList<ServiceFilter> serviceFilte = <ServiceFilter>[].obs;

  // RxInt currentpage = 1.obs;
  RxBool hasMoreData = true.obs;

  RxList<Marker> filtermarkerList = <Marker>[].obs;

  Future<void> addMarker1() async {
    final customIcon = await getResizedMarkerIcon(
      "assets/images/locationpick.png",
      48,
      48,
    );

    for (int i = 0; i < filtermodel.value!.serviceFilter!.length; i++) {
      final latStr = filtermodel.value!.serviceFilter![i].lat?.toString() ?? "";
      final lonStr = filtermodel.value!.serviceFilter![i].lon?.toString() ?? "";

      // Skip if lat/lon is empty or invalid
      if (latStr.isEmpty || lonStr.isEmpty) continue;

      double? lat = double.tryParse(latStr);
      double? lon = double.tryParse(lonStr);

      // Skip if not a valid number
      if (lat == null || lon == null) continue;

      filtermarkerList.add(
        Marker(
          markerId: MarkerId('MarkerId$i'),
          position: LatLng(lat, lon),
          icon: customIcon,
          onTap: () {
            if (i >= 0 && i < filtermodel.value!.serviceFilter!.length) {
              _scrollToIndex(i);
            }
          },
        ),
      );
    }

    filtermarkerList.refresh();
  }

  Future<BitmapDescriptor> getResizedMarkerIcon(
    String path,
    int width,
    int height,
  ) async {
    final byteData = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    final frame = await codec.getNextFrame();
    final resized = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(resized!.buffer.asUint8List());
  }

  void _scrollToIndex(int index) {
    scrollControllerlocation.animateTo(
      index * 360.0, // Adjust 150.0 based on your item height
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ScrollController scrollControllerlocation = ScrollController();

  RxBool isvisible1 = true.obs;
  RxBool isvisible2 = false.obs;
  RxBool isvisible3 = false.obs;
  RxInt? selectedIndexType;
  RxInt? selectedIndexRating;

  Future<void> filterApi({
    bool isAddData = false,
    String? catId,
    String? catName,
    String? subCatId,
    String? subCatName,
    String? price,
    String? type,
    String? location,
    int? rivstar,
  }) async {
    try {
      if (isfilter.value) return;
      isfilter.value = !isAddData;

      if (isAddData == true) {
        filterPage.value += 1;
      } else {
        filterPage.value = 1;
      }

      var uri = Uri.parse(apiHelper.filter);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      if (catId != null) {
        request.fields['category_id'] = catId;
      }
      if (subCatId != null) {
        request.fields['subcategory_id'] = subCatId;
      }
      if (price != null) {
        request.fields['price'] = price;
      }
      // if (type != null) {
      //   request.fields['type'] = type;
      // }
      if (rivstar != null) {
        request.fields['review_star'] = '$rivstar';
      }
      if (location != null) {
        request.fields['state'] = location;
      }
      request.fields['page_no'] = filterPage.toString();

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      filtermodel.value = FilterModel.fromJson(userData);

      // filterlist.clear();
      serviceFilte.clear();

      if (filtermodel.value!.status == true) {
        final newData = filtermodel.value!.serviceFilter ?? [];
        // List<ServiceFilter>? newData = filtermodel.value!.serviceFilter!;

        if (!isAddData) {
          serviceFilte.clear();
          serviceFilte.value = newData;
        } else {
          if (newData.isNotEmpty) {
            serviceFilte.addAll(newData);
          }
        }

        isfilter.value = false;
        isnavfilter.value = true;
        if (catId == null &&
            subCatId == null &&
            price == null &&
            rivstar == null &&
            location == null) {
          isnavfilter.value = false;
        }
        if (price != null) {
          selectedPrice.value = int.parse(price);
        } else {
          selectedPrice.value = 0;
        }
        if (rivstar != null) {
          selectedRating.value = rivstar;
        } else {
          selectedRating.value = 0;
        }

        if (catId != null) {
          selectedCategories.value = catName.toString();
          selectedCategoriesID.value = catId.toString();
        } else {
          selectedCategories.value = "";
          selectedCategoriesID.value = "";
        }
        if (subCatId != null) {
          selectedSubCate.value = subCatName.toString();
          selectedSubCateID.value = subCatId.toString();
        } else {
          selectedSubCate.value = "";
          selectedSubCateID.value = "";
        }

        if (location != null) {
          selectedLocation.value = location.toString();
        } else {
          selectedLocation.value = "";
        }
        filtermarkerList.clear();
        addMarker1();

        Get.back();
        // snackBar(filtermodel.value!.message!);
      } else {
        isfilter.value = false;
      }
    } catch (e) {
      isfilter.value = false;
    }
  }

  RxDouble searchLatitude = 0.0.obs;
  RxDouble searchLongitude = 0.0.obs;
  GoogleMapController? mapController;

  Future<void> getLonLat(String input) async {
    String kPlaceApiKey = googleMapKey;
    String baseURL =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$input&key=$kPlaceApiKey';

    var response = await http.get(Uri.parse(baseURL));
    var data = response.body.toString();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final location = data['results'][0]['geometry']['location'];

      searchLatitude.value = location['lat'];
      searchLongitude.value = location['lng'];

      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(searchLatitude.value, searchLongitude.value),
        ),
      );
    }
  }

  List<dynamic> mapresult = [];

  Future<void> getsuggestion(String input) async {
    String kPlaceApiKey = googleMapKey;
    String baseURL =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request = '$baseURL?input=$input&key=$kPlaceApiKey';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    if (response.statusCode == 200) {
      mapresult = jsonDecode(response.body)['predictions'];
    } else {
      snackBar("Problem while getting Location");
    }
  }

  RxDouble circleRadius = 0.0.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000.0.obs;

  //=========================================================
  RxBool isLoad = false.obs;
  Rx<LocationListApiModel> locationModel = LocationListApiModel().obs;
  RxList<String> countriesList = <String>[].obs;

  Future<void> locationListApi(String xyz) async {
    isLoad(true);

    var uri = Uri.parse(apiHelper.locationListApi);
    var request = http.MultipartRequest('Post', uri);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    request.headers.addAll(headers);
    if (xyz.isNotEmpty) {
      request.fields['data_search'] = xyz;
    }
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    locationModel.value = LocationListApiModel.fromJson(userData);
    countriesList.clear();
    if (locationModel.value.status == true) {
      countriesList.addAll(locationModel.value.countriesList!);
      isLoad(false);
    } else {
      isLoad(false);
      snackBar("Location Not Found");
    }
  }

  // *************************************all store******************************************* //
  // *************************************all store******************************************* //
  // *************************************all store******************************************* //
  RxInt filterPage = 1.obs;
  Future<void> filterApiAll({bool isAddData = false}) async {
    try {
      if (isfilter.value) return;
      isfilter.value = !isAddData;

      if (isAddData == true) {
        filterPage.value += 1;
      } else {
        filterPage.value = 1;
      }

      var uri = Uri.parse(apiHelper.filter);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['page_no'] = filterPage.toString();

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      filtermodel.value = FilterModel.fromJson(userData);

      if (filtermodel.value!.status == true) {
        final newData = filtermodel.value!.serviceFilter ?? [];

        if (!isAddData) {
          serviceFilte.clear();
          serviceFilte.value = newData;
        } else {
          if (newData.isNotEmpty) {
            serviceFilte.addAll(newData);
          } else {}
        }

        isfilter.value = false;
        filtermarkerList.clear();
        addMarker1();
      } else {
        isfilter.value = false;
      }
    } catch (e) {
      isfilter.value = false;
    }
  }

  void cateClearMethod() {
    if (selectedSubCateID.value == '' &&
        selectedSubCate.value == '' &&
        selectedRating.value == 0 &&
        selectedPrice.value == 0 &&
        selectedLocation.value == '') {
      isnavfilter.value = false;
      filterApiAll();
    } else {
      filterApi(
        isAddData: false,
        subCatId: selectedSubCateID.value.isNotEmpty
            ? selectedSubCateID.value
            : null,
        subCatName: selectedSubCate.value.isNotEmpty
            ? selectedSubCate.value
            : null,
        rivstar: selectedRating.value > 0 ? selectedRating.value : null,
        price: selectedPrice.value > 0 ? selectedPrice.toString() : null,
        location: selectedLocation.value.isNotEmpty
            ? selectedLocation.value
            : null,
      );
    }
    selectedCategories.value = '';
    selectedCategoriesID.value = '';
  }

  void subCatClearMetohd() {
    if (selectedCategoriesID.value == '' &&
        selectedCategories.value == '' &&
        selectedRating.value > 0 &&
        selectedPrice.value > 0 &&
        selectedLocation.value == '') {
      isnavfilter.value = false;
      filterApiAll();
    } else {
      filterApi(
        isAddData: false,
        catId: selectedCategoriesID.value.isNotEmpty
            ? selectedCategoriesID.value
            : null,
        catName: selectedCategories.value.isNotEmpty
            ? selectedCategories.value
            : null,
        rivstar: selectedRating.value > 0 ? selectedRating.value : null,
        price: selectedPrice.value > 0 ? selectedPrice.toString() : null,
        location: selectedLocation.value.isNotEmpty
            ? selectedLocation.value
            : null,
      );
    }
    selectedSubCate.value = '';
    selectedSubCateID.value = '';
  }

  void ratingClearMethod() {
    if (selectedCategoriesID.value == '' &&
        selectedCategories.value == '' &&
        selectedSubCateID.value == '' &&
        selectedSubCate.value == '' &&
        selectedPrice.value > 0 &&
        selectedLocation.value == '') {
      isnavfilter.value = false;
      filterApiAll();
    } else {
      filterApi(
        isAddData: false,
        catId: selectedCategoriesID.value.isNotEmpty
            ? selectedCategoriesID.value
            : null,
        catName: selectedCategories.value.isNotEmpty
            ? selectedCategories.value
            : null,
        subCatId: selectedSubCateID.value.isNotEmpty
            ? selectedSubCateID.value
            : null,
        subCatName: selectedSubCate.value.isNotEmpty
            ? selectedSubCate.value
            : null,
        price: selectedPrice.value > 0 ? selectedPrice.toString() : null,
        location: selectedLocation.value.isNotEmpty
            ? selectedLocation.value
            : null,
      );
    }
    selectedRating.value = 0;
  }

  void priceClearMethod() {
    if (selectedCategoriesID.value == '' &&
        selectedCategories.value == '' &&
        selectedSubCateID.value == '' &&
        selectedSubCate.value == '' &&
        selectedRating.value > 0 &&
        selectedLocation.value == '') {
      isnavfilter.value = false;
      filterApiAll();
    } else {
      filterApi(
        isAddData: false,
        catId: selectedCategoriesID.value.isNotEmpty
            ? selectedCategoriesID.value
            : null,
        catName: selectedCategories.value.isNotEmpty
            ? selectedCategories.value
            : null,
        subCatId: selectedSubCateID.value.isNotEmpty
            ? selectedSubCateID.value
            : null,
        subCatName: selectedSubCate.value.isNotEmpty
            ? selectedSubCate.value
            : null,
        rivstar: selectedRating.value > 0 ? selectedRating.value : null,
        location: selectedLocation.value.isNotEmpty
            ? selectedLocation.value
            : null,
      );
    }
    selectedPrice.value = 0;
  }

  void locationClearMethod() {
    if (selectedCategoriesID.value == '' &&
        selectedCategories.value == '' &&
        selectedSubCateID.value == '' &&
        selectedSubCate.value == '' &&
        selectedRating.value > 0 &&
        selectedPrice.value > 0) {
      isnavfilter.value = false;
      filterApiAll();
    } else {
      filterApi(
        isAddData: false,
        catId: selectedCategoriesID.value.isNotEmpty
            ? selectedCategoriesID.value
            : null,
        catName: selectedCategories.value.isNotEmpty
            ? selectedCategories.value
            : null,
        subCatId: selectedSubCateID.value.isNotEmpty
            ? selectedSubCateID.value
            : null,
        subCatName: selectedSubCate.value.isNotEmpty
            ? selectedSubCate.value
            : null,
        rivstar: selectedRating.value > 0 ? selectedRating.value : null,
        price: selectedPrice.value > 0 ? selectedPrice.toString() : null,
      );
    }
    selectedLocation.value = '';
  }

  void clear() {
    selectedCategories.value = '';
    selectedCategoriesID.value = '';
    selectedSubCateID.value = '';
    selectedSubCate.value = '';
    selectedRating.value = 0;
    selectedPrice.value = 0;
    selectedLocation.value = '';
    isnavfilter.value = false;
  }
}
