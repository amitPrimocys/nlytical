import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';

class AddCampaignShimmer extends StatelessWidget {
  const AddCampaignShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizeBoxHeight(20),
        Shimmer.fromColors(
          baseColor: themeContro.isLightMode.value
              ? Appcolors.grey300
              : Appcolors.white12,
          highlightColor: themeContro.isLightMode.value
              ? Appcolors.grey100
              : Appcolors.white24,
          child: Container(
            height: 50,
            width: Get.width,
            decoration: BoxDecoration(
              color: Appcolors.appPriSecColor.appPrimblue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/add.png', height: 20),
                  sizeBoxWidth(5),
                  Text(
                    languageController.textTranslate('Add New Campaign'),
                    style: AppTypography.h3(context).copyWith(
                      color: Appcolors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ).paddingSymmetric(horizontal: 20),
        ),
        sizeBoxHeight(20),
        Text(
          languageController.textTranslate('Campaigns'),
          style: AppTypography.text16(context),
        ).paddingSymmetric(horizontal: 20),
        sizeBoxHeight(10),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: themeContro.isLightMode.value
                    ? Appcolors.grey300
                    : Appcolors.white12,
                highlightColor: themeContro.isLightMode.value
                    ? Appcolors.grey100
                    : Appcolors.white24,
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: themeContro.isLightMode.value
                        ? Appcolors.white
                        : Appcolors.darkGray,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Appcolors.black.withValues(alpha: 0.1),
                        blurRadius: 14,
                        spreadRadius: 0,
                        offset: const Offset(4, 2),
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 20, vertical: 5),
              );
            },
          ),
        ),
        sizeBoxHeight(40),
      ],
    );
  }
}
