// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:ui';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/add_service2.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/service_controller.dart';
import 'package:nlytical/models/vendor_models/service_list_model.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/my_widget.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';

class SearchServiceScreen extends StatefulWidget {
  const SearchServiceScreen({super.key});

  @override
  State<SearchServiceScreen> createState() => _SearchServiceScreenState();
}

class _SearchServiceScreenState extends State<SearchServiceScreen> {
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
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Search Service"),
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
          children: [
            sizeBoxHeight(20),
            searchBar(),
            sizeBoxHeight(20),
            Expanded(
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
                      : serviceController
                            .serviceListModel
                            .value
                            .serviceList!
                            .isNotEmpty
                      ? ListView.builder(
                          itemCount: serviceController
                              .serviceListModel
                              .value
                              .serviceList!
                              .length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return containerDesing(
                              serviceController
                                  .serviceListModel
                                  .value
                                  .serviceList![index],
                              index,
                            ).paddingOnly(bottom: 20);
                          },
                        ).paddingSymmetric(horizontal: 20)
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              sizeBoxHeight(190),
                              SizedBox(
                                height: 100,
                                child: Image.asset(
                                  AppAsstes.emptyImage,
                                  fit: BoxFit.contain,
                                  gaplessPlayback: true,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                              label(
                                languageController.textTranslate(
                                  "No Data Found",
                                ),
                                fontSize: 15,
                                textColor: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        );
                }),
              ),
            ),
            sizeBoxHeight(25),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: TextField(
        controller: serviceController.searchController,
        style: poppinsFont(
          13,
          themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
          FontWeight.w500,
        ),
        onChanged: (value) {
          (serviceController.serviceListModel.value.serviceList == null ||
                      serviceController.isGetData.value) &&
                  (serviceController.serviceListModel.value.serviceList ==
                          null ||
                      serviceController
                          .serviceListModel
                          .value
                          .serviceList!
                          .isEmpty)
              ? null
              : setState(() {
                  serviceController.filterSearchPeople();
                });
        },
        decoration: InputDecoration(
          fillColor: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkMainBlack,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Appcolors.appPriSecColor.appPrimblue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeContro.isLightMode.value
                  ? Appcolors.grey300
                  : Appcolors.darkGray,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolors.greyColor, width: 5),
          ),
          hintText: languageController.textTranslate("Search Services"),
          hintStyle: poppinsFont(13, Appcolors.grey400, FontWeight.w500),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 15, top: 15),
            child: Image.asset(
              AppAsstes.search,
              color: Appcolors.grey400,
              height: 10,
            ),
          ),
        ),
      ).paddingSymmetric(horizontal: 10),
    );
  }

  Widget containerDesing(ServiceList serviceList, index) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => Details(
            isVendorService: true,
            serviceid: serviceList.id.toString(),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: getProportionateScreenHeight(280),
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
                                        serviceController.serviceList.removeAt(
                                          index,
                                        );
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
}
