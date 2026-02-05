// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/categories_contro.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';

double? h, w;

CategoriesContro subcatecontro = Get.find();

Widget SubcatLoader(BuildContext context) {
  h = MediaQuery.sizeOf(context).height;
  w = MediaQuery.sizeOf(context).width;
  return SingleChildScrollView(
    child: Column(
      children: [
        sizeBoxHeight(18),
        Container(
          decoration: BoxDecoration(
            color: !themeContro.isLightMode.value
                ? Appcolors.darkColor
                : Appcolors.white,
          ),
          child: ListView.builder(
            itemCount: subcatecontro.subcatelist.length,
            padding: const EdgeInsets.symmetric(vertical: 5),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: !themeContro.isLightMode.value
                    ? Appcolors.white12
                    : Appcolors.grey300,
                highlightColor: !themeContro.isLightMode.value
                    ? Appcolors.white24
                    : Appcolors.grey100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    height: 45,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Appcolors.grey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        label('', fontSize: 12, fontWeight: FontWeight.w500),
                        Image.asset(
                          'assets/images/arrow-left (1).png',
                          color: Appcolors.black,
                          height: 16,
                          width: 16,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 15),
                  ).paddingSymmetric(horizontal: 15),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
