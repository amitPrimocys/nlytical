// ignore_for_file: avoid_print, must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/controllers/vendor_controllers/budget_controller.dart';
import 'package:nlytical/utils/global.dart';

class BudgetDuration extends StatefulWidget {
  String? campaignid;
  BudgetDuration({super.key, this.campaignid});

  @override
  State<BudgetDuration> createState() => _BudgetDurationState();
}

class _BudgetDurationState extends State<BudgetDuration> {
  BudgetController budgetcontro = Get.find();

  TextEditingController startcontroller = TextEditingController();
  FocusNode startnamepassFocusNode = FocusNode();
  FocusNode startnameFocusNode = FocusNode();

  TextEditingController endcontroller = TextEditingController();
  FocusNode endnamepassFocusNode = FocusNode();
  FocusNode endnameFocusNode = FocusNode();

  int _selectedIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;

  int getDaysCount(String startDate, String endDate) {
    try {
      final dateFormat = DateFormat("yyyy-MM-dd");

      final start = dateFormat.parse(startDate);
      final end = dateFormat.parse(endDate);

      return end.difference(start).inDays + 1;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime today = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? today : _startDate ?? today,
      firstDate: isStartDate ? today : _startDate ?? today,
      lastDate: isStartDate
          ? DateTime(2101)
          : _startDate!.add(const Duration(days: 30)),
      selectableDayPredicate: (DateTime day) {
        if (isStartDate) {
          return day.isAfter(today.subtract(const Duration(days: 1)));
        } else {
          return day.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
              day.isBefore(_startDate!.add(const Duration(days: 31)));
        }
      },
      builder: (context, child) {
        return Theme(
          data: themeContro.isLightMode.value
              ? ThemeData.light().copyWith(
                  primaryColor: Appcolors.appPriSecColor.appPrimblue,
                  colorScheme: ColorScheme.light(
                    primary: Appcolors.appPriSecColor.appPrimblue,
                  ),
                  buttonTheme: const ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                  ),
                )
              : ThemeData.dark().copyWith(
                  primaryColor: Appcolors.appPriSecColor.appPrimblue,
                  colorScheme: ColorScheme.dark(
                    primary: Appcolors.appPriSecColor.appPrimblue,
                  ),
                  buttonTheme: const ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                  ),
                ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          startcontroller.text =
              '${_startDate!.day.toString().padLeft(2, '0')}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.year}';
          _endDate = null;
          endcontroller.text = '';
        } else {
          _endDate = pickedDate;
          endcontroller.text =
              '${_endDate!.day.toString().padLeft(2, '0')}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.year}';
        }

        // Update slider max value
        if (_startDate != null && _endDate != null) {
          int diffDays = _endDate!.difference(_startDate!).inDays;
          _selectedIndex = diffDays;
          _sliderMax = 30.0;
        }
      });
    }
  }

  double _sliderMax = 1.0;

  int getTotalDays() {
    if (_startDate == null || _endDate == null) return 1;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  int getSelectedDay() {
    return _selectedIndex + 0; // 1-based index
  }

  String getSelectedPrice() {
    if (_selectedIndex >= 0 && _selectedIndex < budgetcontro.getbudget.length) {
      return budgetcontro.getbudget[_selectedIndex].price.toString();
    }
    return "0"; // Default if nothing is found
  }

  double getTotalPrice() {
    if (budgetcontro.getbudget.isNotEmpty &&
        _startDate != null &&
        _endDate != null) {
      int totalDays =
          _endDate!.difference(_startDate!).inDays + 0; // Including start day
      double startPrice = (budgetcontro.getbudget.first.price ?? 0)
          .toDouble(); // Ensure it's double
      return startPrice * totalDays;
    }
    return 0.0; // Default if data is missing
  }

  @override
  @override
  void initState() {
    budgetcontro.getbudgetAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.appBgColor.darkMainBlack,
      bottomNavigationBar: BottomAppBar(
        color: Appcolors.appBgColor.transparent,
        height: 70,
        child: button(),
      ).paddingOnly(bottom: 30),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Budget & duration"),
            style: AppTypography.h1(context).copyWith(color: Appcolors.white),
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
          return budgetcontro.isloading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                )
              : Column(
                  children: [
                    sizeBoxHeight(30),
                    Text(
                      languageController.textTranslate(
                        'What’s your ad budget?',
                      ),
                      style: AppTypography.h3(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    sizeBoxHeight(10),
                    Text(
                      languageController.textTranslate(
                        'Excludes apple service fee and applicable taxes',
                      ),
                      style: AppTypography.text12Medium(context),
                    ),
                    sizeBoxHeight(30),
                    Row(
                      children: [
                        Expanded(
                          child: globalTextField(
                            lable: languageController.textTranslate(
                              'Start Date',
                            ),
                            lable2: " *",
                            controller: startcontroller,
                            onTap: () => _selectDate(context, true),
                            isOnlyRead: true,
                            onEditingComplete: () {
                              FocusScope.of(
                                context,
                              ).requestFocus(startnamepassFocusNode);
                            },
                            focusNode: startnameFocusNode,
                            hintText: _startDate == null
                                ? languageController.textTranslate('Start Date')
                                : "${_startDate!.toLocal()}".split(' ')[0],
                            context: context,
                          ).paddingOnly(left: 20, right: 10),
                        ),
                        Expanded(
                          child: globalTextField(
                            lable: languageController.textTranslate('End Date'),
                            lable2: " *",
                            controller: endcontroller,
                            onTap: () => _selectDate(context, false),
                            isOnlyRead: true,
                            onEditingComplete: () {
                              FocusScope.of(
                                context,
                              ).requestFocus(endnamepassFocusNode);
                            },
                            focusNode: endnameFocusNode,
                            hintText: _endDate == null
                                ? languageController.textTranslate('End Date')
                                : "${_endDate!.toLocal()}".split(' ')[0],
                            context: context,
                          ).paddingOnly(left: 10, right: 20),
                        ),
                      ],
                    ),
                    sizeBoxHeight(20),
                    Container(
                      height: 125,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Appcolors.black12,
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/Frame (4).png',
                                color: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.appPriSecColor.appPrimblue,
                                height: 15,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                languageController.textTranslate(
                                  "Daily Budget",
                                ),
                                style: AppTypography.text12Medium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 18),
                          const SizedBox(height: 15),

                          /// **Day Row**
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${budgetcontro.getbudget.first.days}",
                                style: AppTypography.text10Medium(context)
                                    .copyWith(
                                      color:
                                          Appcolors.appTextColor.textLighGray,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                "${getDaysCount(_startDate.toString(), _endDate.toString())} Days",
                                style: AppTypography.text10Medium(context)
                                    .copyWith(
                                      color:
                                          Appcolors.appPriSecColor.appPrimblue,
                                    ),
                              ),
                              Text(
                                "30 Days",
                                style: AppTypography.text10Medium(context)
                                    .copyWith(
                                      color:
                                          Appcolors.appTextColor.textLighGray,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 10),

                          IgnorePointer(
                            ignoring: true,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                    Appcolors.appPriSecColor.appPrimblue,
                                inactiveTrackColor: Appcolors.grey,
                                inactiveTickMarkColor:
                                    Appcolors.appPriSecColor.appPrimblue,
                                thumbColor:
                                    Appcolors.appPriSecColor.appPrimblue,
                                overlayColor:
                                    Appcolors.appPriSecColor.appPrimblue,
                                activeTickMarkColor:
                                    Appcolors.appPriSecColor.appPrimblue,
                                overlappingShapeStrokeColor:
                                    Appcolors.appPriSecColor.appPrimblue,
                              ),
                              child: Slider(
                                padding: EdgeInsets.zero,
                                value: _selectedIndex.toDouble(),
                                min: 0,
                                max: _sliderMax,
                                onChanged: (double value) {},
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 20),

                          /// **Price Row**
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${budgetcontro.getbudget.first.price}",
                                style: AppTypography.text10Medium(context)
                                    .copyWith(
                                      color:
                                          Appcolors.appTextColor.textLighGray,
                                    ),
                              ),

                              label(
                                "\$ ${getSelectedPrice()}",
                                style: AppTypography.text10Medium(context)
                                    .copyWith(
                                      color:
                                          Appcolors.appPriSecColor.appPrimblue,
                                    ),
                              ),
                              Text(
                                "\$${budgetcontro.getbudget.last.price}",
                                style: AppTypography.text10Medium(context)
                                    .copyWith(
                                      color:
                                          Appcolors.appTextColor.textLighGray,
                                    ),
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 10),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 20),
                    const SizedBox(height: 20),
                  ],
                );
        }),
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: () {
        if (startcontroller.text.isEmpty || endcontroller.text.isEmpty) {
          snackBar(
            languageController.textTranslate(
              'Please select both Start Date and End Date',
            ),
          );
        } else {
          budgetcontro.addBudgetApi(
            campaignID: widget.campaignid,
            startDate: startcontroller.text,
            endDate: endcontroller.text,
            // dayss: getSelectedDay().toString(),
            dayss: getDaysCount(
              _startDate.toString(),
              _endDate.toString(),
            ).toString(),
            pricee: getSelectedPrice(),
          );
        }
      },
      child: Obx(
        () => budgetcontro.isLoading.value
            ? SizedBox(
                height: 50,
                width: 50,
                child: Center(child: commonLoading()),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 20,
                right: 20,
              )
            : Container(
                height: 30,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Appcolors.appPriSecColor.appPrimblue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: label(
                    languageController.textTranslate('Next'),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    textColor: Appcolors.white,
                  ),
                ),
              ).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}
