import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class BusinessCategory extends StatefulWidget {
  const BusinessCategory({super.key});

  @override
  State<BusinessCategory> createState() => _BusinessCategoryState();
}

class _BusinessCategoryState extends State<BusinessCategory> {
  StoreController storeController = Get.find();

  @override
  void initState() {
    storeController.filteredSubCategoryNames.clear();

    if (storeController.storeList.isNotEmpty) {
      var businessDetails = storeController.storeList[0].businessDetails;

      if (businessDetails != null) {
        var categoryId = businessDetails.categoryId?.toString();

        // Ensure category data is available
        if (storeController.categoryData.value.data != null &&
            storeController.categoryData.value.data!.isNotEmpty) {
          var categoryList = storeController.categoryData.value.data!
              .where((element) => element.id.toString() == categoryId)
              .toList();

          if (categoryList.isNotEmpty) {
            var selectedCategory = categoryList.first;

            storeController.caategoryName.value =
                selectedCategory.categoryName!;
            storeController.subCategories.value = selectedCategory
                .subCategoryData!
                .map((e) => e.subcategoryName!)
                .toList();

            String subcategoryIdsString = businessDetails.subcategoryId
                .toString();
            List<String> subcategoryIds = subcategoryIdsString
                .split(',')
                .map((id) => id.trim())
                .toList();

            storeController.subCategoryNames.value = selectedCategory
                .subCategoryData!
                .where(
                  (subCategory) =>
                      subcategoryIds.contains(subCategory.id.toString()),
                )
                .map((subCategory) => subCategory.subcategoryName!)
                .toList();
          }
        }
      }
    }

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: appbarTitle(
            context,
            title: languageController.textTranslate("Business categories"),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: innerContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizeBoxHeight(30),
              businessTitle(
                context,
                title: languageController.textTranslate("Business categories"),
              ),
              sizeBoxHeight(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: themeContro.isLightMode.value
                        ? Appcolors.appPriSecColor.appPrimblue
                        : Appcolors.white,
                    size: 15,
                  ),
                  Flexible(
                    child: businessSubTitle(
                      context,
                      title:
                          " ${languageController.textTranslate("Categories describe what your business is and the products abd services your business offers. please add atleast one category for customers to find your business")}",
                    ),
                  ),
                ],
              ),
              sizeBoxHeight(30),
              twoText(
                text1: languageController.textTranslate("Categories"),
                text2: " *",
                fontWeight: FontWeight.w600,
                mainAxisAlignment: MainAxisAlignment.start,
                style1: AppTypography.outerMedium(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              sizeBoxHeight(7),
              DropDown(forWhat: "Categories"),
              sizeBoxHeight(15),
              Obx(
                () => storeController.caategoryName.isEmpty
                    ? const SizedBox.shrink()
                    : globButton(
                        name: storeController.caategoryName.value,
                        gradient: Appcolors.logoColork,
                        radius: 6,
                        vertical: 5,
                        horizontal: 15,
                        isOuntLined: true,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              storeController.caategoryName.value,
                              style: poppinsFont(
                                9,
                                themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                FontWeight.w500,
                              ),
                            ),
                            sizeBoxWidth(8),
                            GestureDetector(
                              onTap: () {
                                if (isDemo == "false") {
                                  storeController.caategoryName.value = '';
                                  storeController.subCategoryNames.value = [];
                                  storeController.subCategories.value = [];
                                  setState(() {});
                                } else {
                                  snackBar(
                                    "This is for demo, We can not allow to edit/delete",
                                  );
                                }
                              },
                              child: Icon(
                                Icons.close,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                size: 10,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 12, vertical: 7),
                      ),
              ),
              sizeBoxHeight(20),
              twoText(
                text1: languageController.textTranslate("Sub Categories"),
                text2: " *",
                fontWeight: FontWeight.w600,
                mainAxisAlignment: MainAxisAlignment.start,
                style1: AppTypography.outerMedium(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              sizeBoxHeight(7),
              DropDown(forWhat: "Sub Categories"),
              sizeBoxHeight(16),
              Obx(
                () => storeController.subCategoryNames.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: getProportionateScreenHeight(35),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: storeController.subCategoryNames.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return globButton(
                              name: "",
                              gradient: Appcolors.logoColork,
                              radius: 6,
                              vertical: 5,
                              horizontal: 15,
                              isOuntLined: true,
                              child: Row(
                                children: [
                                  Text(
                                    storeController.subCategoryNames[index],
                                    style: poppinsFont(
                                      9,
                                      themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                      FontWeight.w500,
                                    ),
                                  ),
                                  sizeBoxWidth(8),
                                  GestureDetector(
                                    onTap: () {
                                      if (isDemo == "false") {
                                        storeController.subCategoryNames
                                            .removeAt(index);
                                      } else {
                                        snackBar(
                                          "This is for demo, We can not allow to edit/delete",
                                        );
                                      }
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                      size: 10,
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 15),
                            ).paddingOnly(
                              right:
                                  storeController.subCategoryNames.length - 1 ==
                                      index
                                  ? 0
                                  : 10,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return storeController.isUpdate.value
            ? SizedBox(
                height: 50,
                width: 50,
                child: Center(child: commonLoading()),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 20,
                right: 20,
              )
            : customBtn(
                onTap: () {
                  if (isDemo == "false") {
                    if (storeController.caategoryName.isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please select category",
                        ),
                      );
                    } else if (storeController.subCategoryNames.isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please select subcategory",
                        ),
                      );
                    } else {
                      storeController.storeCategoryUpdateApi(
                        categoryId: storeController.categoryData.value.data!
                            .where(
                              (element) =>
                                  element.categoryName ==
                                  storeController.caategoryName.value,
                            )
                            .first
                            .id
                            .toString(),
                        subCategoryId: storeController.categoryData.value.data!
                            .where(
                              (category) =>
                                  category.categoryName ==
                                  storeController.caategoryName.value,
                            )
                            .first
                            .subCategoryData!
                            .where(
                              (subCategory) => storeController.subCategoryNames
                                  .contains(subCategory.subcategoryName),
                            )
                            .map((subCategory) => subCategory.id.toString())
                            .toList()
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                            .replaceAll(' ', ''),
                      );
                      storeController.caategoryName.value = '';
                      storeController.subCategoryNames.value = [];
                      storeController.subCategories.value = [];
                    }
                  } else {
                    snackBar("This is for demo, We can not allow to update");
                  }
                },
                title: languageController.textTranslate("Save"),
                fontSize: 15,
                weight: FontWeight.w400,
                radius: BorderRadius.circular(10),
                width: getProportionateScreenWidth(260),
                height: getProportionateScreenHeight(55),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 60,
                right: 60,
              );
      }),
    );
  }
}
