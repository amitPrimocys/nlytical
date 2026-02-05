// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:html/parser.dart' as parser;

import '../../../../utils/flexible_space.dart';
import '../../../../utils/global.dart';

class BusinessNameScreen extends StatefulWidget {
  const BusinessNameScreen({super.key});

  @override
  State<BusinessNameScreen> createState() => _BusinessNameScreenState();
}

class _BusinessNameScreenState extends State<BusinessNameScreen> {
  StoreController storeController = Get.find();
  final businessnameController = TextEditingController();
  final businessdescController = TextEditingController();

  final name = FocusNode();
  final name1 = FocusNode();
  final desc = FocusNode();
  final desc1 = FocusNode();

  @override
  void initState() {
    businessnameController.text = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].businessDetails!.serviceName ?? ""
        : "";
    var details = convertHtmlToText(
      storeController.storeList[0].businessDetails!.serviceDescription!,
    );
    businessdescController.text = storeController.storeList.isNotEmpty
        ? details
        : "";
    super.initState();
  }

  String convertHtmlToText(String htmlString) {
    var document = parser.parse(htmlString);

    return document.body!.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.appBgColor.darkMainBlack,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: appbarTitle(
            context,
            title: languageController.textTranslate("Business Name"),
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
                title: languageController.textTranslate("Business Detail"),
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
                          " ${languageController.textTranslate("Enter your business name exactly how you would like it to look to all users.")}",
                    ),
                  ),
                ],
              ),
              sizeBoxHeight(30),
              globalTextField(
                lable: languageController.textTranslate("Business Name"),
                lable2: " *",
                controller: businessnameController,
                onEditingComplete: () {
                  Focus.of(context).requestFocus(name);
                },
                isOnlyRead: isDemo == "false" ? false : true,
                onTap: () {
                  if (isDemo == "true") {
                    snackBar("This is for demo, We can not allow to edit");
                  }
                },
                isEmail: false,
                isNumber: false,
                focusNode: name1,
                hintText: languageController.textTranslate("Business Name"),
                context: context,
              ),
              sizeBoxHeight(20),
              globalTextField(
                lable: languageController.textTranslate("Business Description"),
                lable2: " *",
                maxLines: 4,
                controller: businessdescController,
                onEditingComplete: () {
                  Focus.of(context).requestFocus(desc);
                },
                isOnlyRead: isDemo == "false" ? false : true,
                onTap: () {
                  if (isDemo == "true") {
                    snackBar("This is for demo, We can not allow to edit");
                  }
                },
                isEmail: false,
                isNumber: false,
                focusNode: desc1,
                hintText: languageController.textTranslate(
                  "Business Description",
                ),
                context: context,
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
                    if (businessnameController.text.trim().isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please add you business name",
                        ),
                      );
                    } else if (businessdescController.text.trim().isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please add you business description",
                        ),
                      );
                    } else {
                      storeController.storeNameUpdateApi(
                        storeName: businessnameController.text,
                        storeDesc: businessdescController.text,
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
