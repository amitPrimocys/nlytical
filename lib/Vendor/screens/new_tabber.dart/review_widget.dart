import 'package:flutter/material.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';

Widget review({
  required String imagepath,
  required String fname,
  required double ratingCount,
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
                ? Appcolors.grey200
                : Appcolors.black26,
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
                  width: getProportionateScreenWidth(130),
                  child: Text(
                    fname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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
            sizeBoxHeight(15),
            label(
              descname,
              fontSize: 11,
              maxLines: 3,
              textColor: Appcolors.brown,
              fontWeight: FontWeight.w500,
            ).paddingOnly(left: 15),
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
            child: Image.network(imagepath, fit: BoxFit.cover),
          ),
        ),
      ),
    ],
  );
}
