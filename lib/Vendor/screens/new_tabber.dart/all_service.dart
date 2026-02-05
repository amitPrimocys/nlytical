// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/add_service2.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/service_controller.dart';
import 'package:nlytical/models/vendor_models/service_list_model.dart';
// import 'package:nlytical/Vendor/screens/new_tabber.dart/service_detail.dart';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/my_widget.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';

class AllServiceScreen extends StatefulWidget {
  const AllServiceScreen({super.key});

  @override
  State<AllServiceScreen> createState() => _AllServiceScreenState();
}

class _AllServiceScreenState extends State<AllServiceScreen> {
  ServiceController serviceController = Get.find();

  @override
  void initState() {
    serviceController.serviceListApi();
    super.initState();
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
          leading: customeBackArrow().paddingAll(13),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("All Service"),
            style: poppinsFont(20, Appcolors.white, FontWeight.w500),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // if (isDemo == "false") {
                //   serviceController.serviceIndex.value = -1;
                //   Get.to(() => const AddSrvice2(isvalue: false));
                // } else {
                //   snackBar("This is for demo, We can not allow to add");
                // }
                Get.to(() => const AddSrvice2(isvalue: false));
              },
              child: Image.asset(AppAsstes.addservice, height: 24),
            ).paddingOnly(right: 10, left: 10),
          ],
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: innerContainer(
        child: SingleChildScrollView(
          child: Obx(() {
            return serviceController.isGetData.value &&
                    serviceController.serviceList.isEmpty
                ? ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return shimmerLoader(
                        getProportionateScreenHeight(280),
                        Get.width,
                        10,
                      ).paddingOnly(bottom: 20, left: 20, right: 20);
                    },
                  )
                : serviceController.serviceList.isNotEmpty
                ? ListView.builder(
                    itemCount: serviceController.serviceList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return containerDesing(
                        serviceController.serviceList[index],
                        index,
                      ).paddingOnly(bottom: 20);
                    },
                  ).paddingSymmetric(horizontal: 20, vertical: 20)
                : Column(
                    children: [
                      sizeBoxHeight(200),
                      SizedBox(
                        height: 100,
                        child: Image.asset(
                          AppAsstes.emptyImage,
                          // width: 200,
                          // height: 180,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      Center(
                        child: Text(
                          languageController.textTranslate("No Service Found"),
                          style: poppinsFont(
                            13,
                            Appcolors.appTextColor.textLighGray,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                      sizeBoxHeight(30),
                      CustomButtom(
                        title: languageController.textTranslate("Add Service"),
                        onPressed: () {
                          // if (isDemo == "false") {
                          //   serviceController.serviceIndex.value = -1;
                          //   Get.to(() => const AddSrvice2(isvalue: false));
                          // } else {
                          //   snackBar(
                          //     "This is for demo, We can not allow to add",
                          //   );
                          // }
                          Get.to(() => const AddSrvice2(isvalue: false));
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
      ),
    );
  }

  Widget containerDesing(ServiceList serviceList, index) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => const Details());
        Get.to(
          Details(serviceid: serviceList.id.toString(), isVendorService: true),
          transition: Transition.rightToLeft,
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: getProportionateScreenHeight(300),
            decoration: BoxDecoration(
              color: Appcolors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 0,
                  color: themeContro.isLightMode.value
                      ? Appcolors.grey300
                      : const Color(0xff0000000f),
                  offset: const Offset(0.0, 3.0),
                ),
              ],
              image: DecorationImage(
                image: serviceList.storeImages!.isNotEmpty
                    ? NetworkImage(serviceList.storeImages![0].url!)
                    : const AssetImage(AppAsstes.add_business1),
                onError: (exception, stackTrace) => Image.asset(
                  AppAsstes.add_business1,
                  height: getProportionateScreenHeight(27),
                  width: getProportionateScreenWidth(27),
                ),
                fit: BoxFit.fill,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          Positioned.fill(
            top: 20,
            bottom: -1,
            child: FeaturedScreen(
              sname: serviceList.storeName.toString(),
              price: serviceList.price.toString(),
              desc: serviceList.storeDescription.toString(),
            ),
          ),
          serviceList.subcategoryName!.isEmpty
              ? SizedBox.shrink()
              : Positioned(
                  top: 10,
                  child: Container(
                    height: getProportionateScreenHeight(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                      color: Appcolors.appPriSecColor.appPrimblue,
                    ),
                    child: Center(
                      child: Text(
                        serviceList.subcategoryName!,
                        style: poppinsFont(9, Appcolors.white, FontWeight.w600),
                      ),
                    ).paddingSymmetric(horizontal: 4),
                  ),
                ),
          Positioned(
            right: 10,
            top: 5,
            child: GestureDetector(
              onTap: () {
                // edit_and_review(index);
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: AlertDialog(
                        alignment: Alignment.bottomCenter,
                        insetPadding: const EdgeInsets.only(
                          bottom: 20,
                          left: 10,
                          right: 10,
                        ),
                        contentPadding: EdgeInsets.zero,
                        backgroundColor: Appcolors.appBgColor.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: StatefulBuilder(
                          builder: (context, kk) {
                            return SingleChildScrollView(
                              child: Container(
                                height: getProportionateScreenHeight(110),
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: themeContro.isLightMode.value
                                      ? Appcolors.white
                                      : Appcolors.darkGray,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    sizeBoxHeight(3),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        // if (isDemo == "false") {
                                        //   serviceController.serviceIndex.value =
                                        //       index;
                                        //   Get.to(
                                        //     () =>
                                        //         const AddSrvice2(isvalue: true),
                                        //   )!.then((_) {
                                        //     setState(() {
                                        //       serviceController.serviceListModel
                                        //           .refresh();
                                        //       serviceController.serviceList
                                        //           .refresh();
                                        //       // Get.back();
                                        //     });
                                        //   });
                                        // } else {
                                        //   snackBar(
                                        //     "This is for demo, We can not allow to edit",
                                        //   );
                                        // }
                                        serviceController.serviceIndex.value =
                                            index;
                                        Get.to(
                                          () => const AddSrvice2(isvalue: true),
                                        )!.then((_) {
                                          setState(() {
                                            serviceController.serviceListModel
                                                .refresh();
                                            serviceController.serviceList
                                                .refresh();
                                            // Get.back();
                                          });
                                        });
                                        // Get.to(AddSrvice());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: Row(
                                          children: [
                                            sizeBoxWidth(10),
                                            Image.asset(
                                              'assets/images/edit-2.png',
                                              color:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors
                                                        .appPriSecColor
                                                        .appPrimblue
                                                  : Appcolors.white,
                                              height: 20,
                                            ),
                                            sizeBoxWidth(15),
                                            label(
                                              languageController.textTranslate(
                                                'Edit',
                                              ),
                                              fontSize: 14,
                                              textColor:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors.black
                                                  : Appcolors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    sizeBoxHeight(3),
                                    Divider(
                                      color: themeContro.isLightMode.value
                                          ? const Color(0xffF1F1F1)
                                          : Appcolors.grey1,
                                      height: 1,
                                    ),
                                    sizeBoxHeight(2),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        if (isDemo == "false") {
                                          bottomSheetGobal(
                                            context,
                                            bottomsheetHeight: 250,
                                            title: languageController
                                                .textTranslate(
                                                  "Remove Service",
                                                ),
                                            child: openBottomDailog(
                                              serviceList,
                                              index,
                                            ),
                                          );
                                        } else {
                                          snackBar(
                                            "This is for demo, We can not allow to delete",
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: Row(
                                          children: [
                                            sizeBoxWidth(10),
                                            Image.asset(
                                              'assets/images/trash1.png',
                                              height: 20,
                                              color:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors
                                                        .appPriSecColor
                                                        .appPrimblue
                                                  : Appcolors.white,
                                            ),
                                            sizeBoxWidth(15),
                                            label(
                                              languageController.textTranslate(
                                                'Delete',
                                              ),
                                              fontSize: 14,
                                              textColor:
                                                  themeContro.isLightMode.value
                                                  ? Appcolors.black
                                                  : Appcolors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Appcolors.appBgColor.transparent,
                ),
                child: Icon(
                  Icons.more_vert,
                  color: Appcolors.appPriSecColor.appPrimblue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column openBottomDailog(ServiceList serviceList, index) {
    return Column(
      children: [
        sizeBoxHeight(20),
        Center(
          child: Text(
            languageController.textTranslate(
              "Are you sure you want to \nRemove Service?",
            ),
            textAlign: TextAlign.center,
            style: poppinsFont(
              16,
              themeContro.isLightMode.value
                  ? Appcolors.greyColor
                  : Appcolors.white,
              FontWeight.w500,
            ),
          ),
        ),
        sizeBoxHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonBorder(
              title: languageController.textTranslate("Cancel"),
              onPressed: () => Get.back(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: getProportionateScreenHeight(42),
              width: getProportionateScreenWidth(140),
              fontColor: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
            ),
            sizeBoxWidth(25),
            CustomButtom(
              title: languageController.textTranslate("Delete"),
              onPressed: () async {
                serviceController.serviceList.removeAt(index);
                serviceController.deleteserviceApi(
                  storeid: serviceList.id.toString(),
                );
                Get.back();
                snackBar(
                  languageController.textTranslate(
                    'Service deleted successfully',
                  ),
                );
              },
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: getProportionateScreenHeight(42),
              width: getProportionateScreenWidth(140),
            ),
          ],
        ),
      ],
    );
  }
}
