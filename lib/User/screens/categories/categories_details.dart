// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_is_empty, unused_local_variable, avoid_print, empty_catches
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/controllers/user_controllers/subcate_service_contro.dart';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:nlytical/User/screens/shimmer_loader/catedetail_loader.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_screen.dart';
import 'package:nlytical/utils/comman_screen_new.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class Categoriesdetails extends StatefulWidget {
  String? cat;
  String? subcat;
  String? subName;
  Categoriesdetails({super.key, this.cat, this.subcat, this.subName});

  @override
  State<Categoriesdetails> createState() => _CategoriesdetailsState();
}

class _CategoriesdetailsState extends State<Categoriesdetails> {
  SubcateserviceContro subcateservicecontro = Get.find();
  LikeContro likecontro = Get.find();
  int page = 1;
  bool isLoadingMore = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    fetchRestaurants();
    subcateservicecontro.subcateserviceApi(
      page: page.toString(),
      catId: widget.cat!,
      subcatId: widget.subcat,
    );
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
        page++;
      });
      fetchRestaurants();
      ("its scroll");
    }
  }

  Future<void> fetchRestaurants() async {
    try {
      await subcateservicecontro.subcateserviceApi(
        page: page.toString(),
        catId: widget.cat!,
        subcatId: widget.subcat,
      );
    } catch (error) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: SizedBox(
            width: 255,
            child: Text(
              widget.subName.toString(),
              style: AppTypography.h1(
                context,
              ).copyWith(color: Appcolors.appTextColor.textWhite),
            ),
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
              child: Obx(() {
                return subcateservicecontro.issubcat.value
                    ? catedetail_Loader(context)
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            sizeBoxHeight(15),
                            subcateservicecontro.subcatelist.isNotEmpty
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      label(
                                        languageController.textTranslate(
                                          'Sponsored Stores',
                                        ),
                                        fontSize: 14,
                                        textColor: themeContro.isLightMode.value
                                            ? Appcolors.black
                                            : Appcolors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 20)
                                : SizedBox.shrink(),
                            subcateservicecontro.subcatelist.isNotEmpty
                                ? sizeBoxHeight(15)
                                : SizedBox.shrink(),
                            subcateservicecontro.subcatelist.isNotEmpty
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: storelist().paddingSymmetric(
                                      horizontal: 20,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            subcateservicecontro.subcatelist.isNotEmpty
                                ? sizeBoxHeight(18)
                                : SizedBox.shrink(),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                languageController.textTranslate('All Stores'),
                                style: AppTypography.text14Medium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ).paddingSymmetric(horizontal: 20),
                            ),
                            sizeBoxHeight(10),
                            allstore(),
                          ],
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget storelist() {
    return subcateservicecontro.subcatelist.isNotEmpty
        ? SizedBox(
            height: 320,
            child: ListView.builder(
              clipBehavior: Clip.none,
              padding: EdgeInsets.zero,
              itemCount: subcateservicecontro.subcatelist.length,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CommanScreenNew(
                  lat: subcateservicecontro.subcatelist[index].lat ?? "0.0",
                  lon: subcateservicecontro.subcatelist[index].lon ?? "0.0",
                  vname: subcateservicecontro.subcatelist[index].vendorFirstName
                      .toString(),
                  storeImages: subcateservicecontro
                      .subcatelist[index]
                      .serviceImages
                      .toString(),
                  sname: subcateservicecontro
                      .subcatelist[index]
                      .serviceName!
                      .capitalizeFirst
                      .toString(),
                  cname: subcateservicecontro
                      .subcatelist[index]
                      .categoryName!
                      .capitalizeFirst
                      .toString(),
                  vendorImages: subcateservicecontro
                      .subcatelist[index]
                      .vendorImage
                      .toString(),
                  isfeatured:
                      subcateservicecontro.subcatelist[index].isFeatured ?? 0,
                  year:
                      '${subcateservicecontro.subcatelist[index].totalYearsCount!.toString()} Years in Business',
                  ratingCount:
                      subcateservicecontro
                          .subcatelist[index]
                          .totalAvgReview!
                          .isNotEmpty
                      ? double.parse(
                          subcateservicecontro
                              .subcatelist[index]
                              .totalAvgReview!,
                        )
                      : 0,
                  avrageReview: subcateservicecontro
                      .subcatelist[index]
                      .totalReviewCount!
                      .toString(),
                  isLike: userID.isEmpty
                      ? 0
                      : subcateservicecontro.subcatelist[index].isLike!,
                  onTaplike: () {
                    if (userID.isEmpty) {
                      snackBar('Please login to like this service');
                      loginPopup(bottomsheetHeight: Get.height * 0.95);
                    } else {
                      likecontro.likeApi(
                        subcateservicecontro.subcatelist[index].id.toString(),
                      );
                      setState(() {
                        subcateservicecontro.subcatelist[index].isLike =
                            subcateservicecontro.subcatelist[index].isLike == 0
                            ? 1
                            : 0;
                        for (
                          int i = 0;
                          i < subcateservicecontro.allcatelist.length;
                          i++
                        ) {
                          if (subcateservicecontro.allcatelist[i].id ==
                              subcateservicecontro.subcatelist[index].id) {
                            subcateservicecontro.allcatelist[i].isLike =
                                subcateservicecontro.subcatelist[index].isLike;
                          }
                        }
                      });
                    }
                  },
                  onTapstore: () async {
                    Get.to(
                      Details(
                        serviceid: subcateservicecontro.subcatelist[index].id
                            .toString(),
                        isVendorService: false,
                      ),
                      transition: Transition.rightToLeft,
                    );
                  },
                  location: subcateservicecontro.subcatelist[index].address
                      .toString(),
                  price:
                      'From ${subcateservicecontro.subcatelist[index].priceRange}',
                ).paddingOnly(right: 12);
              },
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: SizedBox(
                height: 100,
                child: label(
                  languageController.textTranslate("No Sponsored Stores Found"),
                  fontSize: 16,
                  textColor: Appcolors.brown,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
  }

  Future<void> whatsapp() async {
    var contact = subcateservicecontro.subcatelist[0].servicePhone!.toString();
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }

  Widget allstore() {
    double screenWidth = MediaQuery.of(context).size.width;

    double maxCrossAxisExtent = screenWidth / 2;

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return subcateservicecontro.allcatelist.length > 0
        ? GridView.builder(
                itemCount: subcateservicecontro.allcatelist.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  if (index == subcateservicecontro.allcatelist.length) {
                    return isLoadingMore
                        ? Center(
                            child: Column(
                              children: [
                                sizeBoxHeight(10),
                                CircularProgressIndicator(
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink();
                  }
                  return CommanScreen(
                    lat: subcateservicecontro.allcatelist[index].lat ?? "0.0",
                    lon: subcateservicecontro.allcatelist[index].lon ?? "0.0",
                    storeImages: subcateservicecontro
                        .allcatelist[index]
                        .serviceImages
                        .toString(),
                    sname: subcateservicecontro.allcatelist[index].serviceName!,
                    cname:
                        subcateservicecontro.allcatelist[index].categoryName!,
                    vname: subcateservicecontro
                        .allcatelist[index]
                        .vendorFirstName
                        .toString(),
                    vendorImages: subcateservicecontro
                        .allcatelist[index]
                        .vendorImage
                        .toString(),
                    isfeatured:
                        subcateservicecontro.allcatelist[index].isFeatured ?? 0,
                    ratingCount:
                        subcateservicecontro
                            .allcatelist[index]
                            .totalAvgReview!
                            .isEmpty
                        ? 0.00
                        : double.parse(
                            subcateservicecontro
                                .allcatelist[index]
                                .totalAvgReview!,
                          ),
                    avrageReview: subcateservicecontro
                        .allcatelist[index]
                        .totalReviewCount!
                        .toString(),
                    isLike: userID.isEmpty
                        ? 0
                        : subcateservicecontro.allcatelist[index].isLike!,
                    onTaplike: () {
                      if (userID.isEmpty) {
                        snackBar('Please login to like this service');
                        loginPopup(bottomsheetHeight: Get.height * 0.95);
                      } else {
                        for (
                          var i = 0;
                          i < subcateservicecontro.subcatelist.length;
                          i++
                        ) {
                          if (subcateservicecontro.allcatelist[index].id ==
                              subcateservicecontro.subcatelist[i].id) {
                            if (subcateservicecontro.subcatelist[i].isLike ==
                                0) {
                              subcateservicecontro.subcatelist[i].isLike = 1;
                            } else {
                              subcateservicecontro.subcatelist[i].isLike = 0;
                            }
                            subcateservicecontro.subcatelist.refresh();
                          }
                        }

                        likecontro.likeApi(
                          subcateservicecontro.allcatelist[index].id.toString(),
                        );

                        setState(() {
                          subcateservicecontro.allcatelist[index].isLike =
                              subcateservicecontro.allcatelist[index].isLike ==
                                  0
                              ? 1
                              : 0;
                        });
                      }
                    },
                    onTapstore: () {
                      Get.to(
                        Details(
                          serviceid: subcateservicecontro.allcatelist[index].id
                              .toString(),
                          isVendorService: false,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    location: subcateservicecontro.allcatelist[index].address
                        .toString(),
                    price: subcateservicecontro.allcatelist[index].priceRange
                        .toString(),
                  );
                },
              )
              .paddingSymmetric(horizontal: 15, vertical: 5)
              .paddingOnly(bottom: 65)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                subcateservicecontro.subcatelist.isNotEmpty
                    ? sizeBoxHeight(50)
                    : SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.28,
                      ),
                Image.asset(AppAsstes.emptyImage, width: 100, height: 100),
                label(
                  languageController.textTranslate("No Data Found"),
                  fontSize: 14,
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
