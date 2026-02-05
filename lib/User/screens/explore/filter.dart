// ignore_for_file: non_constant_identifier_names, must_be_immutable, use_build_context_synchronously, avoid_print, use_full_hex_values_for_flutter_colors
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/categories_contro.dart';
import 'package:nlytical/controllers/user_controllers/filter_contro.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/location.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:http/http.dart' as http;

class Filter extends StatefulWidget {
  String? catid;
  Filter({super.key, this.catid});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final LocationService locationService = LocationService();
  CategoriesContro catecontro = Get.find();
  FilterContro filtercontro = Get.find();
  bool isnavfilter = false;
  int page = 1;
  bool isLoadingMore = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_scrollListener);
      filtercontro.locationListApi("");
      filtercontro.circleRadius.value = 0.0;
      catecontro.cateApi();
    });
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
        page++;
      });
      fetchRestaurants();
    }
  }

  Future<void> fetchRestaurants() async {
    try {
      if (selectedRatting != null) {
        int ratingValue = int.parse(selectedRatting!.split(" ")[0]);

        filtercontro.selectedRating.value = ratingValue;
        await filtercontro.filterApi(rivstar: ratingValue);

        filtercontro.isnavfilter.value = true;

        Navigator.pop(context);
      }

      setState(() {
        isLoadingMore = false;
      });
    } catch (error) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchLocationCtrl.dispose();
    if (catecontro.subcatemodel.value!.subCategoryData != null) {
      catecontro.subcatemodel.value!.subCategoryData!.clear();
    }
    super.dispose();
  }

  TextEditingController searchLocationCtrl = TextEditingController();

  bool isvisible1 = true;
  bool isvisible2 = false;
  bool isvisible3 = false;
  int? selectedIndexType;
  int? selectedIndexRating;

  String? selectedType;
  List<String> itemListType = ["Featured"];

  List<String> itemListRating = [
    "1 Star",
    "2 Star",
    "3 Star",
    "4 Star",
    "5 Star",
  ];

  final String _sessionToken = "";
  List<Map<String, dynamic>> mapResult = [];
  List<Map<String, dynamic>> nearbyLocations = [];

  void onSearchChange() {
    String query = searchLocationCtrl.text.trim();

    if (query.isEmpty) {
      setState(() {
        mapResult.clear();
        mapResult = List.from(nearbyLocations);
      });
    } else {
      getsuggestion(query);
    }
  }

  void getsuggestion(String input) async {
    if (input.isEmpty) return;

    String kPlaceApiKey = googleMapKey;
    String baseURL =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseURL?input=$input&key=$kPlaceApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> predictions = jsonResponse['predictions'];

      List<Map<String, dynamic>> suggestionsWithDetails = [];

      for (var suggestion in predictions) {
        String placeId = suggestion['place_id'];
        String placeDetailsURL =
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kPlaceApiKey';

        var placeResponse = await http.get(Uri.parse(placeDetailsURL));
        if (placeResponse.statusCode == 200) {
          var placeDetails = jsonDecode(placeResponse.body);
          var addressComponents = placeDetails['result']['address_components'];

          String? state;
          String? country;

          for (var component in addressComponents) {
            List types = component['types'];
            if (types.contains('administrative_area_level_1')) {
              state = component['long_name'];
            }
            if (types.contains('country')) {
              country = component['long_name'];
            }
          }

          suggestionsWithDetails.add({
            'description': suggestion['description'],
            'state': state,
            'country': country,
          });
        }
      }

      setState(() {
        mapResult = suggestionsWithDetails;
      });
    } else {
      snackBar("Problem while getting Location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(12),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Filter"),
            style: AppTypography.h1(
              context,
            ).copyWith(color: Appcolors.appTextColor.textWhite),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: innerContainer(
        child: Column(
          children: [
            sizeBoxHeight(10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // ************************************* location, categories, sub-cat tab********************************************
                    AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: const Duration(seconds: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14.4,
                            offset: const Offset(2, 4),
                            spreadRadius: 0,
                            color: themeContro.isLightMode.value
                                ? Appcolors.grey300
                                : Appcolors.darkShadowColor,
                          ),
                        ],
                      ),
                      child: !isvisible1
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isvisible1 = !isvisible1;
                                      (isvisible1);
                                    });
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      isvisible1
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up_outlined,
                                      size: 30,
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                    ),
                                  ).paddingSymmetric(horizontal: 10),
                                ),
                                locaCatSubCat(
                                  title: languageController.textTranslate(
                                    "Location",
                                  ),
                                  img: AppAsstes.location1,
                                ),
                                const SizedBox(height: 10),
                                locaCatSubCat(
                                  title: languageController.textTranslate(
                                    "Categories",
                                  ),
                                  img: AppAsstes.category2,
                                ),
                                const SizedBox(height: 10),
                                locaCatSubCat(
                                  title: languageController.textTranslate(
                                    "Subcategories",
                                  ),
                                  img: AppAsstes.subcategory,
                                ),
                                const SizedBox(height: 10),
                              ],
                            )
                          : Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isvisible1 = !isvisible1;
                                      (isvisible1);
                                    });
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      isvisible1
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up_outlined,
                                      size: 30,
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                    ),
                                  ).paddingSymmetric(horizontal: 10),
                                ),
                                //================================          =========================================
                                //================================ LOCATION =========================================
                                //================================          =========================================
                                Obx(
                                  () => containerDesign(
                                    image: AppAsstes.location1,
                                    title: languageController.textTranslate(
                                      "Location",
                                    ),
                                    searchCtrl: searchLocationCtrl,
                                    onChanged: (value) async {
                                      setState(() {
                                        filtercontro.locationListApi(value);
                                      });
                                    },
                                    child: searchLocationCtrl.text.isEmpty
                                        ? Text(
                                            languageController.textTranslate(
                                              "Location not found",
                                            ),
                                            style: poppinsFont(
                                              12,
                                              Appcolors.brown,
                                              FontWeight.w500,
                                            ),
                                          ).paddingSymmetric(vertical: 50)
                                        : filtercontro.isLoad.value
                                        ? const CupertinoActivityIndicator()
                                              .paddingSymmetric(vertical: 40)
                                        : filtercontro.countriesList.isEmpty
                                        ? Text(
                                            languageController.textTranslate(
                                              "Location not found",
                                            ),
                                            style: poppinsFont(
                                              12,
                                              Appcolors.brown,
                                              FontWeight.w500,
                                            ),
                                          ).paddingSymmetric(vertical: 40)
                                        : ListView.builder(
                                            itemCount: filtercontro
                                                .countriesList
                                                .length,
                                            padding: const EdgeInsets.all(0),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              final locationName = filtercontro
                                                  .countriesList[index];
                                              final isSelected =
                                                  selectedLocation.isNotEmpty &&
                                                  selectedLocation.first ==
                                                      locationName;
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (selectedLocation
                                                        .contains(
                                                          locationName,
                                                        )) {
                                                      selectedLocation.clear();
                                                    } else {
                                                      selectedLocation.clear();
                                                      selectedLocation.add(
                                                        locationName,
                                                      );
                                                      searchLocationCtrl.text =
                                                          locationName;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          isSelected ? 5 : 0,
                                                        ),
                                                    color: isSelected
                                                        ? themeContro
                                                                  .isLightMode
                                                                  .value
                                                              ? Appcolors
                                                                    .appPriSecColor
                                                                    .appPrimblue
                                                                    .withValues(
                                                                      alpha:
                                                                          0.10,
                                                                    )
                                                              : Appcolors.black
                                                                    .withValues(
                                                                      alpha:
                                                                          0.30,
                                                                    )
                                                        : themeContro
                                                              .isLightMode
                                                              .value
                                                        ? Appcolors.white
                                                        : Colors.transparent,
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color:
                                                            (index !=
                                                                catecontro
                                                                        .catemodel
                                                                        .value!
                                                                        .data!
                                                                        .length -
                                                                    1)
                                                            ? themeContro
                                                                      .isLightMode
                                                                      .value
                                                                  ? Colors
                                                                        .grey
                                                                        .shade200
                                                                  : Appcolors
                                                                        .darkgray2
                                                            : Colors
                                                                  .transparent,
                                                      ),
                                                    ),
                                                  ),
                                                  child:
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          filtercontro
                                                              .countriesList[index]
                                                              .capitalizeFirst!,
                                                          style: poppinsFont(
                                                            12,
                                                            themeContro
                                                                    .isLightMode
                                                                    .value
                                                                ? Appcolors
                                                                      .black
                                                                : Appcolors
                                                                      .white,
                                                            isSelected
                                                                ? FontWeight
                                                                      .w600
                                                                : FontWeight
                                                                      .w500,
                                                          ),
                                                        ),
                                                      ).paddingSymmetric(
                                                        horizontal: 15,
                                                      ),
                                                ),
                                              ).paddingSymmetric(
                                                horizontal: 15,
                                              );
                                            },
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                //================================            =========================================
                                //================================ CATEGORIES =========================================
                                //================================            =========================================
                                Obx(
                                  () => containerDesign(
                                    image: AppAsstes.category2,
                                    title: languageController.textTranslate(
                                      "Categories",
                                    ),
                                    searchCtrl: catecontro.searchCategoriesCtrl,
                                    onChanged: (p0) {
                                      setState(() {
                                        catecontro.filterSearchPeople();
                                      });
                                    },
                                    child:
                                        catecontro
                                            .catemodel
                                            .value!
                                            .data!
                                            .isNotEmpty
                                        ? ListView.builder(
                                            itemCount: catecontro
                                                .catemodel
                                                .value!
                                                .data!
                                                .length,
                                            padding: const EdgeInsets.all(0),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              final categoryName = catecontro
                                                  .catemodel
                                                  .value!
                                                  .data![index]
                                                  .categoryName!;
                                              final categoryId = catecontro
                                                  .catemodel
                                                  .value!
                                                  .data![index]
                                                  .id!
                                                  .toString();
                                              final isSelected =
                                                  selectedServicesName
                                                      .isNotEmpty &&
                                                  selectedServicesName.first ==
                                                      categoryName;
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedServicesName
                                                        .clear();
                                                    selectedServices.clear();

                                                    selectedServicesName.add(
                                                      categoryName,
                                                    );
                                                    selectedServices.add(
                                                      categoryId,
                                                    );
                                                    catecontro
                                                            .searchCategoriesCtrl
                                                            .text =
                                                        categoryName;
                                                    catecontro.subcateApi(
                                                      catId: selectedServices
                                                          .first,
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          isSelected ? 5 : 0,
                                                        ),
                                                    color: isSelected
                                                        ? themeContro
                                                                  .isLightMode
                                                                  .value
                                                              ? Appcolors
                                                                    .appPriSecColor
                                                                    .appPrimblue
                                                                    .withValues(
                                                                      alpha:
                                                                          0.10,
                                                                    )
                                                              : Appcolors.black
                                                                    .withValues(
                                                                      alpha:
                                                                          0.30,
                                                                    )
                                                        : themeContro
                                                              .isLightMode
                                                              .value
                                                        ? Appcolors.white
                                                        : Colors.transparent,
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color:
                                                            (index !=
                                                                catecontro
                                                                        .catemodel
                                                                        .value!
                                                                        .data!
                                                                        .length -
                                                                    1)
                                                            ? themeContro
                                                                      .isLightMode
                                                                      .value
                                                                  ? Colors
                                                                        .grey
                                                                        .shade200
                                                                  : Appcolors
                                                                        .darkgray2
                                                            : Colors
                                                                  .transparent,
                                                      ),
                                                    ),
                                                  ),
                                                  child:
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          catecontro
                                                              .catemodel
                                                              .value!
                                                              .data![index]
                                                              .categoryName!
                                                              .capitalizeFirst!,
                                                          style: poppinsFont(
                                                            12,
                                                            themeContro
                                                                    .isLightMode
                                                                    .value
                                                                ? Appcolors
                                                                      .black
                                                                : Appcolors
                                                                      .white,
                                                            isSelected
                                                                ? FontWeight
                                                                      .w600
                                                                : FontWeight
                                                                      .w500,
                                                          ),
                                                        ),
                                                      ).paddingSymmetric(
                                                        horizontal: 15,
                                                      ),
                                                ).paddingSymmetric(horizontal: 15),
                                              );
                                            },
                                          ).paddingSymmetric(vertical: 5)
                                        : Center(
                                            child: Text(
                                              languageController.textTranslate(
                                                "Category Not found",
                                              ),
                                              style: poppinsFont(
                                                12,
                                                Appcolors.brown,
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                //================================                =========================================
                                //================================ SUB CATEGORIES =========================================
                                //================================                =========================================
                                Obx(
                                  () => containerDesign(
                                    image: AppAsstes.subcategory,
                                    title: languageController.textTranslate(
                                      "Subcategories",
                                    ),
                                    searchCtrl:
                                        catecontro.searchSubCategoriesCtrl,
                                    onChanged: (p0) {
                                      setState(() {
                                        catecontro.filterSearchSubCate();
                                      });
                                    },
                                    child:
                                        catecontro.issubcat.value ||
                                            catecontro
                                                    .subcatemodel
                                                    .value!
                                                    .subCategoryData ==
                                                null
                                        ? Text(
                                            languageController.textTranslate(
                                              "Subcategory Not found",
                                            ),
                                            style: poppinsFont(
                                              12,
                                              Appcolors.brown,
                                              FontWeight.w500,
                                            ),
                                          ).paddingSymmetric(vertical: 40)
                                        : catecontro
                                              .subcatemodel
                                              .value!
                                              .subCategoryData!
                                              .isEmpty
                                        ? Text(
                                            languageController.textTranslate(
                                              "Subcategory Not found",
                                            ),
                                            style: poppinsFont(
                                              12,
                                              Appcolors.brown,
                                              FontWeight.w500,
                                            ),
                                          ).paddingSymmetric(vertical: 40)
                                        : ListView.builder(
                                            itemCount: catecontro
                                                .subcatemodel
                                                .value!
                                                .subCategoryData!
                                                .length,
                                            padding: const EdgeInsets.all(0),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              final categorySubName = catecontro
                                                  .subcatemodel
                                                  .value!
                                                  .subCategoryData![index]
                                                  .subcategoryName!;
                                              final categorySubId = catecontro
                                                  .subcatemodel
                                                  .value!
                                                  .subCategoryData![index]
                                                  .id!
                                                  .toString();
                                              final isSelected =
                                                  selectedSubServicesName
                                                      .isNotEmpty &&
                                                  selectedSubServicesName
                                                          .first ==
                                                      categorySubName;
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedSubServicesName
                                                        .clear();
                                                    selectedSubServices.clear();

                                                    selectedSubServicesName.add(
                                                      categorySubName,
                                                    );
                                                    catecontro
                                                            .searchSubCategoriesCtrl
                                                            .text =
                                                        categorySubName;
                                                    selectedSubServices.add(
                                                      categorySubId,
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          isSelected ? 5 : 0,
                                                        ),
                                                    color: isSelected
                                                        ? themeContro
                                                                  .isLightMode
                                                                  .value
                                                              ? Appcolors
                                                                    .appPriSecColor
                                                                    .appPrimblue
                                                                    .withValues(
                                                                      alpha:
                                                                          0.10,
                                                                    )
                                                              : Appcolors.black
                                                                    .withValues(
                                                                      alpha:
                                                                          0.30,
                                                                    )
                                                        : themeContro
                                                              .isLightMode
                                                              .value
                                                        ? Appcolors.white
                                                        : Colors.transparent,
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color:
                                                            (index !=
                                                                catecontro
                                                                        .subcatemodel
                                                                        .value!
                                                                        .subCategoryData!
                                                                        .length -
                                                                    1)
                                                            ? themeContro
                                                                      .isLightMode
                                                                      .value
                                                                  ? Colors
                                                                        .grey
                                                                        .shade200
                                                                  : Appcolors
                                                                        .darkgray2
                                                            : Colors
                                                                  .transparent,
                                                      ),
                                                    ),
                                                  ),
                                                  child:
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          catecontro
                                                              .subcatemodel
                                                              .value!
                                                              .subCategoryData![index]
                                                              .subcategoryName!
                                                              .capitalizeFirst!,
                                                          style: poppinsFont(
                                                            12,
                                                            themeContro
                                                                    .isLightMode
                                                                    .value
                                                                ? Appcolors
                                                                      .black
                                                                : Appcolors
                                                                      .white,
                                                            isSelected
                                                                ? FontWeight
                                                                      .w600
                                                                : FontWeight
                                                                      .w500,
                                                          ),
                                                        ),
                                                      ).paddingSymmetric(
                                                        horizontal: 15,
                                                      ),
                                                ).paddingSymmetric(horizontal: 15),
                                              );
                                            },
                                          ).paddingSymmetric(vertical: 5),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                    ).paddingSymmetric(horizontal: 10),
                    const SizedBox(height: 20),
                    //================================       =========================================
                    //================================ PRICE =========================================
                    //================================       =========================================
                    priceIndicator(),
                    const SizedBox(height: 20),
                    //================================        =========================================
                    //================================ RATING =========================================
                    //================================        =========================================
                    starDesign(
                      title: languageController.textTranslate("Rating"),
                      isonOffArrow: isvisible3,
                      onTap: () {
                        setState(() {
                          isvisible3 = !isvisible3;
                        });
                      },
                      child: ListView.builder(
                        itemCount: itemListRating.length,
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedIndexRating == index + 1;
                          return Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                isSelected ? 5 : 0,
                              ),
                              color: isSelected
                                  ? themeContro.isLightMode.value
                                        ? Appcolors.grey200
                                        : Appcolors.darkgray2
                                  : themeContro.isLightMode.value
                                  ? Appcolors.white
                                  : Appcolors.appBgColor.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: (index != itemListRating.length - 1)
                                      ? themeContro.isLightMode.value
                                            ? Appcolors.grey200
                                            : Appcolors.darkgray2
                                      : Appcolors.appBgColor.transparent,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedIndexRating == index + 1) {
                                    selectedIndexRating = null;
                                  } else {
                                    selectedIndexRating = index + 1;
                                  }
                                  ("RatingStar: $selectedIndexRating");
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Appcolors
                                            .appPriSecColor
                                            .appPrimblue,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedIndexRating == index + 1
                                            ? Appcolors
                                                  .appPriSecColor
                                                  .appPrimblue
                                            : Appcolors.appBgColor.transparent,
                                      ),
                                    ).paddingAll(2),
                                  ),
                                  sizeBoxWidth(10),
                                  Text(
                                    itemListRating[index],
                                    style: poppinsFont(
                                      12,
                                      themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                      selectedIndexRating == index + 1
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(vertical: 12),
                            ),
                          ).paddingSymmetric(horizontal: 20);
                        },
                      ).paddingSymmetric(vertical: 10),
                    ),
                  ],
                ).paddingOnly(bottom: 25),
              ),
            ),
            // const SizedBox(height: 25)
            Obx(() {
              return filtercontro.isfilter.value
                  ? commonLoading()
                  : CustomButtom(
                      title: languageController.textTranslate("Apply"),
                      onPressed: () {
                        if (selectedLocation.isEmpty &&
                            selectedServicesName.isEmpty &&
                            selectedSubServicesName.isEmpty &&
                            (selectedType?.isEmpty ?? true) &&
                            filtercontro.circleRadius.value == 0 &&
                            selectedIndexRating == null) {
                          snackBar(
                            languageController.textTranslate(
                              "Please select someone for the filter",
                            ),
                          );
                        } else {
                          filtercontro.isnavfilter.value = false;
                          filtercontro.filterApi(
                            location: selectedLocation.isNotEmpty
                                ? selectedLocation.first
                                : "",
                            catId: selectedServices.isNotEmpty
                                ? selectedServices.first
                                : "",
                            catName: selectedServicesName.isNotEmpty
                                ? selectedServicesName.first
                                : "",
                            subCatId: selectedSubServices.isNotEmpty
                                ? selectedSubServices.first
                                : "",
                            subCatName: selectedSubServicesName.isNotEmpty
                                ? selectedSubServicesName.first
                                : "",
                            type: selectedType ?? "",
                            price: filtercontro.circleRadius.round().toString(),
                            rivstar: selectedIndexRating,
                          );
                        }
                      },
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 45,
                      width: Get.width,
                    ).paddingSymmetric(horizontal: 30);
            }),
            const SizedBox(height: 27),
          ],
        ),
      ),
    );
  }

  containerDesign({
    required String image,
    required String title,
    required TextEditingController searchCtrl,
    required Function(String) onChanged,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkgray1,
        border: Border.all(
          color: themeContro.isLightMode.value
              ? Appcolors.grey300
              : const Color(0xff0000001a),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 45,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: themeContro.isLightMode.value
                  ? Appcolors.white
                  : Appcolors.darkgray2,
              border: Border.all(
                color: themeContro.isLightMode.value
                    ? Appcolors.grey300
                    : Appcolors.darkGray,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  height: 16,
                  color: themeContro.isLightMode.value
                      ? Appcolors.black
                      : Appcolors.darkgray3,
                ),
                const SizedBox(width: 5),
                label(
                  title,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textColor: themeContro.isLightMode.value
                      ? Appcolors.black
                      : Appcolors.darkgray3,
                ),
              ],
            ).paddingSymmetric(horizontal: 10),
          ).paddingSymmetric(horizontal: 10),
          const SizedBox(height: 10),
          searchBar(
            searchCtrl: searchCtrl,
            onChanged: onChanged,
          ).paddingSymmetric(horizontal: 12),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: child,
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  Widget searchBar({
    required TextEditingController searchCtrl,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: 40,
      child: TextField(
        controller: searchCtrl,
        onChanged: onChanged,
        style: poppinsFont(
          13,
          themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
          FontWeight.w500,
        ),
        cursorColor: themeContro.isLightMode.value
            ? Appcolors.appPriSecColor.appPrimblue
            : Appcolors.white,
        readOnly: false,
        decoration: InputDecoration(
          fillColor: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeContro.isLightMode.value
                  ? Appcolors.bluee4
                  : Appcolors.darkGray,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeContro.isLightMode.value
                  ? Appcolors.bluee4
                  : Appcolors.darkGray,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolors.greyColor, width: 5),
          ),
          hintText: languageController.textTranslate("Search..."),
          hintStyle: poppinsFont(
            13,
            themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
            FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 11, top: 11),
            child: Image.asset(
              AppAsstes.search,
              color: Appcolors.appPriSecColor.appPrimblue,
              height: 10,
            ),
          ),
        ),
      ).paddingSymmetric(horizontal: 10),
    );
  }

  priceIndicator() {
    return Container(
      height: Get.height / 6,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkGray,
        boxShadow: [
          BoxShadow(
            blurRadius: 14.4,
            offset: const Offset(2, 4),
            spreadRadius: 0,
            color: themeContro.isLightMode.value
                ? Appcolors.grey300
                : Appcolors.darkShadowColor,
          ),
        ],
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Image.asset(
                      AppAsstes.doller,
                      height: 20,
                      color: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                    ),
                  ),
                  TextSpan(
                    text:
                        "  ${languageController.textTranslate("Pricing Filter")}",
                    style: poppinsFont(
                      13,
                      themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Appcolors.appPriSecColor.appPrimblue,
                inactiveTrackColor: const Color.fromRGBO(155, 155, 155, 1),
                thumbColor: Appcolors.appPriSecColor.appPrimblue,
                overlayColor: Appcolors.appPriSecColor.appPrimblue.withValues(
                  alpha: 0.2,
                ),
                valueIndicatorColor: Appcolors.appPriSecColor.appPrimblue,
              ),
              child: Slider(
                value: filtercontro.circleRadius.toDouble(),
                min: filtercontro.minPrice.value,
                max: filtercontro.maxPrice.value,
                divisions:
                    (filtercontro.maxPrice.value -
                        filtercontro.minPrice.value) ~/
                    100,
                onChanged: (double value) {
                  setState(() {
                    filtercontro.circleRadius.value = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                label(
                  '\$0',
                  style: TextStyle(
                    color: Appcolors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                label(
                  "\$${filtercontro.circleRadius.value.toStringAsFixed(0)}",
                  style: TextStyle(
                    color: Appcolors.appPriSecColor.appPrimblue,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                label(
                  "\$10000",
                  style: TextStyle(
                    color: Appcolors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 10),
          ],
        ).paddingAll(20);
      }),
    ).paddingSymmetric(horizontal: 10);
  }

  InkWell starDesign({
    required String title,
    required bool isonOffArrow,
    required Function() onTap,
    required Widget child,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          boxShadow: [
            BoxShadow(
              blurRadius: 14.4,
              offset: const Offset(2, 4),
              spreadRadius: 0,
              color: themeContro.isLightMode.value
                  ? Appcolors.grey300
                  : Appcolors.darkShadowColor,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.darkgray2,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 14.4,
                    offset: const Offset(2, 4),
                    spreadRadius: 0,
                    color: themeContro.isLightMode.value
                        ? Appcolors.grey300
                        : Appcolors.darkShadowColor,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AppAsstes.Star_border,
                        height: 20,
                        color: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        title,
                        style: poppinsFont(
                          13.5,
                          themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.white,
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isonOffArrow
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up_outlined,
                    color: themeContro.isLightMode.value
                        ? Appcolors.black
                        : Appcolors.white,
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),
            isonOffArrow
                ? ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: child,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ).paddingSymmetric(horizontal: 10),
    );
  }

  Set<String> selectedServices = {};
  Set<String> selectedServicesName = {};

  Set<String> selectedSubServices = {};
  Set<String> selectedSubServicesName = {};
  Set<String> selectedLocation = {};

  String? selectedRatting;

  Widget locaCatSubCat({required String title, required String img}) {
    return Container(
      height: 45,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: themeContro.isLightMode.value
              ? Appcolors.grey300
              : Appcolors.grey1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            img,
            height: 15,
            color: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
          ),
          const SizedBox(width: 5),
          label(
            title,
            fontSize: 12,
            textColor: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            fontWeight: FontWeight.w600,
          ),
        ],
      ).paddingSymmetric(horizontal: 10),
    ).paddingSymmetric(horizontal: 10);
  }
}
