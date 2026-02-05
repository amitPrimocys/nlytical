import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/customer_support.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/faq.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Support"),
            style: poppinsFont(20, Appcolors.white, FontWeight.w500),
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
            sizeBoxHeight(15),
            containerDesing(
              onTap: () {
                Get.to(() => const Faq());
              },
              img: AppAsstes.faq,
              title: "FAQ’s",
              height: 18,
            ),
            sizeBoxHeight(10),
            containerDesing(
              onTap: () {
                Get.to(() => const CustomerSupport());
              },
              img: AppAsstes.customersupport,
              title: languageController.textTranslate("Customer Support"),
              height: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget containerDesing({
    required Function() onTap,
    required String img,
    required String title,
    required double height,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getProportionateScreenHeight(55),
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 4),
              blurRadius: 14.4,
              spreadRadius: 0,
              color: themeContro.isLightMode.value
                  ? Appcolors.grey300
                  : const Color(0xff000000),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  img,
                  height: height,
                  color: themeContro.isLightMode.value
                      ? Appcolors.black
                      : Appcolors.white,
                ),
                sizeBoxWidth(10),
                Text(
                  title,
                  style: poppinsFont(
                    12,
                    themeContro.isLightMode.value
                        ? Appcolors.black
                        : Appcolors.white,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
            Image.asset(
              userTextDirection == "ltr"
                  ? "assets/images/arrow-left (1).png"
                  : 'assets/images/arrow-left1.png',
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              height: 16,
              width: 16,
            ),
          ],
        ).paddingSymmetric(horizontal: 15),
      ).paddingSymmetric(horizontal: 15),
    );
  }
}
