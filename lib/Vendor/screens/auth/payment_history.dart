// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/payment_history_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/global.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  PaymentHistoryController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      roleController.isSponsorSelect();
      controller.getPaymentHistory(isHome: false);
      controller.getSubscriptionApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Payment History"),
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
            sizeBoxHeight(10),
            paymentTab(),
            sizeBoxHeight(10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    sizeBoxHeight(10),
                    roleController.isSponsor.value
                        ? Obx(() {
                            return controller.isLoading.value
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 7,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return shimmerLoader(
                                        60,
                                        Get.width,
                                        10,
                                      ).paddingSymmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      );
                                    },
                                  )
                                : controller.goalData.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.goalData.length,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return paymentDesign(index);
                                    },
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        sizeBoxHeight(200),
                                        Image.asset(
                                          AppAsstes.emptyImage,
                                          width: 120,
                                          height: 120,
                                        ),
                                        SizedBox(height: 10),
                                        label(
                                          languageController.textTranslate(
                                            "Payment history not found",
                                          ),
                                          fontSize: 16,
                                          textColor: Appcolors.brown,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  );
                          })
                        : Obx(() {
                            return controller.isSubscribe.value
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 7,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return shimmerLoader(
                                        60,
                                        Get.width,
                                        10,
                                      ).paddingSymmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      );
                                    },
                                  )
                                : controller.subscriPaymentList.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        controller.subscriPaymentList.length,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return paymentDesignSub(index);
                                    },
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        sizeBoxHeight(200),
                                        Image.asset(
                                          AppAsstes.emptyImage,
                                          width: 120,
                                          height: 120,
                                        ),
                                        SizedBox(height: 10),
                                        label(
                                          languageController.textTranslate(
                                            "Payment history not found",
                                          ),
                                          fontSize: 16,
                                          textColor: Appcolors.brown,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  );
                          }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentDesign(index) {
    return Container(
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkGray,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          controller.isExpandedList[index]
              ? BoxShadow(
                  color: Appcolors.appPriSecColor.appSecond.withValues(
                    alpha: 0.10,
                  ),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                )
              : BoxShadow(
                  color: Appcolors.appBgColor.transparent,
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeContro.isLightMode.value
                  ? Appcolors.white
                  : Appcolors.darkGray,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Appcolors.appPriSecColor.appSecond.withValues(
                    alpha: 0.10,
                  ),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  controller.isExpandedList[index] =
                      !controller.isExpandedList[index];
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/cal.png', height: 15),
                        const SizedBox(width: 8),
                        Expanded(
                          child: label(
                            "Sponsor plan",
                            style: poppinsFont(
                              14,
                              themeContro.isLightMode.value
                                  ? Appcolors.black
                                  : Appcolors.white,
                              FontWeight.w600,
                            ),
                          ),
                        ),
                        label(
                          '\$${controller.goalData[index].price}',
                          style: poppinsFont(
                            14,
                            themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        label(
                          '${controller.goalData[index].startDate} - ${controller.goalData[index].endDate}',
                          style: TextStyle(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textLighGray
                                : Appcolors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ).paddingOnly(left: 25),
                        Icon(
                          controller.isExpandedList[index]
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textLighGray
                              : Appcolors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isExpandedList[index])
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label(
                    languageController.textTranslate('Price Details'),
                    style: TextStyle(
                      color: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    languageController.textTranslate('Selected Ad Days'),
                    "${getDaysCount(controller.goalData[index].startDate.toString(), controller.goalData[index].endDate.toString())} ${languageController.textTranslate("Days").paramCase}",
                  ),
                  _buildDetailRow(
                    languageController.textTranslate('Price'),
                    '\$${controller.goalData[index].price}',
                  ),
                  Divider(
                    color: themeContro.isLightMode.value
                        ? Appcolors.black12
                        : Appcolors.white,
                    thickness: 1,
                  ),
                  _buildDetailRow(
                    languageController.textTranslate('Total Amount'),
                    '\$${controller.goalData[index].price}',
                    isBold: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    ).paddingOnly(left: 15, right: 15, bottom: 10);
  }

  Widget paymentDesignSub(index) {
    final startDate = DateFormat(
      'dd-MM-yyyy',
    ).format(DateTime.parse(controller.subscriPaymentList[index].startDate!));
    final expireDate = DateFormat(
      'dd-MM-yyyy',
    ).format(DateTime.parse(controller.subscriPaymentList[index].expireDate!));
    return Container(
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkGray,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          controller.isExpandedList1[index]
              ? BoxShadow(
                  color: Appcolors.black12,
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                )
              : BoxShadow(
                  color: Appcolors.appBgColor.transparent,
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeContro.isLightMode.value
                  ? Appcolors.white
                  : Appcolors.darkGray,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Appcolors.black12,
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  controller.isExpandedList1[index] =
                      !controller.isExpandedList1[index];
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/cal.png', height: 15),
                        const SizedBox(width: 8),
                        Expanded(
                          child: label(
                            controller.subscriPaymentList[index].planName!,
                            style: poppinsFont(
                              14,
                              themeContro.isLightMode.value
                                  ? Appcolors.black
                                  : Appcolors.white,
                              FontWeight.w600,
                            ),
                          ),
                        ),
                        label(
                          '\$${controller.subscriPaymentList[index].price}',
                          style: poppinsFont(
                            14,
                            themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        label(
                          '$startDate - $expireDate',
                          style: TextStyle(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textLighGray
                                : Appcolors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ).paddingOnly(left: 25),
                        Icon(
                          controller.isExpandedList1[index]
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textLighGray
                              : Appcolors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isExpandedList1[index])
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label(
                    languageController.textTranslate('Price Details'),
                    style: TextStyle(
                      color: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    languageController.textTranslate('Selected Ad Days'),
                    "${getDaysCount(controller.subscriPaymentList[index].startDate.toString(), controller.subscriPaymentList[index].expireDate.toString())} ${languageController.textTranslate("Days").paramCase}",
                  ),
                  _buildDetailRow(
                    languageController.textTranslate('Price'),
                    '\$${controller.subscriPaymentList[index].price}',
                  ),
                  Divider(
                    color: themeContro.isLightMode.value
                        ? Appcolors.black12
                        : Appcolors.white,
                    thickness: 1,
                  ),
                  _buildDetailRow(
                    languageController.textTranslate('Total Amount'),
                    '\$${controller.subscriPaymentList[index].price}',
                    isBold: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    ).paddingOnly(left: 15, right: 15, bottom: 10);
  }

  Widget _buildDetailRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          label(
            title,
            style: TextStyle(
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          label(
            value,
            style: TextStyle(
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  int getDaysCount(String startDate, String endDate) {
    try {
      final dateFormat = DateFormat("dd-MM-yyyy");

      final start = dateFormat.parse(startDate);
      final end = dateFormat.parse(endDate);

      return end.difference(start).inDays + 1;
    } catch (e) {
      return 0;
    }
  }

  Widget paymentTab() {
    return Obx(() {
      return InkWell(
        onTap: () {
          roleController.isSponsor.value = !roleController.isSponsor.value;
          setState(() {});
        },
        child: Container(
          height: getProportionateScreenHeight(50),
          width: Get.width * 0.90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Appcolors.white,
          ),
          child: Container(
            width: Get.width * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Appcolors.appStrokColor.cF0F0F0,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                roleController.isSponsor.value
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.white,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Appcolors.appPriSecColor.appPrimblue,
                          ),
                        ).paddingOnly(right: 3),
                      ).paddingOnly(right: 160)
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.white,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Appcolors.appPriSecColor.appPrimblue,
                          ),
                        ).paddingOnly(left: 3),
                      ).paddingOnly(left: 150),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Text(
                        languageController.textTranslate("Sponsor"),
                        style: AppTypography.text10Medium(context).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: roleController.isSponsor.value
                              ? Appcolors.appTextColor.textWhite
                              : Appcolors.appPriSecColor.appPrimblue,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        languageController.textTranslate("Subscription"),
                        style: AppTypography.text10Medium(context).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: !roleController.isSponsor.value
                              ? Appcolors.appTextColor.textWhite
                              : Appcolors.appPriSecColor.appPrimblue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).paddingAll(2),
        ),
      );
    });
  }
}
