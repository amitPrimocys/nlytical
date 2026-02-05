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

class StoreEmployee extends StatefulWidget {
  const StoreEmployee({super.key});

  @override
  State<StoreEmployee> createState() => _StoreEmployeeState();
}

class _StoreEmployeeState extends State<StoreEmployee> {
  StoreController storeController = Get.find();
  List<String> employeeList = [
    'Less than 10',
    '10-100',
    '100-500',
    '500-1000',
    '1000-2000',
    '2000-5000',
    '5000-10000',
    'More than 10000',
  ];

  @override
  void initState() {
    selectedVtypes = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].businessTime!.employeeStrength
        : '';
    super.initState();
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
          title: Text(
            languageController.textTranslate("Number of Employees"),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizeBoxHeight(30),
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
                    child: Text(
                      " ${languageController.textTranslate("Please select the number of employees at your company")}",
                      style: poppinsFont(
                        10,
                        themeContro.isLightMode.value
                            ? Appcolors.appPriSecColor.appPrimblue
                            : Appcolors.white,
                        FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              sizeBoxHeight(30),
              Text(
                languageController.textTranslate("Select Number of Employees"),
                style: poppinsFont(
                  14,
                  themeContro.isLightMode.value
                      ? Appcolors.black
                      : Appcolors.white,
                  FontWeight.w600,
                ),
              ),
              sizeBoxHeight(20),
              empWidget(),
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
                    if (selectedVtypes == "") {
                      snackBar("Please select  number of emplyees");
                    } else {
                      storeController.storeEmployeeUpdateApi(
                        storeEmplyee: selectedVtypes!,
                      );
                    }
                  } else {
                    snackBar("This is for demo, We can not allow to update");
                  }
                },
                title: "Save",
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

  String? selectedVtypes;
  Widget empWidget() {
    return ListView.builder(
      itemCount: employeeList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          height: getProportionateScreenHeight(43),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkGray,
            boxShadow: const [
              BoxShadow(
                blurRadius: 14.4,
                offset: Offset(2, 4),
                spreadRadius: 0,
                color: Color.fromRGBO(0, 0, 0, 0.06),
              ),
            ],
          ),
          child: Row(
            children: [
              Radio<String>(
                activeColor: Appcolors.appPriSecColor.appPrimblue,
                value: employeeList[index],
                groupValue: selectedVtypes,
                onChanged: (val) {
                  setState(() {
                    selectedVtypes = val!;
                  });
                },
              ),
              Text(
                employeeList[index],
                style: poppinsFont(
                  11,
                  themeContro.isLightMode.value
                      ? Appcolors.black
                      : Appcolors.white,
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ).paddingOnly(bottom: 10);
      },
    );
  }
}
