// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class CommanScreenNew extends StatelessWidget {
  String cname;
  String sname;
  String vname;
  String location;
  String year;
  String price;
  String avrageReview;
  String storeImages;
  String vendorImages;
  double ratingCount;
  int isLike;
  int isfeatured;
  Function() onTaplike;
  Function() onTapstore;
  String? lat;
  String? lon;

  CommanScreenNew({
    super.key,
    required this.cname,
    required this.sname,
    required this.vname,
    required this.year,
    required this.location,
    required this.price,
    required this.avrageReview,
    required this.storeImages,
    required this.vendorImages,
    required this.ratingCount,
    required this.isLike,
    required this.isfeatured,
    required this.onTaplike,
    required this.onTapstore,
    this.lat,
    this.lon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapstore,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: Get.height * 0.8,
            width: Get.width * 0.85,
            decoration: BoxDecoration(
              border: Border.all(
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.darkGray,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  spreadRadius: 0,
                  color: themeContro.isLightMode.value
                      ? Appcolors.grey300
                      : Appcolors.darkShadowColor,
                  offset: const Offset(2.0, 2.0),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(storeImages),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  Center(child: Icon(Icons.image));
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.darkGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 15,
                  right: 12,
                  bottom: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Appcolors.appTextColor.textLighGray
                                  .withValues(alpha: 0.09),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: vendorImages,
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) {
                                return containerCapiltal(
                                  height: getProportionateScreenHeight(20),
                                  width: getProportionateScreenWidth(20),
                                  fontSize: 12,
                                  text: vname,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          vname,
                          style: AppTypography.text12Medium(context).copyWith(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textDarkGrey
                                : Appcolors.appTextColor.textWhite,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.text16(context).copyWith(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appTextColor.textBlack
                            : Appcolors.appTextColor.textWhite,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ratingRow(
                          context,
                          ratingCount: ratingCount.toString(),
                          avrageReview: avrageReview,
                        ),
                        (lat == null || lat == "") || (lon == null || lon == "")
                            ? SizedBox.shrink()
                            : SizedBox(
                                width: 60,
                                child: RichText(
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Image.asset(
                                          "assets/images/km.png",
                                          height: 10,
                                        ),
                                      ),
                                      WidgetSpan(child: sizeBoxWidth(3)),
                                      TextSpan(
                                        text:
                                            userLatitude.isEmpty &&
                                                userLongitude.isEmpty
                                            ? "0 KM"
                                            : calculateDistanceInKm(
                                                double.parse(userLatitude),
                                                double.parse(userLongitude),
                                                double.parse(lat!),
                                                double.parse(lon!),
                                              ).toString(),

                                        style:
                                            AppTypography.text10Regular(
                                              context,
                                            ).copyWith(
                                              color:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors
                                                        .appTextColor
                                                        .textDarkGrey
                                                  : Appcolors
                                                        .appPriSecColor
                                                        .appPrimblue,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/location.png',
                          color: themeContro.isLightMode.value
                              ? Appcolors.appPriSecColor.appPrimblue
                              : Appcolors.white,
                          height: 13,
                          width: 13,
                        ),
                        SizedBox(width: 5),
                        SizedBox(
                          width: 210,
                          child: Text(
                            location,
                            maxLines: 1,
                            style: AppTypography.text10Regular(context)
                                .copyWith(
                                  color: themeContro.isLightMode.value
                                      ? Appcolors.appTextColor.textDarkGrey
                                      : Appcolors.appTextColor.textWhite,
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: Get.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Appcolors.appPriSecColor.appPrimblue,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          price,
                          style: AppTypography.text14Medium(context).copyWith(
                            color: Appcolors.appPriSecColor.appPrimblue,
                          ),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 10),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 12,
            child: GestureDetector(
              onTap: onTaplike,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Appcolors.appOppaColor.whiteOppacity01,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLike == 0
                          ? Image.asset(AppAsstes.heart) // Unlike
                          : Image.asset(AppAsstes.fill_heart), // Liked
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 0,
            child: Container(
              height: 15,
              decoration: BoxDecoration(
                color: Appcolors.appPriSecColor.appPrimblue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(3),
                  bottomRight: Radius.circular(3),
                ),
              ),
              child: Center(
                child: Text(
                  cname.length > 100 ? '${cname.substring(0, 100)}…' : cname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.text10Medium(
                    context,
                  ).copyWith(color: Appcolors.appTextColor.textWhite),
                ).paddingOnly(left: 4, right: 4),
              ),
            ),
          ),
          isfeatured == 0
              ? SizedBox.shrink()
              : Positioned(
                  bottom: 160,
                  right: 12,
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                      color: Appcolors.appTextColor.textRedColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/energy.png',
                            height: 9,
                            width: 9,
                          ),
                          sizeBoxWidth(3),
                          Text(
                            languageController.textTranslate('Sponsored'),
                            style: AppTypography.text10Medium(
                              context,
                            ).copyWith(color: Appcolors.appTextColor.textWhite),
                          ),
                        ],
                      ).paddingOnly(left: 4, right: 4),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
