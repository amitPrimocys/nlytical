import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/categories_contro.dart';
import 'package:nlytical/User/screens/categories/subcategories.dart';
import 'package:nlytical/User/screens/shimmer_loader/categories_loader.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  CategoriesContro catecontro = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      catecontro.cateApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Categories"),
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
            sizeBoxHeight(10),
            Expanded(child: catlist()),
          ],
        ),
      ),
    );
  }

  Widget catlist() {
    return Obx(() {
      return catecontro.iscat.value
          ? cat(context)
          : SingleChildScrollView(
              child: Column(children: [category(), sizeBoxHeight(10)]),
            );
    });
  }

  Widget category() {
    return catecontro.catelist.isNotEmpty
        ? GridView.builder(
            itemCount: catecontro.catelist.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 3),

            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 40.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return cateWidgets(
                context,
                imagepath: catecontro.catelist[index].categoryImage.toString(),
                cname:
                    '${catecontro.catelist[index].categoryName!.capitalizeFirst}',
                cateOnTap: () {
                  Get.to(
                    SubCategories(
                      cat: catecontro.catelist[index].id.toString(),
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
              );
            },
          ).paddingSymmetric(horizontal: 15, vertical: 15)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizeBoxHeight(300),
                SizedBox(
                  height: 96,
                  child: Image.asset(
                    AppAsstes.emptyImage,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                label(
                  languageController.textTranslate("No Data Found"),
                  fontSize: 18,
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
