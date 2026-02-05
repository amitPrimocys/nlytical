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

class BusinessWebsite extends StatefulWidget {
  const BusinessWebsite({super.key});

  @override
  State<BusinessWebsite> createState() => _BusinessWebsiteState();
}

class _BusinessWebsiteState extends State<BusinessWebsite> {
  StoreController storeController = Get.find();
  final websiteController = TextEditingController();

  final webFocus = FocusNode();
  final webFocus1 = FocusNode();

  @override
  void initState() {
    websiteController.text = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].contactDetails!.serviceWebsite.toString()
        : '';
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
          title: Text(
            languageController.textTranslate("Business Website"),
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
                      " ${languageController.textTranslate("Please provide the URL of your business website so customers can reach you.")}",
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
              globalTextField3(
                lable: languageController.textTranslate("Add Business Website"),
                controller: websiteController,
                onEditingComplete: () {
                  Focus.of(context).requestFocus(webFocus);
                },
                isOnlyRead: isDemo == "false" ? false : true,
                onTap: () {
                  if (isDemo == "true") {
                    snackBar("This is for demo, We can not allow to edit");
                  }
                },
                focusNode: webFocus1,
                hintText: 'Website',
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
                    if (websiteController.text.trim().isEmpty) {
                      snackBar(
                        languageController.textTranslate(
                          "Please add you business website",
                        ),
                      );
                    } else {
                      storeController.storeWebSiteUpdateApi(
                        storeWebSite: websiteController.text,
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
