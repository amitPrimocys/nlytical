// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:nlytical/utils/image_slide_show/src/image_slideshow.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/User/screens/shimmer_loader/home_Loader.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';

double? h, w;

Widget detailLoader(BuildContext context) {
  h = MediaQuery.sizeOf(context).height;
  w = MediaQuery.sizeOf(context).width;

  List<String> imageUrls = [
    'assets/images/Mask group (2).png',
    'assets/images/Mask group (2).png',
    'assets/images/Mask group (2).png',
  ];
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkColor,
          ),
          child: Shimmer.fromColors(
            baseColor: themeContro.isLightMode.value
                ? Appcolors.grey300
                : Appcolors.white12,
            highlightColor: themeContro.isLightMode.value
                ? Appcolors.grey100
                : Appcolors.white24,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 250,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.grey
                                  : Appcolors.darkMainBlack,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -90,
                            child: Container(
                              height: 100,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: themeContro.isLightMode.value
                                    ? Appcolors.grey
                                    : Appcolors.darkMainBlack,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      sizeBoxHeight(125),
                      Row(
                        children: [
                          Container(
                            height: 30,
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Appcolors.grey),
                            ),
                            child: Center(child: label('Overview')),
                          ),
                          sizeBoxWidth(6),
                          Container(
                            height: 30,
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Appcolors.grey),
                            ),
                            child: Center(child: label('Services')),
                          ),
                          sizeBoxWidth(6),
                          Container(
                            height: 30,
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Appcolors.grey),
                            ),
                            child: Center(child: label('Photos')),
                          ),
                          sizeBoxWidth(6),
                          Container(
                            height: 30,
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Appcolors.grey),
                            ),
                            child: Center(child: label('Reviews')),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                      sizeBoxHeight(15),
                      Container(
                        height: 80,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.grey,
                        ),
                      ).paddingSymmetric(horizontal: 20),
                      sizeBoxHeight(15),
                      Container(
                        height: 170,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.grey,
                        ),
                      ).paddingSymmetric(horizontal: 20),
                      sizeBoxHeight(10),
                      Align(
                        alignment: Alignment.topLeft,
                        child: label(
                          'Services',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: Appcolors.black,
                        ),
                      ).paddingSymmetric(horizontal: 20),
                      sizeBoxHeight(10),
                      Container(
                        height: 138,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Appcolors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Appcolors.appTextColor.textLighGray,
                              blurRadius: 14.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                2.0,
                                4.0,
                              ), // shadow direction: bottom right
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 88,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // Use the length of the entire serviceImages! list, not just the first element
                                  itemCount: 10,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: NetworkImage(''),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ).paddingSymmetric(horizontal: 5),
                                          sizeBoxHeight(5),
                                          SizedBox(
                                            width: 50,
                                            child: label(
                                              '',
                                              fontSize: 10,
                                              maxLines: 2,
                                              fontWeight: FontWeight.w500,
                                              textColor: Appcolors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              sizeBoxHeight(10),
                              Center(
                                child: GestureDetector(
                                  child: Container(
                                    height: 22,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Appcolors
                                            .appPriSecColor
                                            .appPrimblue,
                                      ),
                                    ),
                                    child: Center(
                                      child: label(
                                        'See All Services',
                                        fontSize: 7,
                                        fontWeight: FontWeight.w500,
                                        textColor: Appcolors
                                            .appPriSecColor
                                            .appPrimblue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 20),
                      sizeBoxHeight(12),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _poster2(BuildContext context, List<String> imageUrls) {
  Widget carousel = Stack(
    children: <Widget>[
      ImageSlideshow(
        initialPage: 0, // You can set this to any valid index
        autoPlayInterval: 3000,
        isLoop: true,
        indicatorColor: Appcolors.white,
        indicatorBackgroundColor: Appcolors.grey400,
        indicatorRadius: 3,
        children: imageUrls.map((img) {
          return Shimmer.fromColors(
            baseColor: themeContro.isLightMode.value
                ? Appcolors.grey300
                : Appcolors.white12,
            highlightColor: themeContro.isLightMode.value
                ? Appcolors.grey100
                : Appcolors.white24,
            child: Container(
              height: 180,
              width: Get.width,
              decoration: BoxDecoration(
                color: Appcolors.grey300,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );

  return SizedBox(height: Get.height * 0.25, width: Get.width, child: carousel);
}

Widget imagelist(BuildContext context) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      _poster2(context, imageUrls),
      Positioned(
        bottom: -50,
        right: 0,
        left: 0,
        child: Container(
          height: getProportionateScreenHeight(108),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Appcolors.grey200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                label(
                  '',
                  fontSize: 18,
                  textColor: Appcolors.brown,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBar.builder(
                      itemPadding: const EdgeInsets.only(left: 1.5),
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 12.5,
                      ignoreGestures: true,
                      unratedColor: Appcolors.grey400,
                      itemBuilder: (context, _) =>
                          Image.asset('assets/images/Star.png', height: 16),
                      onRatingUpdate: (rating) {},
                    ),
                    SizedBox(width: 5),
                    label(
                      '(${languageController.textTranslate("Review")})',
                      fontSize: 10,
                      textColor: Appcolors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).paddingSymmetric(horizontal: 15),
      ),
      Positioned(
        bottom: -12,
        right: 10,
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Appcolors.grey200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(AppAsstes.fill_heart),
          ),
        ).paddingSymmetric(horizontal: 20),
      ),
    ],
  );
}

Widget info() {
  return Column(
    children: [
      Container(
        height: 75,
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(color: Appcolors.grey200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label(
              'Information',
              fontSize: 13,
              textColor: Appcolors.grey,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 5),
          ],
        ).paddingSymmetric(horizontal: 10),
      ).paddingSymmetric(horizontal: 20),
      sizeBoxHeight(10),
      Container(
        height: 75,
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(color: Appcolors.grey200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/location1.png',
                    height: 14,
                    color: Appcolors.black,
                  ),
                  sizeBoxWidth(5),
                  SizedBox(
                    width: 185,
                    child: label(
                      '',
                      maxLines: 2,
                      fontSize: 11,
                      textColor: Appcolors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                child: Container(
                  height: 25,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                  child: Center(
                    child: Text(
                      'Get Direction',
                      style: TextStyle(
                        fontSize: 6,
                        color: Appcolors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Lato",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).paddingSymmetric(horizontal: 20),
      sizeBoxHeight(15),
      Container(
        height: 50,
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(color: Appcolors.grey200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset(
                      'assets/images/websit.png',
                      height: 14,
                      color: Appcolors.black,
                    ),
                  ),
                  sizeBoxWidth(5),
                  SizedBox(
                    width: 275,
                    child: Text(
                      '',
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        decorationColor: Appcolors.appPriSecColor.appPrimblue,
                        fontFamily: "Poppins",
                        color: Appcolors.appPriSecColor.appPrimblue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).paddingSymmetric(horizontal: 20),
      sizeBoxHeight(15),
      Container(
        height: 50,
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(color: Appcolors.grey200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/call.png',
                    height: 14,
                    color: Appcolors.black,
                  ),
                  sizeBoxWidth(8),
                  label(
                    '',
                    fontSize: 12,
                    textColor: Appcolors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              Image.asset('assets/images/Frame (1).png', height: 14),
            ],
          ),
        ),
      ).paddingSymmetric(horizontal: 20),
      sizeBoxHeight(15),
      Container(
        height: 90,
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(color: Appcolors.grey200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(
                'Opening Time',
                fontSize: 13,
                textColor: Appcolors.black,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/clock.png',
                        height: 12,
                        color: Appcolors.grey500,
                      ),
                      sizeBoxWidth(8),
                      label(
                        '',
                        fontSize: 9,
                        textColor: Appcolors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  label(
                    '',
                    fontSize: 9,
                    textColor: Appcolors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/clock.png',
                        height: 12,
                        color: Appcolors.grey500,
                      ),
                      sizeBoxWidth(8),
                      label(
                        '',
                        fontSize: 9,
                        textColor: Appcolors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  label(
                    'Closed',
                    fontSize: 9,
                    textColor: Appcolors.appTextColor.textRedColor,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ).paddingSymmetric(horizontal: 20),
      sizeBoxHeight(15),
      Container(
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(color: Appcolors.grey200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(
                'Customer Reviews',
                fontSize: 12,
                textColor: Appcolors.black,
                fontWeight: FontWeight.w500,
              ),
              sizeBoxHeight(10),
              ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                            ),
                            SizedBox(width: 8),
                            label(
                              '',
                              fontSize: 11,
                              textColor: Appcolors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            RatingBar.builder(
                              itemPadding: const EdgeInsets.only(left: 1.5),
                              // initialRating: servicecontro
                              //             .servicemodel
                              //             .value!
                              //             .serviceDetail!
                              //             .reviews![index]
                              //             .reviewStar
                              //             .toString() !=
                              //         ''
                              //     ? double.parse(servicecontro
                              //         .servicemodel
                              //         .value!
                              //         .serviceDetail!
                              //         .reviews![index]
                              //         .reviewStar
                              //         .toString())
                              //     : 0.0,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 14.5,
                              ignoreGestures: true,
                              unratedColor: Appcolors.grey400,
                              itemBuilder: (context, _) => Image.asset(
                                'assets/images/Star.png',
                                height: 16,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(width: 4),
                          ],
                        ),
                        SizedBox(height: 5),
                        label(
                          '',
                          maxLines: 3,
                          fontSize: 11,
                          textColor: Appcolors.darkGray,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ).paddingSymmetric(horizontal: 20),
      sizeBoxHeight(15),
    ],
  );
}
