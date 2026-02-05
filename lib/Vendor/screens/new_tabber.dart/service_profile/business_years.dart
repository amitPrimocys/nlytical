import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';

class BusinessYears extends StatefulWidget {
  const BusinessYears({super.key});

  @override
  State<BusinessYears> createState() => _BusinessYearsState();
}

class _BusinessYearsState extends State<BusinessYears> {
  StoreController storeController = Get.find();

  final List<String> _monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  String? selectedMonthValue;

  final List<String> _yearList = List.generate(
    DateTime.now().year - 1950 + 1,
    (index) => (DateTime.now().year - index).toString(),
  );

  String? selectedYearValue; // To store the selected year

  @override
  void initState() {
    selectedMonthValue = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].businessTime!.publishedMonth ?? ''
        : null;
    selectedYearValue = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].businessTime!.publishedYear ?? ''
        : null;
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
            title: languageController.textTranslate("Year of Establishment"),
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
                title: languageController.textTranslate(
                  "Year of Establishment",
                ),
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
                          " ${languageController.textTranslate("Please note that any changes to the details below can go for verification and take upto 2 working days to go live.")}",
                    ),
                  ),
                ],
              ),
              sizeBoxHeight(30),
              monthYearWidget(),
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
                    if (selectedMonthValue == '') {
                      snackBar(
                        languageController.textTranslate(
                          "Please select your business start month",
                        ),
                      );
                    } else if (selectedYearValue == '') {
                      snackBar(
                        languageController.textTranslate(
                          "Please select your business startup year",
                        ),
                      );
                    } else {
                      storeController.storeMonthYearsUpdateApi(
                        month: selectedMonthValue!,
                        years: selectedYearValue!,
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

  DateTime currentDate = DateTime.now();
  Widget monthYearWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              twoText(
                fontWeight: FontWeight.w600,
                text1: languageController.textTranslate("Month"),
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
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      fillColor: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      filled: true,
                      errorStyle: TextStyle(
                        color: Appcolors.appTextColor.textRedColor,
                        fontSize: 16.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: themeContro.isLightMode.value
                              ? Appcolors.bluee4
                              : Appcolors.grey1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Appcolors.black,
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Appcolors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Appcolors.black),
                      ),
                    ),
                    isEmpty: selectedMonthValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        menuMaxHeight: getProportionateScreenHeight(300),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconEnabledColor: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.white,
                        iconDisabledColor: Appcolors.black,
                        value: selectedMonthValue,
                        isDense: true,
                        hint: Text(
                          "Select Store*",
                          style: AppTypography.text11Regular(context).copyWith(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textBlack
                                : Appcolors.appTextColor.textWhite,
                          ),
                        ),
                        style: AppTypography.text11Regular(context).copyWith(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                        ),
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedMonthValue = newValue!;
                            state.didChange(newValue);
                          });
                        },
                        items: _monthList.map((String month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text(
                              month.toString(),
                              style: AppTypography.text11Regular(context)
                                  .copyWith(
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.appTextColor.textBlack
                                        : Appcolors.appTextColor.textWhite,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: (value) {
                  if (selectedMonthValue!.isEmpty) {
                    selectedMonthValue = null;
                    return 'Please select a month';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        sizeBoxWidth(20),
        Expanded(
          child: Column(
            children: [
              twoText(
                fontWeight: FontWeight.w600,
                text1: languageController.textTranslate("Year"),
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
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      fillColor: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      filled: true,
                      errorStyle: TextStyle(
                        color: Appcolors.appTextColor.textRedColor,
                        fontSize: 16.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: themeContro.isLightMode.value
                              ? Appcolors.bluee4
                              : Appcolors.grey1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Appcolors.black,
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Appcolors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Appcolors.black),
                      ),
                    ),
                    isEmpty: selectedYearValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        menuMaxHeight: getProportionateScreenHeight(300),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconEnabledColor: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.white,
                        iconDisabledColor: Appcolors.black,
                        value: _yearList.contains(selectedYearValue)
                            ? selectedYearValue
                            : null,
                        isDense: true,
                        hint: Text(
                          "Select Year*",
                          style: AppTypography.text11Regular(context).copyWith(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textBlack
                                : Appcolors.appTextColor.textWhite,
                          ),
                        ),
                        style: AppTypography.text11Regular(context).copyWith(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                        ),
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedYearValue = newValue!;
                            state.didChange(newValue);
                          });
                        },
                        items: _yearList.toSet().map((String year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(
                              year,
                              style: AppTypography.text11Regular(context)
                                  .copyWith(
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.appTextColor.textBlack
                                        : Appcolors.appTextColor.textWhite,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: (value) {
                  if (selectedYearValue == null || selectedYearValue!.isEmpty) {
                    return 'Please select a year';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
