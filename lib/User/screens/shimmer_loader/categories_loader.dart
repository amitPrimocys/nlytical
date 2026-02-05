import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/categories_contro.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';

CategoriesContro catecontro = Get.find();

Widget cat(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.zero,
      itemCount: catecontro.catelist.length, // Number of items in the grid
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: themeContro.isLightMode.value
              ? Appcolors.grey300
              : Appcolors.darkGray,
          highlightColor: themeContro.isLightMode.value
              ? Appcolors.grey100
              : Appcolors.darkgray1,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Appcolors.white,
            ),
          ),
        );
      },
    ),
  );
}
