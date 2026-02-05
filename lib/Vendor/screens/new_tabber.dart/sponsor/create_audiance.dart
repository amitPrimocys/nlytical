// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/controllers/vendor_controllers/campaign_controller.dart';
import 'package:nlytical/utils/global.dart';

class CreateAudiance extends StatefulWidget {
  String? latt;
  String? lonn;
  String? vendorid;
  String? serviceid;
  String? addrss;
  String? distance;
  String? mindistance;
  CreateAudiance({
    super.key,
    this.latt,
    this.lonn,
    this.vendorid,
    this.serviceid,
    this.addrss,
    this.distance,
    this.mindistance,
  });

  @override
  State<CreateAudiance> createState() => _CreateAudianceState();
}

class _CreateAudianceState extends State<CreateAudiance> {
  TextEditingController usernamecontroller = TextEditingController();
  FocusNode usernamepassFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();

  CampaignController campaignController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      bottomNavigationBar: button(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Create audience"),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizeBoxHeight(40),
            globalTextField2(
              lable: languageController.textTranslate('Campaign Name'),
              lable2: " *",
              controller: usernamecontroller,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(usernamepassFocusNode);
              },
              maxLength: 30,
              focusNode: usernameFocusNode,
              hintText: languageController.textTranslate(
                'Enter campaign title',
              ),
              context: context,
            ).paddingSymmetric(horizontal: 20),
            sizeBoxHeight(15),
            label(
              languageController.textTranslate('Audience Details'),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textColor: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
            ).paddingSymmetric(horizontal: 20),
            sizeBoxHeight(15),
            Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.darkGray,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.black.withValues(alpha: 0.1),
                    blurRadius: 14,
                    spreadRadius: 0,
                    offset: const Offset(4, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  label(
                    languageController.textTranslate('Location'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: Get.width * 0.50,
                      child: label(
                        widget.addrss.toString(),
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(123, 123, 123, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ).paddingSymmetric(horizontal: 20),
            sizeBoxHeight(15),
            Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.darkGray,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.black.withValues(alpha: 0.1),
                    blurRadius: 14,
                    spreadRadius: 0,
                    offset: const Offset(4, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  label(
                    languageController.textTranslate('Area'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                    ),
                  ),
                  label(
                    "${widget.distance.toString()}Kms",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(123, 123, 123, 1),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ).paddingSymmetric(horizontal: 20),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Obx(() {
      return campaignController.isLoading.value
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
                if (usernamecontroller.text.trim().isEmpty) {
                  snackBar(
                    languageController.textTranslate(
                      'Please enter the campaign name',
                    ),
                  );
                } else {
                  campaignController.addCampaignApi(
                    addres: widget.addrss,
                    areadistance: '${widget.mindistance},${widget.distance}',
                    lat: widget.latt,
                    lon: widget.lonn,
                    campaignName: usernamecontroller.text,
                  );
                }
              },
              title: languageController.textTranslate('Next'),
              fontSize: 15,
              weight: FontWeight.w400,
              radius: BorderRadius.circular(10),
              width: Get.width,
              height: getProportionateScreenHeight(40),
            ).paddingOnly(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              left: 60,
              right: 60,
            );
    });
  }
}
