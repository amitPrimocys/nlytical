// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/insights_controller.dart';
import 'package:nlytical/models/vendor_models/insights_model.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../controllers/vendor_controllers/insights_controller.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  InsightsController insightsController = Get.find();

  // late ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    insightsController.selectionBehavior = SelectionBehavior(enable: true);
    insightsController.selectedMonthValue.value =
        insightsController.monthList[now.month - 1];
    String fullMonthName =
        insightsController.fullMonthList[insightsController.monthList.indexOf(
          insightsController.selectedMonthValue.value,
        )];
    insightsController.graphApi(monthName: fullMonthName).then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.appBgColor.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("View Insights"),
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
          return Stack(
            children: [
              Column(
                children: [
                  sizeBoxHeight(10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languageController.textTranslate("Overview"),
                                style: AppTypography.h3(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Text(
                                    languageController.textTranslate("Monthly"),
                                    style: AppTypography.text12Medium(
                                      context,
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 80,
                                    height: 32,
                                    child: FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                            fillColor:
                                                themeContro.isLightMode.value
                                                ? Appcolors
                                                      .appPriSecColor
                                                      .appPrimblue
                                                      .withValues(alpha: 0.10)
                                                : Appcolors.darkGray,
                                            filled: true,
                                            errorStyle: TextStyle(
                                              color: Appcolors
                                                  .appTextColor
                                                  .textRedColor,
                                              fontSize: 16.0,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          isEmpty:
                                              insightsController
                                                  .selectedMonthValue
                                                  .value ==
                                              '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              dropdownColor:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors.white
                                                  : Appcolors.darkGray,
                                              menuMaxHeight:
                                                  getProportionateScreenHeight(
                                                    300,
                                                  ),
                                              icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                              ),
                                              iconEnabledColor:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors.black
                                                  : Appcolors.white,
                                              iconDisabledColor:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors.black
                                                  : Appcolors.white,
                                              value: insightsController
                                                  .selectedMonthValue
                                                  .value,
                                              isDense: true,
                                              hint: Text(
                                                "Select",
                                                style: poppinsFont(
                                                  12,
                                                  themeContro.isLightMode.value
                                                      ? Appcolors.black
                                                      : Appcolors.white,
                                                  FontWeight.w600,
                                                ),
                                              ),
                                              style: poppinsFont(
                                                12,
                                                themeContro.isLightMode.value
                                                    ? Appcolors.black
                                                    : Appcolors.white,
                                                FontWeight.w600,
                                              ),
                                              onChanged: (String? newValue) async {
                                                setState(() {
                                                  insightsController
                                                          .selectedMonthValue
                                                          .value =
                                                      newValue!;
                                                  state.didChange(newValue);
                                                  String fullMonthName =
                                                      insightsController
                                                          .fullMonthList[insightsController
                                                          .monthList
                                                          .indexOf(
                                                            insightsController
                                                                .selectedMonthValue
                                                                .value,
                                                          )];
                                                  insightsController.graphApi(
                                                    monthName: fullMonthName,
                                                  );
                                                });
                                              },
                                              items: insightsController
                                                  .monthList
                                                  .map((String month) {
                                                    return DropdownMenuItem(
                                                      value: month,
                                                      child: Text(
                                                        month.toString(),
                                                        style: poppinsFont(
                                                          12,
                                                          themeContro
                                                                  .isLightMode
                                                                  .value
                                                              ? Appcolors.black
                                                              : Appcolors.white,
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                    );
                                                  })
                                                  .toList(),
                                            ),
                                          ),
                                        );
                                      },
                                      validator: (value) {
                                        if (insightsController
                                                    .selectedMonthValue
                                                    .value ==
                                                null ||
                                            insightsController
                                                .selectedMonthValue
                                                .value!
                                                .isEmpty) {
                                          return languageController
                                              .textTranslate(
                                                'Please select a month',
                                              );
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ).paddingOnly(left: 20, right: 20, top: 20),
                          const SizedBox(height: 30),
                          Container(
                            height: Get.height * 0.14,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 20.23,
                                  offset: const Offset(0, 0),
                                  spreadRadius: 0,
                                  color: themeContro.isLightMode.value
                                      ? Appcolors.grey300
                                      : Appcolors
                                            .appShadowColor
                                            .darkShadowColor,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: themeContro.isLightMode.value
                                  ? Appcolors.white
                                  : Appcolors.appBgColor.darkGray,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                rowWidget(
                                  title: languageController.textTranslate(
                                    "Store Visits",
                                  ),
                                  count: insightsController.isLoading.value
                                      ? "0"
                                      : insightsController
                                            .model
                                            .value
                                            .countRetrieved!
                                            .storevisits
                                            .toString(),
                                ),
                                Divider(
                                  color: themeContro.isLightMode.value
                                      ? Appcolors.appStrokColor.cF0F0F0
                                      : Appcolors.appStrokColor.darkgray2,
                                ).paddingSymmetric(horizontal: 20),
                                rowWidget(
                                  title: languageController.textTranslate(
                                    "Number of Favorites",
                                  ),
                                  count: insightsController.isLoading.value
                                      ? "0"
                                      : insightsController
                                            .model
                                            .value
                                            .countRetrieved!
                                            .storelikes
                                            .toString(),
                                ),
                                Divider(
                                  color: themeContro.isLightMode.value
                                      ? Appcolors.appStrokColor.cF0F0F0
                                      : Appcolors.appStrokColor.darkgray2,
                                ).paddingSymmetric(horizontal: 20),
                                rowWidget(
                                  title: languageController.textTranslate(
                                    "Leads Received",
                                  ),
                                  count: insightsController.isLoading.value
                                      ? "0"
                                      : insightsController
                                            .model
                                            .value
                                            .countRetrieved!
                                            .leads
                                            .toString(),
                                ),
                              ],
                            ),
                          ).paddingSymmetric(horizontal: 20),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languageController.textTranslate(
                                  "Number of users visits daily",
                                ),
                                style: AppTypography.h3(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(),
                            ],
                          ).paddingSymmetric(horizontal: 20),
                          sizeBoxHeight(20),
                          //**************************************** CHART **************************************************/
                          //**************************************** CHART **************************************************/
                          //**************************************** CHART **************************************************/
                          SfCartesianChart(
                            enableAxisAnimation: true,
                            enableSideBySideSeriesPlacement: true,
                            onPlotAreaSwipe: (ChartSwipeDirection direction) =>
                                insightsController.performSwipe(direction),
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePanning: true,
                              enablePinching: true,
                              enableSelectionZooming: true,
                            ),
                            primaryXAxis: const CategoryAxis(
                              isVisible: true,
                              interval: 1,
                              labelRotation: 0,
                              autoScrollingMode: AutoScrollingMode.start,
                              autoScrollingDelta:
                                  7, // Show 7 days (1 week) at a time
                            ),
                            primaryYAxis: NumericAxis(
                              initialVisibleMaximum:
                                  insightsController.axisVisibleMax,
                              initialVisibleMinimum:
                                  insightsController.axisVisibleMin,

                              onRendererCreated:
                                  (NumericAxisController controller) {
                                    insightsController.axisController =
                                        controller;
                                  },
                              majorGridLines: const MajorGridLines(width: 0),
                              minorGridLines: const MinorGridLines(width: 0),
                            ),
                            legend: const Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            loadMoreIndicatorBuilder:
                                (
                                  BuildContext context,
                                  ChartSwipeDirection direction,
                                ) {
                                  if (direction == ChartSwipeDirection.end) {
                                    insightsController
                                        .loadNextWeek(); // Load next week when swiping right to left
                                  } else if (direction ==
                                      ChartSwipeDirection.start) {
                                    insightsController
                                        .loadPreviousWeek(); // Load previous week when swiping left to right
                                  }
                                  return const SizedBox.shrink();
                                },
                            series: <CartesianSeries<Graphdata, String>>[
                              AreaSeries<Graphdata, String>(
                                selectionBehavior:
                                    insightsController.selectionBehavior,
                                enableTooltip: true,
                                animationDuration: 300,
                                isVisibleInLegend: false,
                                gradient: LinearGradient(
                                  colors: [
                                    Appcolors.appChartColor.cADB7F9,
                                    Appcolors.appChartColor.cB1B9F8,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                dataSource: insightsController.graphdataList,
                                xValueMapper: (Graphdata data, _) {
                                  try {
                                    DateTime parsedDate = insightsController
                                        .parseDate(data.date!);
                                    return DateFormat("d MMM").format(
                                      parsedDate,
                                    ); // Format as '1 Mar', '2 Mar', etc.
                                  } catch (e) {
                                    return '';
                                  }
                                },
                                yValueMapper: (Graphdata data, _) =>
                                    data.userVisits,
                                name: 'User Visits',
                                dataLabelSettings: DataLabelSettings(
                                  showZeroValue: false,
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Appcolors.appPriSecColor.appPrimblue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          customBtn(
                            onTap: () {},
                            title: languageController.textTranslate(
                              "Already sponsored",
                            ),
                            fontSize: 14,
                            weight: FontWeight.w700,
                            radius: BorderRadius.circular(10),
                            width: Get.width,
                            height: Get.height * 0.06,
                          ).paddingSymmetric(horizontal: 22),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              insightsController.isLoading.value
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.2),
                        child: Center(child: commonLoading()),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        }),
      ),
    );
  }

  Widget buildLoadMoreView(
    BuildContext context,
    ChartSwipeDirection direction,
  ) {
    if (direction == ChartSwipeDirection.end) {
      return FutureBuilder<String>(
        future: _loadNextWeekData(), // Load next week's data
        builder: (BuildContext futureContext, AsyncSnapshot<String> snapShot) {
          return snapShot.connectionState != ConnectionState.done
              ? const CircularProgressIndicator()
              : SizedBox.fromSize(size: Size.zero);
        },
      );
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }

  Future<String> _loadNextWeekData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    if (insightsController.weeksData.isNotEmpty) {
      int currentWeekIndex = insightsController.weeksData.indexWhere(
        (week) => week == insightsController.graphdataList,
      );

      if (currentWeekIndex != -1 &&
          currentWeekIndex < insightsController.weeksData.length - 1) {
        // Load next week's data
        insightsController.graphdataList.assignAll(
          insightsController.weeksData[currentWeekIndex + 1],
        );
      }
    }

    return "Next week loaded";
  }

  rowWidget({required String title, required String count}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.text12Medium(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          count,
          style: AppTypography.text12Medium(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    ).paddingSymmetric(horizontal: 22);
  }
}
