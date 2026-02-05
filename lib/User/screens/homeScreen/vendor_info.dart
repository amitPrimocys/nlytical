// ignore_for_file: must_be_immutable, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/controllers/user_controllers/vendor_info_contro.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_screen.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class VendorInfo extends StatefulWidget {
  String? oppositeid;
  VendorInfo({super.key, required this.oppositeid});

  @override
  State<VendorInfo> createState() => _VendorInfoState();
}

class _VendorInfoState extends State<VendorInfo> {
  VendorInfoContro vendorcontro = Get.find();
  LikeContro likecontro = Get.find();
  @override
  void initState() {
    vendorcontro.vendorApi(toUSerID: widget.oppositeid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      body: SizedBox(
        height: Get.height,
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: getProportionateScreenHeight(150),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAsstes.line_design),
                ),
                color: Appcolors.appPriSecColor.appPrimblue,
              ),
            ),
            Positioned(
              top: getProportionateScreenHeight(60),
              left: 0,
              right: 0,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customeBackArrow(),
                    Align(
                      alignment: Alignment.center,
                      child: label(
                        languageController.textTranslate("Vendor Info"),
                        textAlign: TextAlign.center,
                        fontSize: 20,
                        textColor: Appcolors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
            ),
            Positioned.fill(
              top: 100,
              child: Container(
                width: Get.width,
                height: getProportionateScreenHeight(800),
                decoration: BoxDecoration(
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.darkMainBlack,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Obx(() {
                  return vendorcontro.isfav.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Appcolors.appPriSecColor.appPrimblue,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              sizeBoxHeight(27),
                              Container(
                                height: 130,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Appcolors.appPriSecColor.appPrimblue,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    sizeBoxWidth(15),
                                    customProfileImage1(
                                      height: 66,
                                      width: 66,
                                      img: vendorcontro
                                          .vendorlistmodel
                                          .value
                                          .vendordetails!
                                          .image
                                          .toString(),
                                    ),
                                    sizeBoxWidth(15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        sizeBoxHeight(7),
                                        Text(
                                          "${vendorcontro.vendorlistmodel.value.vendordetails!.firstName.toString()} ${vendorcontro.vendorlistmodel.value.vendordetails!.lastName.toString()}",
                                          style:
                                              AppTypography.text14Medium(
                                                context,
                                              ).copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        sizeBoxHeight(10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RatingBar.builder(
                                              initialRating:
                                                  vendorcontro
                                                          .vendorlistmodel
                                                          .value
                                                          .vendordetails!
                                                          .averageRating
                                                          .toString() !=
                                                      ''
                                                  ? double.parse(
                                                      vendorcontro
                                                          .vendorlistmodel
                                                          .value
                                                          .vendordetails!
                                                          .averageRating
                                                          .toString(),
                                                    )
                                                  : 0.0,
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 12.5,
                                              ignoreGestures: true,
                                              unratedColor: Appcolors.grey400,
                                              itemBuilder: (context, _) =>
                                                  Image.asset(
                                                    'assets/images/Star.png',
                                                    height: 16,
                                                  ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                            const SizedBox(width: 5),
                                            label(
                                              '(${vendorcontro.vendorlistmodel.value.vendordetails!.totalReviews.toString()} Review)',
                                              fontSize: 10,
                                              textColor:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors.black
                                                  : Appcolors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        sizeBoxHeight(10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    themeContro
                                                        .isLightMode
                                                        .value
                                                    ? Appcolors.black12
                                                    : Appcolors.white,
                                              ),
                                              child: Image.asset(
                                                'assets/images/location2.png',
                                              ),
                                            ),
                                            sizeBoxWidth(10),
                                            SizedBox(
                                              width: 180,
                                              child: label(
                                                vendorcontro
                                                    .vendorlistmodel
                                                    .value
                                                    .vendordetails!
                                                    .address
                                                    .toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 11,
                                                  color:
                                                      themeContro
                                                          .isLightMode
                                                          .value
                                                      ? Appcolors.black
                                                      : Appcolors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sizeBoxHeight(10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    themeContro
                                                        .isLightMode
                                                        .value
                                                    ? Appcolors.black12
                                                    : Appcolors.white,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  6.0,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/call.png',
                                                ),
                                              ),
                                            ),
                                            sizeBoxWidth(10),
                                            label(
                                              vendorcontro
                                                  .vendorlistmodel
                                                  .value
                                                  .vendordetails!
                                                  .mobile
                                                  .toString(),
                                              fontSize: 11,
                                              textColor:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors.black
                                                  : Appcolors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        sizeBoxHeight(5),
                                      ],
                                    ),
                                  ],
                                ),
                              ).paddingSymmetric(horizontal: 20),
                              sizeBoxHeight(20),
                              store(),
                            ],
                          ),
                        );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget store() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            label(
              languageController.textTranslate('All Store'),
              fontSize: 14,
              textColor: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              fontWeight: FontWeight.w600,
            ),
          ],
        ).paddingSymmetric(horizontal: 20),
        vendorcontro.vendorlistmodel.value.serviceDetails!.isNotEmpty
            ? alllist().paddingAll(20)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    sizeBoxHeight(100),
                    SizedBox(
                      height: 100,
                      child: Image.asset(
                        AppAsstes.emptyImage,
                        width: 200,
                        height: 180,
                      ),
                    ),
                    sizeBoxHeight(10),
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
              ),
      ],
    );
  }

  Widget alllist() {
    return GridView.builder(
      itemCount: vendorcontro.vendorlistmodel.value.serviceDetails!.length,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items in a row
        childAspectRatio: 0.58, // Adjust for image and text ratio
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final data = vendorcontro.vendorlistmodel.value.serviceDetails![index];
        return CommanScreen(
          lat: data.lat ?? "0.0",
          lon: data.lon ?? "0.0",
          storeImages: data.serviceImages![0].toString(),
          sname: data.serviceName!.capitalizeFirst.toString(),
          cname: data.categoryName!.capitalizeFirst.toString(),
          vname: data.vendorFirstName.toString(),
          vendorImages: data.vendorImage.toString(),
          isfeatured: data.isFeatured ?? 0,
          ratingCount: data.averageRating!.isNotEmpty
              ? double.parse(data.averageRating!)
              : 0,
          avrageReview: data.totalReviews!.toString(),
          isLike: userID.isEmpty ? 0 : data.isLike!,
          onTaplike: () {
            if (userID.isEmpty) {
              snackBar('Please login to like this service');
              loginPopup(bottomsheetHeight: Get.height * 0.95);
            } else {
              likecontro.likeApi(data.id.toString());

              // Toggle the isLike value for the UI update (you may want to update this dynamically after the API call succeeds)
              setState(() {
                data.isLike = data.isLike == 0 ? 1 : 0;
                for (
                  int i = 0;
                  i < vendorcontro.vendorlistmodel.value.serviceDetails!.length;
                  i++
                ) {
                  if (vendorcontro
                          .vendorlistmodel
                          .value
                          .serviceDetails![i]
                          .id ==
                      vendorcontro
                          .vendorlistmodel
                          .value
                          .serviceDetails![index]
                          .id) {
                    vendorcontro
                        .vendorlistmodel
                        .value
                        .serviceDetails![i]
                        .isLike = vendorcontro
                        .vendorlistmodel
                        .value
                        .serviceDetails![index]
                        .isLike;
                  }
                }
              });
            }
          },
          onTapstore: () {
            Get.to(
              Details(serviceid: data.id.toString(), isVendorService: false),
              transition: Transition.rightToLeft,
            );
          },
          location: data.address.toString(),
          price: 'From ${data.priceRange}',
        );
      },
    ).paddingSymmetric(horizontal: 0, vertical: 0);
  }
}
