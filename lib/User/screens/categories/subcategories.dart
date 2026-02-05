// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/categories_contro.dart';
import 'package:nlytical/User/screens/categories/categories_details.dart';
import 'package:nlytical/User/screens/shimmer_loader/subcat_loader.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';

import 'package:nlytical/utils/size_config.dart';

class SubCategories extends StatefulWidget {
  String? cat;
  SubCategories({super.key, this.cat});

  @override
  State<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  CategoriesContro subcatecontro = Get.find();

  @override
  void initState() {
    subcatecontro.subcateApi(catId: widget.cat!);
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
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Sub Categories"),
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
            Expanded(
              child: Obx(() {
                return subcatecontro.issubcat.value
                    ? SubcatLoader(context)
                    : SingleChildScrollView(
                        child: Column(children: [sizeBoxHeight(10), detail()]),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget detail() {
    return subcatecontro.subcatelist.isNotEmpty
        ? ListView.builder(
            itemCount: subcatecontro.subcatelist.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      Categoriesdetails(
                        cat: subcatecontro.subcatelist[index].categoryId
                            .toString(),
                        subcat: subcatecontro.subcatelist[index].id.toString(),
                        subName:
                            subcatecontro.subcatelist[index].subcategoryName,
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      boxShadow: [
                        BoxShadow(
                          color: themeContro.isLightMode.value
                              ? Appcolors.grey200
                              : Appcolors.darkShadowColor,
                          blurRadius: 14.0,
                          spreadRadius: 0.0,
                          offset: const Offset(2.0, 4.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    subcatecontro
                                        .subcatelist[index]
                                        .subcategoryImage
                                        .toString(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            sizeBoxWidth(10),
                            Text(
                              subcatecontro.subcatelist[index].subcategoryName
                                  .toString(),
                              style: AppTypography.text12Medium(context),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              subcatecontro.subcatelist[index].servicesCount
                                  .toString(),
                              style: AppTypography.text10Regular(context)
                                  .copyWith(
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.appPriSecColor.appPrimblue
                                        : Appcolors.appTextColor.textWhite,
                                  ),
                            ),
                            sizeBoxWidth(10),
                            Image.asset(
                              'assets/images/arrow-left (1).png',
                              color: themeContro.isLightMode.value
                                  ? Appcolors.black
                                  : Appcolors.white,
                              height: 16,
                              width: 16,
                            ),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 15),
                  ).paddingSymmetric(horizontal: 15),
                ),
              );
            },
          )
        : subcatempty();
  }

  Widget subcatempty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.28),
          SizedBox(
            height: 160,
            child: Image.asset(AppAsstes.emptyImage, width: 100, height: 80),
          ),
          label(
            languageController.textTranslate("No Data Found"),
            fontSize: 14,
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
