// ignore_for_file: curly_braces_in_flow_control_structures, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/support_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/models/vendor_models/faq_model.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  SupportController supportfaqcontro = Get.find();
  final searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    supportfaqcontro.faqApi();
  }

  @override
  void dispose() {
    _searchResult.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: GestureDetector(
            onTap: () {
              _searchResult.clear();
              Get.back();
            },
            child: Image.asset(
              userTextDirection == "ltr"
                  ? 'assets/images/arrow-left1.png'
                  : "assets/images/arrow-left (1).png",
              color: Appcolors.white,
              height: 25,
            ),
          ).paddingAll(15),
          centerTitle: true,
          title: Text(
            "FAQ",
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
        child: Obx(() {
          return supportfaqcontro.isLoading.value
              ? ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return shimmerLoader(
                      60,
                      Get.width,
                      10,
                    ).paddingSymmetric(horizontal: 15, vertical: 10);
                  },
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeBoxHeight(20),
                    searchBar(),
                    sizeBoxHeight(20),
                    Expanded(
                      child:
                          supportfaqcontro.faqmodel.value?.data?.isNotEmpty ??
                              false
                          ? (_searchResult.isNotEmpty
                                ? ListView.builder(
                                    itemCount: _searchResult.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return faqlistdata(
                                        index,
                                        _searchResult[index],
                                      );
                                    },
                                  )
                                : searchController.text.trim().isNotEmpty
                                ? faqsempty()
                                : ListView.builder(
                                    itemCount: supportfaqcontro
                                        .faqmodel
                                        .value
                                        ?.data
                                        ?.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return faqlistdata(
                                        index,
                                        supportfaqcontro
                                            .faqmodel
                                            .value!
                                            .data![index],
                                      );
                                    },
                                  ))
                          : faqsempty(),
                    ),
                  ],
                );
        }),
      ),
    );
  }

  Widget searchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 0,
      child: TextField(
        controller: searchController,
        cursorColor: Appcolors.grey400,
        onChanged: onSearchTextChanged,
        style: poppinsFont(
          13,
          themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
          FontWeight.w500,
        ),
        decoration: InputDecoration(
          fillColor: themeContro.isLightMode.value
              ? const Color(0xffF3F3F3)
              : Appcolors.darkGray,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: themeContro.isLightMode.value
                ? BorderSide.none
                : BorderSide(color: Appcolors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolors.greyColor, width: 5),
          ),
          hintText: languageController.textTranslate("Search help"),
          hintStyle: poppinsFont(13, Appcolors.grey400, FontWeight.w500),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 15, top: 15),
            child: Image.asset(
              AppAsstes.search,
              color: Appcolors.grey400,
              height: 10,
            ),
          ),
        ),
      ).paddingSymmetric(horizontal: 18),
    );
  }

  Widget faqsempty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizeBoxHeight(Get.height * 0.05),
          SizedBox(
            height: 100,
            child: Image.asset(
              AppAsstes.emptyImage,

              fit: BoxFit.contain,
              gaplessPlayback: true,
              filterQuality: FilterQuality.high,
            ),
          ),
          sizeBoxHeight(10),
          label(
            languageController.textTranslate("No Data Found"),
            fontSize: 15,
            textColor: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget faqlistdata(int index, Data item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 270,
              child: Text(
                item.question.toString(),
                maxLines: 2,
                style: AppTypography.text12Medium(
                  context,
                ).copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  supportfaqcontro.isExpandedList[index] =
                      !supportfaqcontro.isExpandedList[index];
                });
              },
              child: Icon(
                supportfaqcontro.isExpandedList[index]
                    ? Icons.remove
                    : Icons.add,
                color: themeContro.isLightMode.value
                    ? Appcolors.black
                    : Appcolors.white,
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 10),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: supportfaqcontro.isExpandedList[index]
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: themeContro.isLightMode.value
                  ? Appcolors.appPriSecColor.appPrimblue.withValues(alpha: 0.10)
                  : Appcolors.darkblue,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20,
              ),
              child: Text(
                item.answer.toString(),
                style: AppTypography.text12Medium(
                  context,
                ).copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
        if (index != supportfaqcontro.faqmodel.value!.data!.length - 1)
          Divider(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textLighGray
                : Appcolors.darkGray,
          ).paddingSymmetric(horizontal: 20),
      ],
    );
  }

  void onSearchTextChanged(String text) {
    _searchResult.clear();

    if (text.isEmpty) {
      _searchResult.addAll(supportfaqcontro.faqmodel.value!.data!);
    } else {
      _searchResult.addAll(
        supportfaqcontro.faqmodel.value!.data!.where(
          (userDetail) => (userDetail.question ?? '').toLowerCase().contains(
            text.toLowerCase(),
          ),
        ),
      );
    }

    setState(() {});
  }
}

List _searchResult = [];
