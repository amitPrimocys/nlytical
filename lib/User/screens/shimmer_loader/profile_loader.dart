// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';

double? h, w;

Widget ProfileLoader(BuildContext context) {
  h = MediaQuery.sizeOf(context).height;
  w = MediaQuery.sizeOf(context).width;
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          decoration: const BoxDecoration(),
          child: Shimmer.fromColors(
            baseColor: themeContro.isLightMode.value
                ? Appcolors.grey300
                : Appcolors.darkGray,
            highlightColor: themeContro.isLightMode.value
                ? Appcolors.grey100
                : Appcolors.darkgray2,
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // openBottomForImagePick(context);
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: getProportionateScreenHeight(100),
                          width: getProportionateScreenWidth(100),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Appcolors.white,
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
                              child: Image.network('', fit: BoxFit.cover),
                            ).paddingAll(3),
                          ).paddingAll(3),
                        ),
                      ],
                    ),
                  ),
                ),
                sizeBoxHeight(5),
                Container(
                  height: 20,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Appcolors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: label(
                    '',
                    fontSize: 12,
                    textColor: Appcolors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                sizeBoxHeight(5),
                Container(
                  height: 20,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Appcolors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: label(
                    '',
                    fontSize: 12,
                    textColor: Appcolors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
