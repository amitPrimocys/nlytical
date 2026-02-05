import 'dart:convert';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/address_location_fetch.dart';
import 'package:get/get.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/user_models/subcate_model.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/models/vendor_models/add_store_model.dart';
import 'package:nlytical/models/vendor_models/category_model.dart';
import 'package:nlytical/models/vendor_models/get_store_model.dart';
import 'package:nlytical/models/vendor_models/store_update_model.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';

class StoreController extends GetxController {
  @override
  void onInit() {
    getCategory();
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    if (userStoreID.isNotEmpty || userStoreID != "") {
      getStoreDetailApi();
      businessPercentageApi();
    }
  }

  ApiHelper apiHelper = ApiHelper();
  RxBool isCategoryLoading = false.obs;

  RxString caategoryName = ''.obs;
  RxList<String> subCategoryNames = <String>[].obs;
  RxList<String> filteredSubCategoryNames = <String>[].obs;

  RxList<String> categories = <String>[].obs;
  RxList<String> subCategories = <String>[].obs;

  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  RxList<String> openingAndClosingDays = <String>[].obs;
  RxList<String> openDaysList = <String>[].obs;

  Rx<CategoryModel> categoryData = CategoryModel().obs;
  RxList<Data> cateListData = <Data>[].obs;
  RxString area = "".obs;
  RxString city = "".obs;
  RxString state = "".obs;
  RxString countryName = "".obs;

  var currentAddress = "Fetching location...";
  RxBool isAllCategoryDataLoaded = false.obs;

  Rx<SubCategoriesModel> subCateModel = SubCategoriesModel().obs;
  RxList<SubCategoryData> subCategoryList = <SubCategoryData>[].obs;

  Future<void> getCategory() async {
    try {
      isCategoryLoading.value = true;
      isAllCategoryDataLoaded.value = false;

      final responseJson = await apiHelper.getMethod(
        url: apiHelper.getCategory,
      );
      categoryData.value = CategoryModel.fromJson(responseJson);
      cateListData.clear();

      if (categoryData.value.status == true) {
        cateListData.addAll(categoryData.value.data!);
        categories.value = categoryData.value.data!
            .map((e) => e.categoryName!)
            .toList();
        for (var i = 0; i < categoryData.value.data!.length; i++) {
          await getSubCategory(
            categoryId: categoryData.value.data![i].id.toString(),
            index: i,
          );
        }
      }
      isAllCategoryDataLoaded.value = true; // ✅ mark as done
      isCategoryLoading.value = false;
    } catch (e) {
      isCategoryLoading.value = false;
    }
  }

  Future<void> getSubCategory({
    required String categoryId,
    required int index,
  }) async {
    try {
      final responseJson = await apiHelper.multipartPostMethod(
        url: apiHelper.getSubcategory,
        formData: {"category_id": categoryId},
        files: [],
        headers: {},
      );
      categoryData.value.data![index].subCategoryData = Data.fromJson(
        responseJson,
      ).subCategoryData;

      subCateModel.value = SubCategoriesModel.fromJson(responseJson);
      subCategoryList.clear();
      if (subCateModel.value.status == true) {
        subCategoryList.addAll(subCateModel.value.subCategoryData!);
      }
    } catch (e) {
      isCategoryLoading.value = false;
    }
  }

  RxDouble searchLatitude = 0.0.obs;
  RxDouble searchLongitude = 0.0.obs;
  GoogleMapController? mapController;

  Future<void> getLonLat(String address) async {
    final result = await GeocodingService.fetchLocationDetails(address);
    if (result != null) {
      searchLatitude.value = result.latitude;
      searchLongitude.value = result.longitude;
      area.value = result.area ?? '';
      city.value = result.city ?? '';
      state.value = result.state ?? '';
      countryName.value = result.country ?? '';
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
    (data);
    (response.body.toString());
    if (response.statusCode == 200) {
      mapresult = jsonDecode(response.body)['predictions'];
    } else {
      snackBar("Problem while getting Location");
    }
  }

  //=========================================================== ADD STORE API ==============================================================================
  RxBool addStoreLoad = false.obs;
  Rx<AddStoreModel> addStoreMoodel = AddStoreModel().obs;

  Future<void> addSotreApi({
    required String storeName,
    required String storeDescription,
    required String address,
    required String lat,
    required String lon,
    required String categoryId,
    required String subCategoryId,
    // required String featured,
    required String employeeStrength,
    required String publishedMonth,
    required String publishedYear,
    String? countryCode,
    String? storePhone,
    String? storeEmail,
    String? storeSite,
    String? whatsapplink,
    String? facebooklink,
    String? instagramlink,
    String? twitterlink,
    String openDays = "",
    String closeDays = "",
    required String openTime,
    required String closeTime,
    List<String>? storeImages,
    List<String>? coverImages,
    String storeVideoThumbnail = "",
    String storeVideo = "",
  }) async {
    try {
      addStoreLoad(true);

      http.MultipartFile? thumbnailFile;
      http.MultipartFile? videoFile;

      if (storeVideo.isNotEmpty) {
        thumbnailFile = await http.MultipartFile.fromPath(
          'video_thumbnail',
          storeVideoThumbnail,
        );
        videoFile = await http.MultipartFile.fromPath('video', storeVideo);
      }

      List<http.MultipartFile> filesList = [];

      // Adding Store Images
      if (storeImages != null && storeImages.isNotEmpty) {
        for (String image in storeImages) {
          filesList.add(
            await http.MultipartFile.fromPath('service_images[]', image),
          );
        }
      }

      // Adding Cover Images
      if (coverImages != null && coverImages.isNotEmpty) {
        for (String image in coverImages) {
          filesList.add(
            await http.MultipartFile.fromPath('cover_image', image),
          );
        }
      }

      // Adding Video & Thumbnail
      if (thumbnailFile != null) filesList.add(thumbnailFile);
      if (videoFile != null) filesList.add(videoFile);

      final responseJson = await apiHelper.multipartPostMethod(
        url: apiHelper.addStoreUrl,
        formData: {
          "service_name": storeName,
          "service_description": storeDescription,
          "address": address,
          "lat": lat,
          "lon": lon,
          if (area.value.isNotEmpty) "area": area.value,
          if (city.value.isNotEmpty) "city": city.value,
          if (state.value.isNotEmpty) "state": state.value,
          if (countryName.value.isNotEmpty) "country": countryName.value,
          "category_id": categoryId,
          "subcategory_id": subCategoryId,
          // "is_featured": featured,
          "employee_strength": employeeStrength,
          "published_month": publishedMonth,
          "published_year": publishedYear,
          "service_country_code": countryCode ?? "",
          "service_phone": storePhone ?? "",
          "service_email": storeEmail ?? "",
          "service_website": storeSite ?? "",
          "instagram_link": instagramlink ?? "",
          "facebook_link": facebooklink ?? "",
          "whatsapp_link": whatsapplink ?? "",
          "twitter_link": twitterlink ?? "",
          "open_days": openDays,
          "closed_days": closeDays,
          "open_time": openTime,
          "close_time": closeTime,
        },

        files: filesList, // Using the prepared files list
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );

      addStoreMoodel.value = AddStoreModel.fromJson(responseJson);

      if (addStoreMoodel.value.status == true) {
        isStoreGlobal = 1;
        await SecurePrefs.setString(
          SecureStorageKeys.STORE_ID,
          addStoreMoodel.value.serviceId.toString(),
        );
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.STORE_ID: (v) => userStoreID = v!,
        });

        await SecurePrefs.setString(
          SecureStorageKeys.STORE_COUNTRY_CODE,
          countryCode.toString(),
        );

        await SecurePrefs.setString(
          SecureStorageKeys.STORE_MOBILE,
          storePhone.toString(),
        );

        getStoreDetailApi();
        businessPercentageApi();
        caategoryName.value = "";
        subCategoryNames.clear();
        openingAndClosingDays.clear();

        snackBar(
          languageController.textTranslate("Your Store added successfully"),
        );

        roleController.isVendorSelected();
        Get.offAll(() => TabbarScreen(currentIndex: 0));

        addStoreLoad(false);
      } else {
        addStoreLoad(false);
        snackBar(responseJson["message"]);
      }
    } catch (e) {
      addStoreLoad(false);
      snackBar("Somethig went wrong, try again");
    }
  }

  //================================================== STORE DETAIL API ===================================================================
  RxBool isLoading = false.obs;
  Rx<GetStoreDetailModel> storeDetailModel = GetStoreDetailModel().obs;
  RxList<ServiceDetails> storeList = <ServiceDetails>[].obs;

  Future<void> getStoreDetailApi() async {
    try {
      isLoading(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.vendorhome,
        formData: {},
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      storeDetailModel.value = GetStoreDetailModel.fromJson(response);
      storeList.clear();

      if (storeDetailModel.value.status == true) {
        storeList.addAll(storeDetailModel.value.serviceDetails!);
        SecurePrefs.setString(
          SecureStorageKeys.STORE_COUNTRY_CODE,
          storeList[0].contactDetails!.serviceCountryCode!,
        );
        SecurePrefs.setString(
          SecureStorageKeys.STORE_MOBILE,
          storeList[0].contactDetails!.servicePhone!,
        );
        isLoading(false);
      } else {
        storeList.clear();
        isLoading(false);
      }
    } catch (e) {
      storeList.clear();
      isLoading(false);
    }
  }

  //=============================================== UPDAE STORE ======================================================================================
  RxBool isUpdate = false.obs;
  Rx<UpdateStoreModel> updateModel = UpdateStoreModel().obs;

  // business name update
  Future<void> storeNameUpdateApi({
    required String storeName,
    required String storeDesc,
  }) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {
          "service_id": userStoreID,
          "service_name": storeName,
          "service_description": storeDesc,
        },
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        Get.back();
        snackBar(
          languageController.textTranslate("Your Business Details updated"),
        );
        storeList[0].businessDetails!.serviceName = storeName.toString();
        storeList[0].businessDetails!.serviceDescription = storeDesc.toString();
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store contact update api
  Future<void> storeCotactUpdateApi({
    required String countryCode,
    required String storePhone,
    required String storeEmail,
  }) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {
          "service_id": userStoreID,
          "service_country_code": countryCode,
          "service_phone": storePhone,
          "service_email": storeEmail,
        },
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        Get.back();
        snackBar("Your Business Contact Detail updated...!");
        storeList[0].contactDetails!.serviceCountryCode = countryCode
            .toString();
        storeList[0].contactDetails!.servicePhone = storePhone.toString();
        storeList[0].contactDetails!.serviceEmail = storeEmail.toString();
        SecurePrefs.setString(
          SecureStorageKeys.STORE_COUNTRY_CODE,
          countryCode,
        );
        SecurePrefs.setString(SecureStorageKeys.STORE_MOBILE, storePhone);
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store address update
  Future<void> storeAddressUpdateApi({
    required String address,
    required String lat,
    required String long,
  }) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {
          "service_id": userStoreID,
          "address": address,
          "lat": lat,
          "lon": long,
          if (area.value.isNotEmpty) "area": area.value,
          if (city.value.isNotEmpty) "city": city.value,
          if (state.value.isNotEmpty) "state": state.value,
          if (countryName.value.isNotEmpty) "country": countryName.value,
        },
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        Get.back();
        snackBar("Your Business Address updated...!");
        storeList[0].contactDetails!.address = address.toString();
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
        (updateModel.value.message.toString());
      }
    } catch (e) {
      isUpdate(false);
      (e.toString());
      snackBar("Something went wrong, try again");
    }
  }

  // store timing api
  Future<void> storeTimingsUpdateApi({
    required String openDays,
    required String closedDays,
    required String openTime,
    required String closeTime,
  }) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {
          "service_id": userStoreID,
          "open_days": openDays,
          "closed_days": closedDays,
          "open_time": openTime,
          "close_time": closeTime,
        },
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        openingAndClosingDays.clear();
        Get.back();

        snackBar("Your Business Timings updated...!");
        getStoreDetailApi();
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store month and years update
  Future<void> storeMonthYearsUpdateApi({
    required String month,
    required String years,
  }) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {
          "service_id": userStoreID,
          "published_month": month,
          "published_year": years,
        },
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        Get.back();
        snackBar("Your Business Detail updated...!");
        storeList[0].businessTime!.publishedMonth = month.toString();
        storeList[0].businessTime!.publishedYear = years.toString();
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store category and sub category
  Future<void> storeCategoryUpdateApi({
    required String categoryId,
    required String subCategoryId,
  }) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {
          "service_id": userStoreID,
          "category_id": categoryId,
          "subcategory_id": subCategoryId,
        },
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        Get.back();
        snackBar("Your Business Detail updated...!");
        // getStoreDetailApi();
        storeList[0].businessDetails!.categoryId = int.tryParse(categoryId);
        storeList[0].businessDetails!.subcategoryId = subCategoryId.toString();
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store emplyee
  Future<void> storeEmployeeUpdateApi({required String storeEmplyee}) async {
    try {
      isUpdate(true);
      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {
          "service_id": userStoreID,
          "employee_strength": storeEmplyee,
        },
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        Get.back();
        snackBar("Your Business Detail updated...!");
        storeList[0].businessTime!.employeeStrength = storeEmplyee.toString();
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store website update
  Future<void> storeWebSiteUpdateApi({required String storeWebSite}) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {"service_id": userStoreID, "service_website": storeWebSite},
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        Get.back();
        snackBar("Your Business Detail updated...!");
        storeList[0].contactDetails!.serviceWebsite = storeWebSite;
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store
  Future<void> storeSocialUpdateApi({
    String? whp,
    String? fc,
    String? insta,
    String? twitter,
  }) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {
          "service_id": userStoreID,
          "whatsapp_link": whp!,
          "facebook_link": fc!,
          "instagram_link": insta!,
          "twitter_link": twitter!,
        },
        files: [],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        isUpdate(false);
        Get.back();
        snackBar("Your Business Detail updated...!");
        storeList[0].contactDetails!.whatsappLink = whp.toString();
        storeList[0].contactDetails!.facebookLink = fc.toString();
        storeList[0].contactDetails!.instagramLink = insta.toString();
        storeList[0].contactDetails!.twitterLink = twitter.toString();
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store videos
  Future<void> storeVideoUpdateApi({
    String storeVideoThumbnail = "",
    String storeVideo = "",
  }) async {
    try {
      isUpdate(true);

      http.MultipartFile? thumbnailFile;
      http.MultipartFile? videoFile;
      if (storeVideo.isNotEmpty) {
        thumbnailFile = await http.MultipartFile.fromPath(
          'video_thumbnail',
          storeVideoThumbnail,
        );
        videoFile = await http.MultipartFile.fromPath('video', storeVideo);
      }

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {"service_id": userStoreID},
        files: [?thumbnailFile, ?videoFile],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        getStoreDetailApi();
        isUpdate(false);
        Get.back();
        snackBar("Your business video uploaded...!");
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  // store images update
  Future<void> storeIMAGEUpdateApi({List<String>? storeImages}) async {
    try {
      isUpdate(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.updateStore,
        formData: {"service_id": userStoreID},
        files: [
          if (storeImages!.length == 1)
            await http.MultipartFile.fromPath(
              'service_images[]',
              storeImages[0],
            )
          // Otherwise, iterate through the list of images.
          else
            for (String image in storeImages)
              await http.MultipartFile.fromPath('service_images[]', image),
        ],
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
      );
      updateModel.value = UpdateStoreModel.fromJson(response);

      if (updateModel.value.status == true) {
        getStoreDetailApi();
        isUpdate(false);
        Get.back();
        snackBar("Your Business Detail updated...!");
        storeDetailModel.refresh();
        storeList.refresh();
        businessPercentageApi();
      } else {
        isUpdate(false);
      }
    } catch (e) {
      isUpdate(false);
      snackBar("Something went wrong, try again");
    }
  }

  RxBool isRemoveImg = false.obs;

  Future<void> removeServiceImgApi({required String serviceIMGID}) async {
    isRemoveImg(true);
    final responseJson = await apiHelper.multipartPostMethod(
      url: apiHelper.imgRemove,
      formData: {"service_id": userStoreID, "service_image_id": serviceIMGID},
      files: [],
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      },
    );

    if (responseJson['status'] == true) {
      isRemoveImg(false);
    } else {
      isRemoveImg(false);
      (responseJson['message']);
    }
  }

  RxBool isPercent = false.obs;
  Future<void> businessPercentageApi() async {
    try {
      isPercent(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.totalpercentage,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': "Bearer $authToken",
        },
        formData: {},
        files: [],
      );

      if (response['status'] == true) {
        await SecurePrefs.setString(
          SecureStorageKeys.PERCENTAGE,
          response['percentage'].toString(),
        );
        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
          SecureStorageKeys.PERCENTAGE: (v) => percentageStore = v!,
        });
        isPercent(false);
      } else {
        isPercent(false);
        (response['status']);
      }
    } catch (e) {
      isPercent(false);
      ("TOTAL_PERCENTAG_ERROR:${e.toString()}");
    }
  }
}
