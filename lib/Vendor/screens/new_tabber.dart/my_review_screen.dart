// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/controllers/vendor_controllers/business_review_controller.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/shimmer_Loader/business_review.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/auth/splash.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  BusinessReviewController businessreviewcontro = Get.find();

  @override
  void initState() {
    businessreviewcontro.businessReviewApi();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Business Reviews"),
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
            sizeBoxHeight(20),
            Expanded(
              child: Obx(() {
                return businessreviewcontro.isLoading.value
                    ? BusinessLoader(context)
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            storeContainer()
                                .paddingSymmetric(horizontal: 20)
                                .paddingOnly(top: 30),
                            Text(
                              languageController.textTranslate("User Review"),
                              style: AppTypography.text14Medium(
                                context,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ).paddingSymmetric(horizontal: 25),
                            sizeBoxHeight(20),
                            reviewContainer().paddingSymmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
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

  Widget reviewContainer() {
    return businessreviewcontro.reviewList.isNotEmpty
        ? ListView.builder(
            itemCount: businessreviewcontro.reviewList.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${businessreviewcontro.reviewList[index].firstName}  ${businessreviewcontro.reviewList[index].lastName}",
                    style: AppTypography.text12Medium(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ).paddingSymmetric(horizontal: 85, vertical: 5),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: themeContro.isLightMode.value
                              ? Appcolors.white
                              : Appcolors.darkGray,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 14.4,
                              spreadRadius: 0,
                              color: Appcolors.black12,
                              offset: Offset(2.0, 4.0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            sizeBoxHeight(8),
                            RatingBar.builder(
                              initialRating:
                                  businessreviewcontro
                                          .reviewList[index]
                                          .reviewStar !=
                                      ''
                                  ? double.parse(
                                      businessreviewcontro
                                          .reviewList[index]
                                          .reviewStar
                                          .toString(),
                                    )
                                  : 0.0, // Start with 3 stars selected
                              minRating:
                                  0, // The minimum rating the user can give is 1 star
                              direction: Axis
                                  .horizontal, // Stars are laid out horizontally
                              allowHalfRating:
                                  false, // Full stars only, no half-star ratings
                              unratedColor: Appcolors
                                  .appExtraColor
                                  .cFFE1AA, // Color for unselected stars
                              itemCount: 5, // Total number of stars is 5
                              itemSize: 14,
                              ignoreGestures: true,
                              itemPadding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ), // Space between stars
                              itemBuilder: (context, _) => Image.asset(
                                'assets/images/star1.png',
                                color: Appcolors.appExtraColor.yellowColor,
                              ),
                              onRatingUpdate: (rating) {},
                            ).paddingSymmetric(horizontal: 60),
                            sizeBoxHeight(20),
                            Text(
                              businessreviewcontro
                                  .reviewList[index]
                                  .reviewMessage
                                  .toString(),
                              style: poppinsFont(
                                11,
                                themeContro.isLightMode.value
                                    ? Appcolors.darkMainBlack
                                    : Appcolors.white,
                                FontWeight.w500,
                              ),
                            ),
                            sizeBoxHeight(20),
                          ],
                        ).paddingSymmetric(horizontal: 22),
                      ),
                      Positioned(
                        top: -23,
                        left: 23,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Appcolors.grey200),
                            color: themeContro.isLightMode.value
                                ? Appcolors.appBgColor.white
                                : Appcolors.appBgColor.darkGray,
                            image: DecorationImage(
                              image: NetworkImage(
                                businessreviewcontro.reviewList[index].image
                                    .toString(),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 20),
                ],
              );
            },
          )
        : reviewempty();
  }

  Widget storeContainer() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.appBgColor.darkMainBlack,
                ),
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.appBgColor.darkGray,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 14.4,
                    spreadRadius: 0,
                    color: themeContro.isLightMode.value
                        ? Appcolors.black.withValues(alpha: 0.06)
                        : Appcolors.black12,
                    offset: const Offset(2.0, 4.0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sizeBoxHeight(50),
                  Text(
                    businessreviewcontro.bussinessName.value,
                    style: poppinsFont(
                      13,
                      themeContro.isLightMode.value
                          ? Appcolors.darkMainBlack
                          : Appcolors.white,
                      FontWeight.w600,
                    ),
                  ),
                  sizeBoxHeight(13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating:
                            businessreviewcontro.bussinessReview.value != ''
                            ? double.parse(
                                businessreviewcontro.bussinessReview.value,
                              )
                            : 0.0, // Start with 3 stars selected
                        minRating:
                            0, // The minimum rating the user can give is 1 star
                        direction:
                            Axis.horizontal, // Stars are laid out horizontally
                        allowHalfRating:
                            false, // Full stars only, no half-star ratings
                        unratedColor: Appcolors
                            .appExtraColor
                            .cFFE1AA, // Color for unselected stars
                        itemCount: 5, // Total number of stars is 5
                        itemSize: 12,
                        ignoreGestures: true,
                        itemPadding: const EdgeInsets.symmetric(
                          horizontal: 2,
                        ), // Space between stars
                        itemBuilder: (context, _) => Image.asset(
                          'assets/images/star1.png',
                          color: Appcolors.appExtraColor.yellowColor,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '(${businessreviewcontro.businessReviewCount.value} Review)',
                        style: AppTypography.text10Medium(context),
                      ),
                    ],
                  ),
                  sizeBoxHeight(20),
                ],
              ).paddingSymmetric(horizontal: 12),
            ),
            Positioned(
              top: -30,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Appcolors.grey300),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 14.4,
                      spreadRadius: 0,
                      color: themeContro.isLightMode.value
                          ? Appcolors.black.withValues(alpha: 0.06)
                          : Appcolors.black12,
                      offset: const Offset(2.0, 4.0),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(businessreviewcontro.bussinessImage[0]),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: 25),
      ],
    );
  }

  Widget reviewempty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizeBoxHeight(Get.height * 0.2),
          SizedBox(
            height: 100,
            child: Image.asset(
              AppAsstes.emptyImage,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              filterQuality: FilterQuality.high,
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
    );
  }
}
