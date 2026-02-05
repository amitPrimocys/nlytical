// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/sponsor/select_payment.dart';

class PriceDetails extends StatefulWidget {
  String? totaldays;
  String? startdate;
  String? enddate;
  String? price;
  String? goalId;
  PriceDetails({
    super.key,
    this.totaldays,
    this.startdate,
    this.enddate,
    this.price,
    this.goalId,
  });

  @override
  State<PriceDetails> createState() => _PriceDetailsState();
}

class _PriceDetailsState extends State<PriceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      bottomNavigationBar: BottomAppBar(
        color: Appcolors.appBgColor.transparent,
        height: 70,
        child: button(),
      ).paddingOnly(bottom: 30),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Price Details"),
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
            sizeBoxHeight(30),
            Container(
              height: 70,
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.appPriSecColor.appPrimblue.withValues(
                        alpha: 0.10,
                      )
                    : Appcolors.darkGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sizeBoxHeight(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        languageController.textTranslate('Total Days'),
                        style: AppTypography.text10Medium(context),
                      ),
                      Text(
                        "${widget.totaldays!} ${languageController.textTranslate("days")}",
                        style: AppTypography.text10Medium(
                          context,
                        ).copyWith(color: Appcolors.appPriSecColor.appPrimblue),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10),
                  sizeBoxHeight(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${languageController.textTranslate("Start Date")} / ${languageController.textTranslate("End Date")}',
                        style: AppTypography.text10Medium(context),
                      ),
                      Text(
                        '${widget.startdate!} to ${widget.enddate!}',
                        style: AppTypography.text10Medium(context),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10),
                  sizeBoxHeight(5),
                ],
              ),
            ).paddingSymmetric(horizontal: 20),
            sizeBoxHeight(20),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.appBgColor.darkGray,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.black12,
                    blurRadius: 13,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  sizeBoxHeight(10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      languageController.textTranslate('Price Details'),
                      style: AppTypography.h3(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    languageController.textTranslate('Selected Ad Days'),
                    "${widget.totaldays!} days",
                  ),
                  _buildDetailRow(
                    languageController.textTranslate('Price'),
                    widget.price!,
                  ),
                  Divider(color: Appcolors.appStrokColor.cF0F0F0, thickness: 1),
                  _buildDetailRow(
                    languageController.textTranslate('Total Amount'),
                    widget.price!,
                    isBold: true,
                  ),
                  sizeBoxHeight(10),
                ],
              ).paddingSymmetric(horizontal: 15, vertical: 3),
            ).paddingSymmetric(horizontal: 20),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: () {
        Get.to(SelectPayment(price: widget.price, goalID: widget.goalId));
      },
      child: Container(
        height: 30,
        width: Get.width,
        decoration: BoxDecoration(
          color: Appcolors.appPriSecColor.appPrimblue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            languageController.textTranslate('Make Payment'),
            style: AppTypography.text16(
              context,
            ).copyWith(color: Appcolors.appTextColor.textWhite),
          ),
        ),
      ).paddingSymmetric(horizontal: 20),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.text12Medium(context)),
          label(value, style: AppTypography.text12Medium(context)),
        ],
      ),
    );
  }
}
