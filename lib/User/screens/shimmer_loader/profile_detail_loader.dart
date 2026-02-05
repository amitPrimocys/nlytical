import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';

double? h, w;

Widget profiledetailsLoader(BuildContext context) {
  h = MediaQuery.sizeOf(context).height;
  w = MediaQuery.sizeOf(context).width;
  return Container(
    decoration: const BoxDecoration(),
    child: Shimmer.fromColors(
      baseColor: themeContro.isLightMode.value
          ? Appcolors.grey300
          : Appcolors.white12,
      highlightColor: themeContro.isLightMode.value
          ? Appcolors.grey100
          : Appcolors.white24,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizeBoxHeight(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: getProportionateScreenHeight(100),
                        width: getProportionateScreenWidth(100),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Appcolors.appPriSecColor.appPrimblue
                              .withValues(alpha: 0.10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 0,
                              color: Appcolors.appPriSecColor.appPrimblue
                                  .withValues(alpha: 0.10),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Appcolors.white,
                            border: Border.all(width: 2.5),
                          ),
                          child: ClipOval(
                            clipBehavior: Clip.hardEdge,
                          ).paddingAll(3),
                        ).paddingAll(3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            sizeBoxHeight(5),
            sizeBoxHeight(8),
            GestureDetector(
              child: Center(
                child: label(
                  languageController.textTranslate("Select Your Profile"),
                  maxLines: 2,
                  textColor: Appcolors.greyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            sizeBoxHeight(28),
            label(
              languageController.textTranslate('First Name'),
              fontSize: 11,
              textColor: Appcolors.brown,
              fontWeight: FontWeight.w500,
            ),
            Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Appcolors.grey),
              ),
            ),
            sizeBoxHeight(17),
            label(
              languageController.textTranslate('Last Name'),
              fontSize: 11,
              textColor: Appcolors.brown,
              fontWeight: FontWeight.w500,
            ),
            Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Appcolors.grey),
              ),
            ),
            sizeBoxHeight(17),
            label(
              languageController.textTranslate('Email Address'),
              fontSize: 11,
              textColor: Appcolors.brown,
              fontWeight: FontWeight.w500,
            ),
            Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Appcolors.grey),
              ),
            ),
            sizeBoxHeight(15),
            label(
              languageController.textTranslate('Mobile Number'),
              fontSize: 11,
              textColor: Appcolors.brown,
              fontWeight: FontWeight.w500,
            ),
            sizeBoxHeight(4),
            Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Appcolors.grey),
              ),
            ),
            sizeBoxHeight(17),
            sizeBoxHeight(25),
            Center(
              child: Container(
                height: 50,
                width: Get.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Appcolors.white,
                ),
                child: Center(
                  child: label(
                    languageController.textTranslate("Submit"),
                    textColor: Appcolors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            sizeBoxHeight(50),
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    ),
  );
}
