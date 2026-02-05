// ignore_for_file: depend_on_referenced_packages, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';

class StoreTimeScreen extends StatefulWidget {
  const StoreTimeScreen({super.key});

  @override
  State<StoreTimeScreen> createState() => _StoreTimeScreenState();
}

class _StoreTimeScreenState extends State<StoreTimeScreen> {
  StoreController storeController = Get.find();

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final startPeriodController = TextEditingController();
  final endPeriodController = TextEditingController();

  bool isOpen = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeController.openDaysList.value = storeController.storeList.isNotEmpty
          ? storeController.storeList[0].businessTime!.openDays!
                .split(', ')
                .toList()
          : [];
      storeController.openingAndClosingDays.clear();
      storeController.openingAndClosingDays.addAll(
        storeController.openDaysList,
      );

      final today = DateFormat('E').format(DateTime.now()); // e.g., "Mon"
      setState(() {
        isOpen = storeController.openingAndClosingDays.contains(today);
      });

      startTimeController.text = storeController.storeList.isNotEmpty
          ? storeController.storeList[0].businessTime!.openTime!
          : "";

      endTimeController.text = storeController.storeList.isNotEmpty
          ? storeController.storeList[0].businessTime!.closeTime!
          : "";
    });

    super.initState();
  }

  TimeOfDay _selectedTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context, bool isForStartTime) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          color: themeContro.isLightMode.value
              ? CupertinoColors.systemBackground.resolveFrom(context)
              : Appcolors.darkGray,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: poppinsFont(
                  16,
                  themeContro.isLightMode.value
                      ? Appcolors.black
                      : Appcolors.white,
                  FontWeight.w500,
                ),
              ),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _selectedTime = TimeOfDay.fromDateTime(newDateTime);

                  // Format time as 12-hour with AM/PM using intl
                  String formattedTime = DateFormat.jm().format(
                    newDateTime,
                  ); // Example: 10:00 PM

                  if (isForStartTime) {
                    startTimeController.text = formattedTime;
                  } else {
                    endTimeController.text = formattedTime;
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: appbarTitle(
            context,
            title: languageController.textTranslate("Business Timings"),
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
                title: languageController.textTranslate("Business Timings"),
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
                          " ${languageController.textTranslate("Let your customers know when to reach you. you can also configure dual timing slots in a single day.")}",
                    ),
                  ),
                ],
              ),
              sizeBoxHeight(30),
              Text(
                languageController.textTranslate("Business Time"),
                style: poppinsFont(
                  14,
                  themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                  FontWeight.w600,
                ),
              ),
              sizeBoxHeight(20),
              twoText(
                fontWeight: FontWeight.w600,
                text1: languageController.textTranslate(
                  "Business Opening Hours",
                ),
                text2: " *",
                mainAxisAlignment: MainAxisAlignment.start,
                style1: AppTypography.outerMedium(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              sizeBoxHeight(7),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.grey1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(27),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: storeController.days.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Obx(
                            () => globButton(
                              onTap: () {
                                if (storeController.openingAndClosingDays
                                    .contains(storeController.days[index])) {
                                  storeController.openingAndClosingDays.remove(
                                    storeController.days[index],
                                  );
                                  final today = DateFormat(
                                    'E',
                                  ).format(DateTime.now()); // e.g., "Mon"
                                  setState(() {
                                    isOpen = storeController
                                        .openingAndClosingDays
                                        .contains(today);
                                  });
                                } else {
                                  storeController.openingAndClosingDays.add(
                                    storeController.days[index],
                                  );
                                  final today = DateFormat(
                                    'E',
                                  ).format(DateTime.now()); // e.g., "Mon"
                                  setState(() {
                                    isOpen = storeController
                                        .openingAndClosingDays
                                        .contains(today);
                                  });
                                }
                              },
                              name: storeController.days[index],
                              isOuntLined:
                                  storeController.openingAndClosingDays
                                      .contains(storeController.days[index])
                                  ? false
                                  : true,
                              gradient:
                                  storeController.openingAndClosingDays
                                      .contains(storeController.days[index])
                                  ? Appcolors.logoColork
                                  : null,
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appPriSecColor.appPrimblue
                                        .withValues(alpha: 0.2)
                                  : Appcolors.grey1,
                              textStyle: AppTypography.text10Medium(context)
                                  .copyWith(
                                    color:
                                        storeController.openingAndClosingDays
                                            .contains(
                                              storeController.days[index],
                                            )
                                        ? Appcolors.appTextColor.textWhite
                                        : themeContro.isLightMode.value
                                        ? Appcolors.appTextColor.textBlack
                                        : Appcolors.appTextColor.textWhite,
                                  ),
                              radius: 5,
                              horizontal: 7,
                              vertical: 4,
                            ).paddingOnly(right: 10),
                          );
                        },
                      ),
                    ),
                    sizeBoxHeight(10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAsstes.infoCircle,
                          height: getProportionateScreenHeight(15),
                          width: getProportionateScreenWidth(15),
                        ),
                        sizeBoxWidth(9),
                        Expanded(
                          child: Text(
                            languageController.textTranslate(
                              'Select the multiple days you want to provide the service to the users',
                            ),
                            style: AppTypography.text8Medium(context).copyWith(
                              color: Appcolors.appTextColor.textLighGray,
                            ),

                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: globalTextField(
                            controller: startTimeController,
                            focusedBorderColor: Appcolors.appStrokColor.cF0F0F0,
                            onTap: () {
                              _selectTime(context, true);
                            },
                            isOnlyRead: true,
                            onEditingComplete: () {},
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 0,
                            ),
                            hintText: "Start Time",
                            context: context,
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(16),
                              child: Image.asset(
                                AppAsstes.clock,
                                fit: BoxFit.contain,
                                height: getProportionateScreenHeight(16),
                                width: getProportionateScreenWidth(16),
                                color: Appcolors.appExtraColor.cB4B4B41,
                              ),
                            ),
                          ),
                        ),
                        sizeBoxWidth(20),
                        Expanded(
                          child: globalTextField(
                            controller: endTimeController,
                            focusedBorderColor: Appcolors.appStrokColor.cF0F0F0,
                            onTap: () {
                              _selectTime(context, false);
                            },
                            isOnlyRead: true,
                            onEditingComplete: () {
                              // FocusScope.of(context).unfocus();
                            },
                            hintText: "End Time",
                            context: context,
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(16),
                              child: Image.asset(
                                AppAsstes.clock,
                                fit: BoxFit.contain,
                                height: getProportionateScreenHeight(16),
                                width: getProportionateScreenWidth(16),
                                color: Appcolors.appExtraColor.cB4B4B41,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 15, vertical: 15),
              ),
              sizeBoxHeight(20),
              twoText(
                text1: languageController.textTranslate(
                  "Select Days of the Week",
                ),
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
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.grey1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(27),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: storeController.days.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Obx(
                            () => globButton(
                              name: storeController.days[index],
                              isOuntLined:
                                  storeController.openingAndClosingDays.isEmpty
                                  ? true
                                  : storeController.openingAndClosingDays
                                        .contains(storeController.days[index])
                                  ? true
                                  : false,
                              gradient:
                                  storeController.openingAndClosingDays.isEmpty
                                  ? null
                                  : storeController.openingAndClosingDays
                                        .contains(storeController.days[index])
                                  ? null
                                  : Appcolors.logoColork,
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appPriSecColor.appPrimblue
                                        .withValues(alpha: 0.2)
                                  : Appcolors.grey1,
                              textStyle: AppTypography.text10Medium(context)
                                  .copyWith(
                                    color:
                                        storeController
                                            .openingAndClosingDays
                                            .isEmpty
                                        ? Appcolors.appTextColor.textBlack
                                        : storeController.openingAndClosingDays
                                              .contains(
                                                storeController.days[index],
                                              )
                                        ? themeContro.isLightMode.value
                                              ? Appcolors.appTextColor.textBlack
                                              : Appcolors.appTextColor.textWhite
                                        : Appcolors.appTextColor.textWhite,
                                  ),
                              radius: 5,
                              horizontal: 7,
                              vertical: 4,
                            ).paddingOnly(right: 10),
                          );
                        },
                      ),
                    ),
                    sizeBoxHeight(10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAsstes.infoCircle,
                          height: getProportionateScreenHeight(15),
                          width: getProportionateScreenWidth(15),
                        ),
                        sizeBoxWidth(9),
                        Expanded(
                          child: Text(
                            languageController.textTranslate(
                              'Select the multiple days you want to provide the service to the users',
                            ),
                            style: AppTypography.text8Medium(context).copyWith(
                              color: Appcolors.appTextColor.textLighGray,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    sizeBoxHeight(20),
                    Container(
                      height: 30,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Appcolors.appPriSecColor.appPrimblue,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // isOpen ? "Open" : "Closed",
                            "Closed",
                            style: AppTypography.text8Medium(context).copyWith(
                              fontSize: 10,
                              color: themeContro.isLightMode.value
                                  ? Appcolors.appTextColor.textBlack
                                  : Appcolors.appTextColor.textWhite,
                            ),
                          ),
                          sizeBoxWidth(8),
                          Image.asset(
                            AppAsstes.close,
                            height: getProportionateScreenHeight(16),
                            width: getProportionateScreenWidth(16),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 10),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 15, vertical: 15),
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
                    if (storeController.openingAndClosingDays.isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please select your business week timings",
                        ),
                      );
                    } else if (startTimeController.text.trim().isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please add your business start time",
                        ),
                      );
                    } else if (endTimeController.text.trim().isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please add your business end time",
                        ),
                      );
                    } else {
                      storeController.storeTimingsUpdateApi(
                        openDays: storeController.openingAndClosingDays
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', ''),
                        closedDays: storeController.days
                            .toSet()
                            .difference(
                              storeController.openingAndClosingDays.toSet(),
                            )
                            .toList()
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', ''),
                        openTime:
                            "${startTimeController.text.trim()} ${startPeriodController.text.trim()}",
                        closeTime:
                            "${endTimeController.text.trim()} ${endPeriodController.text.trim()}",
                      );
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
