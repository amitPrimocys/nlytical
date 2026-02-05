// ignore_for_file: must_be_immutable, prefer_const_constructors, override_on_non_overriding_member, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/shimmer_Loader/add_campaign_shimmer.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/controllers/vendor_controllers/campaign_controller.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/sponsor/budget_duration.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/sponsor/sponsor_explor.dart';
import 'package:nlytical/utils/global.dart';

class AddCampaign extends StatefulWidget {
  String? latt;
  String? lonn;
  String? vendorid;
  String? serviceid;
  String? addrss;
  AddCampaign({
    super.key,
    this.latt,
    this.lonn,
    this.vendorid,
    this.serviceid,
    this.addrss,
  });

  @override
  State<AddCampaign> createState() => _AddCampaignState();
}

class _AddCampaignState extends State<AddCampaign> {
  CampaignController campaignController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      campaignController.getCampaignApi(isHome: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.appBgColor.darkMainBlack,
      bottomNavigationBar: Obx(() {
        return campaignController.getLoading.value
            ? SizedBox.shrink()
            : campaignController.camplist.isNotEmpty
            ? BottomAppBar(
                color: themeContro.isLightMode.value
                    ? Appcolors.appBgColor.transparent
                    : Appcolors.appBgColor.darkMainBlack,
                height: 70,
                child: GestureDetector(
                  onTap: () {
                    if (campaignController.selectedIndex.value != null) {
                      Get.to(
                        BudgetDuration(
                          campaignid: campaignController
                              .camplist[campaignController.selectedIndex.value!]
                              .id
                              .toString(),
                        ),
                      );
                    } else {
                      snackBar("Please select campaigns");
                    }
                  },
                  child: Container(
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
              ).paddingOnly(bottom: 30)
            : SizedBox.shrink();
      }),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Add Campaign"),
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
          return campaignController.getLoading.value
              ? AddCampaignShimmer()
              : campaignController.camplist.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeBoxHeight(20),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => SponsorExplor(
                            latt: widget.latt,
                            lonn: widget.lonn,
                            serviceid: widget.serviceid,
                            vendorid: widget.vendorid,
                            addrss: widget.addrss,
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Appcolors.appPriSecColor.appPrimblue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/add.png', height: 20),
                              sizeBoxWidth(5),
                              Text(
                                languageController.textTranslate(
                                  'Add New Campaign',
                                ),
                                style: AppTypography.h3(context).copyWith(
                                  color: Appcolors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 20),
                    ),
                    sizeBoxHeight(20),
                    Text(
                      languageController.textTranslate('Campaigns'),
                      style: AppTypography.text16(context),
                    ).paddingSymmetric(horizontal: 20),
                    sizeBoxHeight(10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: campaignController.camplist.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                campaignController.selectedIndex.value = index;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: themeContro.isLightMode.value
                                    ? Appcolors.white
                                    : Appcolors.darkGray,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Appcolors.black.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 14,
                                    spreadRadius: 0,
                                    offset: const Offset(4, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 18,
                                        width: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Appcolors
                                                .appPriSecColor
                                                .appPrimblue,
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  campaignController
                                                          .selectedIndex
                                                          .value ==
                                                      index
                                                  ? Appcolors
                                                        .appPriSecColor
                                                        .appPrimblue
                                                  : Appcolors
                                                        .appBgColor
                                                        .transparent,
                                            ),
                                          ),
                                        ),
                                      ),

                                      sizeBoxWidth(10),
                                      Text(
                                        campaignController
                                            .camplist[index]
                                            .campaignName
                                            .toString(),
                                        style: AppTypography.text12Medium(
                                          context,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      // sizeBoxWidth(30),
                                    ],
                                  ).paddingSymmetric(horizontal: 10),
                                  SizedBox(
                                    width: Get.width - 230,
                                    child: Text(
                                      campaignController.camplist[index].address
                                          .toString(),
                                      maxLines: 2,
                                      style:
                                          AppTypography.text11Regular(
                                            context,
                                          ).copyWith(
                                            fontSize: 10,
                                            color: Appcolors
                                                .appTextColor
                                                .textLighGray,
                                          ),
                                    ),
                                  ),
                                ],
                              ).paddingOnly(right: 5),
                            ).paddingSymmetric(horizontal: 20, vertical: 5),
                          );
                        },
                      ),
                    ),
                    sizeBoxHeight(40),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/mic.png', height: 100),
                    sizeBoxHeight(10),
                    Text(
                      languageController.textTranslate(
                        'You don’t have any campaigns start creating one',
                      ),
                      textAlign: TextAlign.center,
                      style: AppTypography.text14Medium(context),
                    ).paddingSymmetric(horizontal: 50),
                    sizeBoxHeight(10),
                    CustomButtom(
                      title: languageController.textTranslate("Add Campaign"),
                      onPressed: () {
                        Get.to(
                          () => SponsorExplor(
                            latt: widget.latt,
                            lonn: widget.lonn,
                            serviceid: widget.serviceid,
                            vendorid: widget.vendorid,
                            addrss: widget.addrss,
                          ),
                        );
                      },
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: getProportionateScreenHeight(45),
                      width: getProportionateScreenWidth(200),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
