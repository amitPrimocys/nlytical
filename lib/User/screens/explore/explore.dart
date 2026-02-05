// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, deprecated_member_use, must_be_immutable, unnecessary_brace_in_string_interps, unused_local_variable, unused_import, invalid_use_of_protected_member, avoid_print, unnecessary_null_comparison

import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/filter_contro.dart';
import 'package:nlytical/controllers/user_controllers/home_contro.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/controllers/user_controllers/nearby_contro.dart';
import 'package:nlytical/User/screens/explore/filter.dart';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:nlytical/User/screens/shimmer_loader/favourite_loader.dart';
import 'package:nlytical/User/screens/shimmer_loader/nearby_loader.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_screen.dart';
import 'package:nlytical/utils/comman_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => ExploreState();
}

class ExploreState extends State<Explore> {
  LikeContro likecontro = Get.find();
  FilterContro filtercontro = Get.find();
  HomeContro homecontro = Get.find();
  bool isLoadingMore = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filtercontro.scrollControllerlocation = ScrollController();
      filtercontro.filterApiAll().then((_) {
        filtercontro.addMarker1();
        addMarker();
      });
      scrollController.addListener(_scrollListener);
      if (mounted) {
        setState(() {});
      }
    });
  }

  GoogleMapController? _mapController;

  Future<void> _setMapStyleLight() async {
    final style = await rootBundle.loadString('assets/map_styles/map.json');
    _mapController?.setMapStyle(style);
  }

  Future<void> _setMapStyleDark() async {
    String style = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/dark_map.json');
    _mapController?.setMapStyle(style);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (filtercontro.serviceFilte.length % 20 == 0 &&
          !filtercontro.isfilter.value) {
        filtercontro.filterApiAll(isAddData: true);
      }
    }
  }

  @override
  dispose() {
    scrollController.dispose();
    filtercontro.isnavfilter.value = false;
    super.dispose();
  }

  Position? currentPosition;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkMainBlack,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            centerTitle: true,
            title: Text(
              languageController.textTranslate("Explore"),
              style: poppinsFont(20, Appcolors.white, FontWeight.w500),
            ),
            flexibleSpace: flexibleSpace(),
            backgroundColor: Appcolors.appBgColor.transparent,
            shadowColor: Appcolors.appBgColor.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(() => Filter());
                },
                child: Image.asset(
                  'assets/images/menu1.png',
                  color: Appcolors.white,
                  height: 24,
                ),
              ).paddingOnly(right: 20),
            ],
          ),
        ),
        body: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: Appcolors.appPriSecColor.appPrimblue,
          ),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: themeContro.isLightMode.value
                  ? Appcolors.white
                  : Appcolors.darkMainBlack,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                sizeBoxHeight(12),
                Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 6.7,
                        color: Appcolors.black.withValues(alpha: 0.14),
                      ),
                    ],
                  ),
                  child: Column(children: [profiletab()]),
                ).paddingSymmetric(horizontal: 10),
                sizeBoxHeight(10),
                Obx(() {
                  return filtercontro.isnavfilter.value
                      ? Column(children: [filter_clear(), sizeBoxHeight(15)])
                      : SizedBox.shrink();
                }),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Obx(() {
                        return filtercontro.isnavfilter.value
                            ? filterlisting()
                            : filterlisting();
                      }),
                      Obx(() {
                        return filtercontro.isnavfilter.value
                            ? userID.isEmpty
                                  ? explore_empty()
                                  : location_()
                            : userID.isEmpty
                            ? explore_empty()
                            : location();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profiletab() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeContro.isLightMode.value
                  ? Appcolors.white
                  : Appcolors.darkGray,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: themeContro.isLightMode.value
                      ? Appcolors.grey100
                      : Appcolors.darkShadowColor,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: const Offset(1.0, 1.0),
                ),
              ],
            ),
            child: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Appcolors.appBgColor.transparent,
                ),
                insets: EdgeInsets.symmetric(horizontal: 2.0),
              ),
              dividerColor: Appcolors.appBgColor.transparent,
              labelColor: Appcolors.appPriSecColor.appPrimblue,
              unselectedLabelColor: Appcolors.grey,
              unselectedLabelStyle: TextStyle(
                color: Appcolors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              labelStyle: TextStyle(
                color: Appcolors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              indicatorColor: Appcolors.appPriSecColor.appPrimblue,
              indicatorSize: TabBarIndicatorSize.label,

              tabs: [
                Tab(
                  child: Text(
                    '   ${languageController.textTranslate("Listing")}   ',
                  ),
                ),
                Tab(
                  child: Text(
                    '    ${languageController.textTranslate("Location")}    ',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------filter list ------------------------------------------------------------
  // -----------------------------------------------------------filter list ------------------------------------------------------------
  // -----------------------------------------------------------filter list ------------------------------------------------------------

  Widget filterlisting() {
    if (filtercontro.isfilter.value && filtercontro.serviceFilte.isEmpty) {
      return nearbyListLoader(context);
    } else if (filtercontro.serviceFilte.isEmpty) {
      return explore_empty();
    }
    return GridView.builder(
      itemCount: calculateItemCount(filtercontro.serviceFilte.length, 20),
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      controller: scrollController,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        if (index < filtercontro.serviceFilte.length) {
          return CommanScreen(
            lat: filtercontro.serviceFilte[index].lat ?? "0.0",
            lon: filtercontro.serviceFilte[index].lon ?? "0.0",
            storeImages: filtercontro.serviceFilte[index].serviceImages![0]
                .toString(),
            sname: filtercontro.serviceFilte[index].serviceName!.capitalizeFirst
                .toString(),
            cname: filtercontro
                .serviceFilte[index]
                .categoryName!
                .capitalizeFirst
                .toString(),
            vname: filtercontro.serviceFilte[index].firstName.toString(),
            vendorImages: filtercontro.serviceFilte[index].image.toString(),
            isfeatured: filtercontro.serviceFilte[index].isFeatured ?? 0,
            ratingCount:
                filtercontro.serviceFilte[index].averageReviewStar!.isEmpty
                ? 0.00
                : double.parse(
                    filtercontro.serviceFilte[index].averageReviewStar!,
                  ),
            avrageReview: filtercontro.serviceFilte[index].totalReviewCount
                .toString(),
            isLike: userID.isEmpty
                ? 0
                : filtercontro.serviceFilte[index].isLike!,
            onTaplike: () {
              if (userID.isEmpty) {
                snackBar('Please login to like this service');
                loginPopup(bottomsheetHeight: Get.height * 0.95);
              } else {
                likecontro.likeApi(
                  filtercontro.serviceFilte[index].id.toString(),
                );
                setState(() {
                  filtercontro.serviceFilte[index].isLike =
                      filtercontro.serviceFilte[index].isLike == 0 ? 1 : 0;
                });
              }
            },
            onTapstore: () {
              Get.to(
                Details(
                  serviceid: filtercontro.serviceFilte[index].id.toString(),
                  isVendorService: false,
                ),
                transition: Transition.rightToLeft,
              );
            },
            location: filtercontro.serviceFilte[index].address.toString(),
            price: filtercontro.serviceFilte[index].priceRange!,
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Appcolors.grey300,
            highlightColor: Appcolors.grey100,
            child: Card(
              color: Appcolors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    ).paddingSymmetric(horizontal: 15, vertical: 5);
  }

  Widget filter_clear() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 270,
          height: 30,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // ********************** CATEGORY *************************************
                filtercontro.selectedCategories.isNotEmpty &&
                        filtercontro.selectedCategories.isNotEmpty &&
                        filtercontro.selectedCategories.value != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          onTap: () {
                            filtercontro.cateClearMethod();
                          },
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: themeContro.isLightMode.value
                                  ? Appcolors.white
                                  : Appcolors.darkMainBlack,
                              border: Border.all(
                                color: themeContro.isLightMode.value
                                    ? Appcolors.appPriSecColor.appPrimblue
                                    : Appcolors.white,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  sizeBoxWidth(10),
                                  SizedBox(
                                    child: label(
                                      filtercontro
                                              .selectedCategories
                                              .value
                                              .isNotEmpty
                                          ? filtercontro
                                                .selectedCategories
                                                .value
                                          : 'No Category Selected',
                                      fontSize: 10,
                                      maxLines: 2,
                                      textColor: themeContro.isLightMode.value
                                          ? Appcolors.appTextColor.textBlack
                                          : Appcolors.appTextColor.textWhite,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  sizeBoxWidth(10),
                                  Icon(
                                    Icons.close,
                                    size: 10,
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.black
                                        : Appcolors.white,
                                  ),
                                  sizeBoxWidth(10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                // ***************** SUB - CATEGORY ******************************
                filtercontro.selectedSubCate.isNotEmpty &&
                        filtercontro.selectedSubCate.isNotEmpty &&
                        filtercontro.selectedSubCate.value != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          onTap: () {
                            filtercontro.subCatClearMetohd();
                          },
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: themeContro.isLightMode.value
                                  ? Appcolors.white
                                  : Appcolors.darkMainBlack,
                              border: Border.all(
                                color: themeContro.isLightMode.value
                                    ? Appcolors.appPriSecColor.appPrimblue
                                    : Appcolors.white,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  sizeBoxWidth(10),
                                  SizedBox(
                                    child: label(
                                      filtercontro
                                              .selectedSubCate
                                              .value
                                              .isNotEmpty
                                          ? filtercontro.selectedSubCate.value
                                          : 'No Subcategory Selected',
                                      fontSize: 10,
                                      maxLines: 2,
                                      textColor: themeContro.isLightMode.value
                                          ? Appcolors.appTextColor.textBlack
                                          : Appcolors.appTextColor.textWhite,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  sizeBoxWidth(10),
                                  Icon(
                                    Icons.close,
                                    size: 10,
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.black
                                        : Appcolors.white,
                                  ),
                                  sizeBoxWidth(10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                filtercontro.selectedSubCate.isNotEmpty &&
                        filtercontro.selectedSubCate.isNotEmpty
                    ? sizeBoxHeight(10)
                    : SizedBox.shrink(),
                filtercontro.selectedRating.value > 0
                    ? InkWell(
                        onTap: () {
                          filtercontro.ratingClearMethod();
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: themeContro.isLightMode.value
                                ? Appcolors.white
                                : Appcolors.darkMainBlack,
                            border: Border.all(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appPriSecColor.appPrimblue
                                  : Appcolors.white,
                            ),
                          ),
                          child: Row(
                            children: [
                              label(
                                filtercontro.selectedRating.value > 0
                                    ? '${filtercontro.selectedRating.value} Star'
                                    : 'No Rating Selected',
                                fontSize: 10,
                                textColor: themeContro.isLightMode.value
                                    ? Appcolors.appTextColor.textBlack
                                    : Appcolors.appTextColor.textWhite,
                                fontWeight: FontWeight.w400,
                              ),
                              sizeBoxWidth(10),
                              Icon(
                                Icons.close,
                                size: 10,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 10),
                        ),
                      )
                    : SizedBox.shrink(),
                filtercontro.selectedRating.value > 0
                    ? sizeBoxWidth(10)
                    : SizedBox.shrink(),
                filtercontro.selectedPrice.value > 0
                    ? InkWell(
                        onTap: () {
                          filtercontro.priceClearMethod();
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: themeContro.isLightMode.value
                                ? Appcolors.white
                                : Appcolors.darkMainBlack,
                            border: Border.all(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appPriSecColor.appPrimblue
                                  : Appcolors.white,
                            ),
                          ),
                          child: Row(
                            children: [
                              label(
                                '${filtercontro.selectedPrice.value} Price',
                                fontSize: 10,
                                textColor: themeContro.isLightMode.value
                                    ? Appcolors.appTextColor.textBlack
                                    : Appcolors.appTextColor.textWhite,
                                fontWeight: FontWeight.w400,
                              ),
                              sizeBoxWidth(10),
                              Icon(
                                Icons.close,
                                size: 10,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 10),
                        ),
                      )
                    : SizedBox.shrink(),
                filtercontro.selectedLocation.isNotEmpty &&
                        filtercontro.selectedLocation.isNotEmpty
                    ? sizeBoxWidth(10)
                    : SizedBox.shrink(),
                filtercontro.selectedLocation.isNotEmpty &&
                        filtercontro.selectedLocation.isNotEmpty &&
                        filtercontro.selectedLocation != null
                    ? InkWell(
                        onTap: () {
                          filtercontro.locationClearMethod();
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: themeContro.isLightMode.value
                                ? Appcolors.white
                                : Appcolors.darkMainBlack,
                            border: Border.all(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appPriSecColor.appPrimblue
                                  : Appcolors.white,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                sizeBoxWidth(10),
                                SizedBox(
                                  child: label(
                                    filtercontro.selectedLocation.value,
                                    fontSize: 10,
                                    maxLines: 2,
                                    textColor: themeContro.isLightMode.value
                                        ? Appcolors.appTextColor.textBlack
                                        : Appcolors.appTextColor.textWhite,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                sizeBoxWidth(10),
                                Icon(
                                  Icons.close,
                                  size: 10,
                                  color: themeContro.isLightMode.value
                                      ? Appcolors.black
                                      : Appcolors.white,
                                ),
                                sizeBoxWidth(10),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            filtercontro.isnavfilter.value = false;
            filtercontro.filterApiAll();
          },
          child: label(
            'Clear All',
            fontSize: 10,
            textColor: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  // -----------------------------------------------------------location list -----------------------------------------------------------

  Widget location_filter() {
    return filtercontro.isfilter.value
        ? Center(
            child: CupertinoActivityIndicator(
              color: Appcolors.appPriSecColor.appPrimblue,
            ),
          )
        : filtercontro.filtermodel.value!.serviceFilter!.isNotEmpty
        ? SizedBox(
            height: getProportionateScreenHeight(180),
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.darkMainBlack,
                borderRadius: BorderRadius.only(
                  topLeft: ui.Radius.circular(15),
                  topRight: ui.Radius.circular(15),
                ),
              ),
              child: ListView.builder(
                controller: filtercontro.scrollControllerlocation,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount:
                    filtercontro.filtermodel.value!.serviceFilter!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      sizeBoxHeight(25),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            Details(
                              serviceid: filtercontro
                                  .filtermodel
                                  .value!
                                  .serviceFilter![index]
                                  .id
                                  .toString(),
                              isVendorService: false,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Container(
                          height: getProportionateScreenHeight(120),
                          width: Get.width * 0.90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeContro.isLightMode.value
                                ? Appcolors.white
                                : Appcolors.darkGray,
                            border: Border.all(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.grey300
                                  : Appcolors.black.withOpacity(0.8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: getProportionateScreenHeight(120),
                                width: getProportionateScreenWidth(130),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(9),
                                    bottomLeft: Radius.circular(9),
                                  ),
                                  border: Border.all(
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.grey300
                                        : Appcolors.black.withOpacity(0.8),
                                  ),
                                  image: DecorationImage(
                                    onError: (exception, stackTrace) {
                                      Icon(Icons.error);
                                    },
                                    image: NetworkImage(
                                      filtercontro
                                          .filtermodel
                                          .value!
                                          .serviceFilter![index]
                                          .serviceImages![0]
                                          .toString(),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sizeBoxHeight(3),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      sizeBoxWidth(10),
                                      Container(
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Appcolors
                                              .appPriSecColor
                                              .appPrimblue,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            width: 55,
                                            child: label(
                                              filtercontro
                                                  .filtermodel
                                                  .value!
                                                  .serviceFilter![index]
                                                  .categoryName
                                                  .toString(),
                                              style: TextStyle(
                                                color: Appcolors.white,
                                                fontSize: 8,
                                              ),
                                            ).paddingOnly(left: 4, right: 4),
                                          ),
                                        ),
                                      ),
                                      sizeBoxWidth(130),
                                      GestureDetector(
                                        onTap: () {
                                          if (userID.isEmpty) {
                                            snackBar(
                                              'Please login to like this service',
                                            );
                                            loginPopup(
                                              bottomsheetHeight:
                                                  Get.height * 0.95,
                                            );
                                          } else {
                                            likecontro.likeApi(
                                              filtercontro
                                                  .filtermodel
                                                  .value!
                                                  .serviceFilter![index]
                                                  .id
                                                  .toString(),
                                            );
                                            setState(() {
                                              filtercontro
                                                      .filtermodel
                                                      .value!
                                                      .serviceFilter![index]
                                                      .isLike =
                                                  filtercontro
                                                          .filtermodel
                                                          .value!
                                                          .serviceFilter![index]
                                                          .isLike ==
                                                      0
                                                  ? 1
                                                  : 0;
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 26,
                                          width: 26,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Appcolors
                                                .appPriSecColor
                                                .appPrimblue
                                                .withValues(alpha: 0.10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child:
                                                filtercontro
                                                        .filtermodel
                                                        .value!
                                                        .serviceFilter![index]
                                                        .isLike ==
                                                    0
                                                ? Image.asset(
                                                    AppAsstes.heart,
                                                    color:
                                                        themeContro
                                                            .isLightMode
                                                            .value
                                                        ? Appcolors.black
                                                        : Appcolors.grey1,
                                                  )
                                                : Image.asset(
                                                    AppAsstes.fill_heart,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.5,
                                    child: label(
                                      filtercontro
                                          .filtermodel
                                          .value!
                                          .serviceFilter![index]
                                          .serviceName
                                          .toString(),
                                      fontSize: 11,
                                      maxLines: 1,
                                      textColor: themeContro.isLightMode.value
                                          ? Appcolors.brown
                                          : Appcolors.white,
                                      fontWeight: FontWeight.w600,
                                    ).paddingOnly(left: 10),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      sizeBoxWidth(10),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Appcolors
                                              .appPriSecColor
                                              .appPrimblue
                                              .withValues(alpha: 0.10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Image.asset(
                                            'assets/images/location1.png',
                                            color: themeContro.isLightMode.value
                                                ? Appcolors.black
                                                : Appcolors
                                                      .appPriSecColor
                                                      .appPrimblue,
                                          ),
                                        ),
                                      ),
                                      sizeBoxWidth(10),
                                      SizedBox(
                                        width: 155,
                                        child: label(
                                          filtercontro
                                              .filtermodel
                                              .value!
                                              .serviceFilter![index]
                                              .address
                                              .toString(),
                                          maxLines: 1,
                                          fontSize: 10,
                                          textColor:
                                              themeContro.isLightMode.value
                                              ? Appcolors.black
                                              : Appcolors.brown,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  sizeBoxHeight(6),
                                  Row(
                                    children: [
                                      sizeBoxWidth(10),
                                      RatingBar.builder(
                                        itemPadding: const EdgeInsets.only(
                                          left: 1.5,
                                        ),
                                        initialRating:
                                            filtercontro
                                                    .filtermodel
                                                    .value!
                                                    .serviceFilter![index]
                                                    .averageReviewStar !=
                                                ''
                                            ? double.parse(
                                                filtercontro
                                                    .filtermodel
                                                    .value!
                                                    .serviceFilter![index]
                                                    .averageReviewStar!,
                                              )
                                            : 0.0,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 10.5,
                                        ignoreGestures: true,
                                        unratedColor: Appcolors.grey400,
                                        itemBuilder: (context, _) =>
                                            Image.asset(
                                              'assets/images/Star.png',
                                              height: 8,
                                            ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      SizedBox(width: 5),
                                      label(
                                        '(${filtercontro.filtermodel.value!.serviceFilter![index].totalReviewCount} Review)',
                                        fontSize: 10,
                                        textColor: themeContro.isLightMode.value
                                            ? Appcolors.black
                                            : Appcolors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).paddingSymmetric(horizontal: 20),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        : Container(
            height: getProportionateScreenHeight(180),
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: ui.Radius.circular(15),
                topRight: ui.Radius.circular(15),
              ),
              color: Appcolors.white,
            ),
            child: Column(
              children: [
                sizeBoxHeight(35),
                Image.asset(
                  'assets/images/Illustration.png',
                  height: 65,
                  width: 65,
                ),
                sizeBoxHeight(1),
                label(
                  languageController.textTranslate(
                    'No Store available in \n your Location',
                  ),
                  fontSize: 8,
                  textColor: Appcolors.black,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }

  List<Marker> markerList = <Marker>[];

  Future<void> addMarker() async {
    if (filtercontro.filtermodel.value?.serviceFilter == null) {
      return;
    }
    final customIcon = await getResizedMarkerIcon(
      "assets/images/locationpick.png",
      48,
      48,
    );
    markerList.clear();
    for (int i = 0; i < filtercontro.serviceFilte.length; i++) {
      final service = filtercontro.serviceFilte[i];

      if (service.lat == null ||
          service.lon == null ||
          service.lat!.isEmpty ||
          service.lon!.isEmpty ||
          double.tryParse(service.lat!) == null ||
          double.tryParse(service.lon!) == null) {
        continue;
      }

      markerList.add(
        Marker(
          markerId: MarkerId('MarkerId$i'),
          position: LatLng(
            double.parse(service.lat!),
            double.parse(service.lon!),
          ),
          icon: customIcon,
          onTap: () {
            if (i >= 0 && i < filtercontro.serviceFilte.length) {
              _scrollToIndex(i);
            }
          },
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _scrollToIndex(int index) {
    filtercontro.scrollControllerlocation.animateTo(
      index * 360.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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

  Future<Uint8List> getBytesFromAsset(
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
    return (await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  Widget location() {
    return FutureBuilder<BitmapDescriptor>(
      future: getResizedMarkerIcon('assets/images/locationpick.png', 48, 48),
      builder:
          (BuildContext context, AsyncSnapshot<BitmapDescriptor> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final customIcon = snapshot.data!;

              return Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        if (themeContro.isLightMode.value) {
                          _setMapStyleLight();
                        } else {
                          _setMapStyleDark();
                        }
                      },
                      onCameraMoveStarted: () {},
                      zoomGesturesEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.parse(userLatitude),
                          double.parse(userLongitude),
                        ),
                        zoom: 15,
                      ),
                      rotateGesturesEnabled: true,
                      markers: Set<Marker>.of(
                        filtercontro.filtermarkerList.value,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Nearby_location_listing(),
                  ),
                ],
              );
            } else {
              return Center(
                child: CupertinoActivityIndicator(
                  color: Appcolors.appPriSecColor.appPrimblue,
                ),
              );
            }
          },
    );
  }

  Widget location_() {
    return FutureBuilder<BitmapDescriptor>(
      future: filtercontro.getResizedMarkerIcon(
        'assets/images/locationpick.png',
        48,
        48,
      ),
      builder:
          (BuildContext context, AsyncSnapshot<BitmapDescriptor> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        if (themeContro.isLightMode.value) {
                          _setMapStyleLight();
                        } else {
                          _setMapStyleDark();
                        }
                      },
                      onCameraMoveStarted: () {},
                      zoomGesturesEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.parse(userLatitude),
                          double.parse(userLongitude),
                        ),
                        zoom: 15,
                      ),
                      rotateGesturesEnabled: true,
                      markers: Set<Marker>.of(
                        filtercontro.filtermarkerList.value,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Obx(() {
                      return filtercontro.isfilter.value
                          ? SizedBox.shrink()
                          : filtercontro
                                .filtermodel
                                .value!
                                .serviceFilter!
                                .isNotEmpty
                          ? location_filter()
                          : Container(
                              height: getProportionateScreenHeight(150),
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: ui.Radius.circular(15),
                                  topRight: ui.Radius.circular(15),
                                ),
                                color: Appcolors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Appcolors.grey200,
                                    blurRadius: 14.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(
                                      2.0,
                                      4.0,
                                    ), // shadow direction: bottom right
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  label(
                                    languageController.textTranslate(
                                      'No Store available in your Location',
                                    ),
                                    fontSize: 13,
                                    textColor: Appcolors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            );
                    }),
                  ),
                ],
              );
            } else {
              return Center(
                child: CupertinoActivityIndicator(
                  color: Appcolors.appPriSecColor.appPrimblue,
                ),
              );
            }
          },
    );
  }

  Widget buildBottomLoaderOrMessage() {
    if (!filtercontro.hasMoreData.value) {
      return Center(
        child: Text(
          "No more services found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      return Center(
        child: SizedBox(height: 30, width: 30, child: commonLoading()),
      );
    }
  }

  Widget listing() {
    if (filtercontro.isfilter.value) {
      return CircularProgressIndicator();
    } else if (filtercontro.serviceFilte.isEmpty) {
      return explore_empty();
    }
    return GridView.builder(
      itemCount:
          filtercontro.serviceFilte.length +
          (isLoadingMore || !filtercontro.hasMoreData.value ? 1 : 0),
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      physics: AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        if (index < filtercontro.serviceFilte.length) {
          return CommanScreen(
            lat: filtercontro.serviceFilte[index].lat ?? "0.0",
            lon: filtercontro.serviceFilte[index].lon ?? "0.0",
            storeImages: filtercontro.serviceFilte[index].serviceImages![0]
                .toString(),
            sname: filtercontro.serviceFilte[index].serviceName!.capitalizeFirst
                .toString(),
            cname: filtercontro
                .serviceFilte[index]
                .categoryName!
                .capitalizeFirst
                .toString(),
            vname:
                "${filtercontro.serviceFilte[index].firstName} ${filtercontro.serviceFilte[index].lastName}",
            vendorImages: filtercontro.serviceFilte[index].image.toString(),
            isfeatured: filtercontro.serviceFilte[index].isFeatured ?? 0,
            ratingCount:
                filtercontro.serviceFilte[index].averageReviewStar!.isNotEmpty
                ? double.parse(
                    filtercontro.serviceFilte[index].averageReviewStar!,
                  )
                : 0,
            avrageReview: filtercontro.serviceFilte[index].totalReviewCount!
                .toString(),
            isLike: userID.isEmpty
                ? 0
                : filtercontro.serviceFilte[index].isLike!,
            onTaplike: () {
              if (userID.isEmpty) {
                snackBar('Please login to like this service');
                loginPopup(bottomsheetHeight: Get.height * 0.95);
              } else {
                likecontro.likeApi(
                  filtercontro.serviceFilte[index].id.toString(),
                );

                setState(() {
                  filtercontro.serviceFilte[index].isLike =
                      filtercontro.serviceFilte[index].isLike == 0 ? 1 : 0;
                });
              }
            },
            onTapstore: () {
              Get.to(
                Details(
                  serviceid: filtercontro.serviceFilte[index].id.toString(),
                  isVendorService: false,
                ),
                transition: Transition.rightToLeft,
              );
            },
            location: filtercontro.serviceFilte[index].address.toString(),
            price: 'From ${filtercontro.serviceFilte[index].priceRange}',
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Appcolors.grey300,
            highlightColor: Appcolors.grey100,
            child: Card(
              color: Appcolors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    ).paddingSymmetric(horizontal: 15, vertical: 5);
  }

  Widget Nearby_location_listing() {
    return filtercontro.serviceFilte.isNotEmpty
        ? SizedBox(
            height: getProportionateScreenHeight(180),
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.darkMainBlack,
                borderRadius: BorderRadius.only(
                  topLeft: ui.Radius.circular(15),
                  topRight: ui.Radius.circular(15),
                ),
              ),
              child: ListView.builder(
                controller: filtercontro.scrollControllerlocation,
                shrinkWrap: true,
                itemCount: filtercontro.serviceFilte.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      sizeBoxHeight(25),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            Details(
                              serviceid: filtercontro.serviceFilte[index].id
                                  .toString(),
                              isVendorService: false,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Container(
                          height: getProportionateScreenHeight(120),
                          width: Get.width * 0.90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeContro.isLightMode.value
                                ? Appcolors.white
                                : Appcolors.darkGray,
                            border: Border.all(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.grey300
                                  : Appcolors.black.withOpacity(0.8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: getProportionateScreenHeight(120),
                                width: getProportionateScreenWidth(130),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(9),
                                    bottomLeft: Radius.circular(9),
                                  ),
                                  border: Border.all(
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.grey300
                                        : Appcolors.black.withOpacity(0.8),
                                  ),
                                  image: DecorationImage(
                                    onError: (exception, stackTrace) {
                                      Icon(Icons.error);
                                    },
                                    image: NetworkImage(
                                      filtercontro
                                          .serviceFilte[index]
                                          .serviceImages![0]
                                          .toString(),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sizeBoxHeight(3),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: Appcolors
                                                .appPriSecColor
                                                .appPrimblue,
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                          ),
                                          child: Center(
                                            child: label(
                                              trimText30(
                                                filtercontro
                                                    .serviceFilte[index]
                                                    .categoryName
                                                    .toString(),
                                              ),
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Appcolors.white,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 8,
                                              ),
                                            ).paddingOnly(left: 4, right: 4),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (userID.isEmpty) {
                                              snackBar(
                                                'Please login to like this service',
                                              );
                                              loginPopup(
                                                bottomsheetHeight:
                                                    Get.height * 0.95,
                                              );
                                            } else {
                                              likecontro.likeApi(
                                                filtercontro
                                                    .serviceFilte[index]
                                                    .id
                                                    .toString(),
                                              );

                                              setState(() {
                                                filtercontro
                                                        .serviceFilte[index]
                                                        .isLike =
                                                    filtercontro
                                                            .serviceFilte[index]
                                                            .isLike ==
                                                        0
                                                    ? 1
                                                    : 0;
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 26,
                                            width: 26,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Appcolors
                                                  .appPriSecColor
                                                  .appPrimblue
                                                  .withValues(alpha: 0.10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                6.0,
                                              ),
                                              child:
                                                  filtercontro
                                                          .serviceFilte[index]
                                                          .isLike ==
                                                      0
                                                  ? Image.asset(
                                                      AppAsstes.heart,
                                                      color:
                                                          themeContro
                                                              .isLightMode
                                                              .value
                                                          ? Appcolors.black
                                                          : Appcolors.grey1,
                                                    )
                                                  : Image.asset(
                                                      AppAsstes.fill_heart,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 10),
                                    SizedBox(
                                      width: Get.width * 0.5,
                                      child: label(
                                        filtercontro
                                            .serviceFilte[index]
                                            .serviceName
                                            .toString(),
                                        fontSize: 11,
                                        maxLines: 1,
                                        textColor: themeContro.isLightMode.value
                                            ? Appcolors.brown
                                            : Appcolors.white,
                                        fontWeight: FontWeight.w600,
                                      ).paddingOnly(left: 10),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        sizeBoxWidth(10),
                                        Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Appcolors
                                                .appPriSecColor
                                                .appPrimblue
                                                .withValues(alpha: 0.10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Image.asset(
                                              'assets/images/location1.png',
                                              color:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors.black
                                                  : Appcolors
                                                        .appPriSecColor
                                                        .appPrimblue,
                                            ),
                                          ),
                                        ),
                                        sizeBoxWidth(10),
                                        SizedBox(
                                          width: 155,
                                          child: label(
                                            filtercontro
                                                .serviceFilte[index]
                                                .address
                                                .toString(),
                                            maxLines: 1,
                                            fontSize: 10,
                                            textColor:
                                                themeContro.isLightMode.value
                                                ? Appcolors.black
                                                : Appcolors.brown,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    sizeBoxHeight(6),
                                    Row(
                                      children: [
                                        sizeBoxWidth(10),
                                        RatingBar.builder(
                                          itemPadding: const EdgeInsets.only(
                                            left: 1.5,
                                          ),
                                          initialRating:
                                              filtercontro
                                                      .serviceFilte[index]
                                                      .averageReviewStar !=
                                                  ''
                                              ? double.parse(
                                                  filtercontro
                                                      .serviceFilte[index]
                                                      .averageReviewStar!,
                                                )
                                              : 0.0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 10.5,
                                          ignoreGestures: true,
                                          unratedColor: Appcolors.grey400,
                                          itemBuilder: (context, _) =>
                                              Image.asset(
                                                'assets/images/Star.png',
                                                height: 8,
                                              ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                        SizedBox(width: 5),
                                        label(
                                          '(${filtercontro.serviceFilte[index].totalReviewCount} Review)',
                                          fontSize: 10,
                                          textColor:
                                              themeContro.isLightMode.value
                                              ? Appcolors.black
                                              : Appcolors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 20);
                },
              ),
            ),
          )
        : Container(
            height: getProportionateScreenHeight(180),
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: ui.Radius.circular(15),
                topRight: ui.Radius.circular(15),
              ),
              color: Appcolors.white,
            ),
            child: Column(
              children: [
                sizeBoxHeight(35),
                Image.asset(
                  'assets/images/Illustration.png',
                  height: 65,
                  width: 65,
                ),
                sizeBoxHeight(1),
                label(
                  languageController.textTranslate(
                    'No Store available in \n your Location',
                  ),
                  fontSize: 8,
                  textColor: Appcolors.black,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }

  Widget explore_empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Image.asset(AppAsstes.emptyImage, width: 200, height: 180),
          ),
          label(
            languageController.textTranslate("No Data Found"),
            fontSize: 15,
            textColor: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
