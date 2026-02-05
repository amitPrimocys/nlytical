// ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use

import 'package:nlytical/utils/spinkit_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/find_gridview.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/nearby_comman_widgets.dart';
import 'package:nlytical/utils/size_config.dart';

Widget twoText({
  required String text1,
  String text2 = "",
  Color? colorText2,
  Color? colorText1,
  double size = 10,
  FontWeight? fontWeight,
  TextStyle? style1,
  TextStyle? style2,
  void Function()? onTap2,
  MainAxisAlignment? mainAxisAlignment,
  MainAxisSize? mainAxisSize,
}) {
  final bgColor = colorText2 ?? Appcolors.appTextColor.textRedColor;
  final bgColor1 = colorText1 ?? Appcolors.black;
  return Row(
    mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
    mainAxisSize: mainAxisSize ?? MainAxisSize.max,
    children: [
      label(
        "${text1.tr} ",
        style:
            style1 ??
            poppinsFont(size, bgColor1, fontWeight ?? FontWeight.normal),
      ),
      GestureDetector(
        onTap: onTap2,
        child: label(
          text2.tr,
          style:
              style2 ??
              poppinsFont(size, bgColor, fontWeight ?? FontWeight.normal),
        ),
      ),
    ],
  );
}

Widget findstore({
  required String imagepath,
  required String sname,
  required String cname,
  required double ratingCount,
  required String avrageReview,
  required int isLike,
  required Function() onTaplike,
  required Function() storeOnTap,
}) {
  return GestureDetector(
    onTap: storeOnTap,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          // height: 200,
          width: Get.width * 0.8,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 0,
                color: Appcolors.grey300,
                offset: const Offset(0.0, 3.0),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(22),
            ),
            color: Appcolors.white,
            image: DecorationImage(
              image: NetworkImage(imagepath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 12,
          child: Container(
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Appcolors.appPriSecColor.appPrimblue,
            ),
            child: Center(
              child: SizedBox(
                // width: 40,
                child: label(
                  cname,
                  // maxLines: 1,
                  fontSize: 8,
                  // overflow: TextOverflow.ellipsis,
                  textColor: Appcolors.white,
                  fontWeight: FontWeight.w600,
                ).paddingSymmetric(horizontal: 5),
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: 20,
          bottom: -1,
          child: FloatingScreen1(
            sname: sname,
            ratingCount: ratingCount,
            avrageReview: avrageReview,
            isLike: isLike,
            onTaplike: onTaplike,
            storeOnTap: storeOnTap,
          ),
        ),
      ],
    ),
  );
}

Widget nearbystore({
  required String imagepath,
  required String sname,
  required String cname,
  required double ratingCount,
  required String avrageReview,
  required int isLike,
  required Function() onTaplike,
  required Function() storeOnTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: GestureDetector(
      onTap: storeOnTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            // height: 200,
            width: Get.width * 0.82,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 0,
                  color: Appcolors.grey300,
                  offset: const Offset(0.0, 3.0),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(imagepath),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 14,
            child: Container(
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Appcolors.appPriSecColor.appPrimblue,
              ),
              child: Center(
                child: SizedBox(
                  // width: 40,
                  child: label(
                    cname,
                    // maxLines: 1,
                    fontSize: 8,
                    // overflow: TextOverflow.ellipsis,
                    textColor: Appcolors.white,
                    fontWeight: FontWeight.w600,
                  ).paddingSymmetric(horizontal: 5),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 20,
            bottom: -1,
            child: NearbyScreen(
              sname: sname,
              ratingCount: ratingCount,
              avrageReview: avrageReview,
              isLike: isLike,
              onTaplike: onTaplike,
              onTapstore: storeOnTap,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget cateWidgets(
  BuildContext context, {
  required String imagepath,
  required String cname,
  required Function() cateOnTap,
}) {
  return GestureDetector(
    onTap: cateOnTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: themeContro.isLightMode.value
              ? Color(0xffCAD9EF)
              : Appcolors.darkGray,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imagepath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) {
                return Center(
                  child: shimmerLoader(double.infinity, double.infinity, 10),
                );
              },
              errorWidget: (context, url, error) {
                return Center(
                  child: Icon(
                    Icons.error,
                    color: Appcolors.appTextColor.textLighGray,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 30, // Adjust height as needed for the overlay
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0), // Fully transparent top
                      Colors.black.withOpacity(0.50), // Mid
                      Colors.black.withOpacity(0.70), // Bottom
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                cname,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTypography.text10Medium(
                  context,
                ).copyWith(color: Appcolors.appTextColor.textWhite),
              ),
            ).paddingAll(8),
          ],
        ),
      ),
    ),
  );
}

GestureDetector allservice({
  required String imagepath,
  required String cname,
  required Function() cateOnTap,
}) {
  return GestureDetector(
    onTap: cateOnTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
      child: Stack(
        children: [
          Image.network(
            imagepath,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Appcolors.black12, Appcolors.appBgColor.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: label(
                cname,
                fontSize: 11,
                textColor: Appcolors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget review(
  BuildContext context, {
  required String imagepath,
  required String fname,
  required double ratingCount,
  required String time,
  // required String content,
  required String descname,
}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: themeContro.isLightMode.value
                ? Appcolors.appShadowColor.grey200
                : Appcolors.appBgColor.darkMainBlack,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    fname,
                    style: AppTypography.text10Medium(context),
                  ),
                ),
                RatingBar.builder(
                  itemPadding: const EdgeInsets.only(left: 1.5),
                  initialRating: ratingCount,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 14.5,
                  ignoreGestures: true,
                  unratedColor: Appcolors.grey400,
                  itemBuilder: (context, _) =>
                      Image.asset('assets/images/Star.png', height: 16),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ).paddingOnly(left: 70, right: 15, top: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatLastSeen(time),
                  style: AppTypography.text8Medium(
                    context,
                  ).copyWith(color: Appcolors.appTextColor.textLighGray),
                ),
              ],
            ).paddingSymmetric(horizontal: 15).paddingOnly(top: 5),
            sizeBoxHeight(15),
            Text(
              descname,
              style: AppTypography.text9Regular(context),
            ).paddingOnly(left: 15, right: 15),
            sizeBoxHeight(20),
          ],
        ),
      ),
      Positioned(
        top: -20,
        left: 15,
        child: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Appcolors.grey300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              imagepath,
              fit: BoxFit.cover,
              loadingBuilder:
                  (
                    BuildContext ctx,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: SpinKitSpinningLines(
                          size: 30,
                          color: Appcolors.appPriSecColor.appPrimblue,
                        ),
                      );
                    }
                  },
              errorBuilder:
                  (
                    BuildContext? context,
                    Object? exception,
                    StackTrace? stackTrace,
                  ) {
                    return containerCapiltal(
                      height: getProportionateScreenHeight(40),
                      width: getProportionateScreenWidth(40),
                      fontSize: 15,
                      text: fname,
                    );
                  },
            ),
          ),
        ),
      ),
    ],
  );
}

Widget setting(
  BuildContext context, {
  required String imagepath,
  required String name,
  required Function() buttonOnTap,
}) {
  return GestureDetector(
    onTap: buttonOnTap,
    child: Container(
      height: 45,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border(
          bottom: BorderSide(color: Appcolors.appBgColor.transparent),
        ),
        // border: Border.all(color: Appcolors.white),
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkGray,
        boxShadow: [
          BoxShadow(
            color: themeContro.isLightMode.value
                ? Appcolors.grey300
                : Appcolors.darkShadowColor,
            blurRadius: 14.0,
            spreadRadius: 0.0,
            offset: const Offset(2.0, 4.0), // shadow direction: bottom right
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                imagepath,
                height: 16,
                width: 16,
                color: themeContro.isLightMode.value
                    ? Appcolors.black
                    : Appcolors.white,
              ),
              sizeBoxWidth(6),
              Text(
                name,
                style: AppTypography.text12Medium(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                ),
              ),
            ],
          ),
          Image.asset(
            userTextDirection == "ltr"
                ? 'assets/images/arrow-left (1).png'
                : "assets/images/arrow-left1.png",
            color: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            height: 16,
            width: 16,
          ),
        ],
      ).paddingSymmetric(horizontal: 15),
    ),
  );
}
