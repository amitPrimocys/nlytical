// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/home_contro.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_screen.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class FindStore extends StatefulWidget {
  const FindStore({super.key});

  @override
  State<FindStore> createState() => _FindStoreState();
}

class _FindStoreState extends State<FindStore> {
  HomeContro homecontro = Get.find();
  LikeContro likecontro = Get.find();
  final searchController = TextEditingController();

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
            languageController.textTranslate("Find Your Perfect Store"),
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
        child: Obx(() {
          return Column(
            children: [
              sizeBoxHeight(10),
              searchBar(),
              sizeBoxHeight(10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [store()]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget store() {
    return homecontro.filteredStores.isNotEmpty
        ? GridView.builder(
            itemCount: homecontro.filteredStores.length,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items in a row
              childAspectRatio: 0.58, // Adjust for image and text ratio
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return CommanScreen(
                lat: homecontro.filteredStores[index].lat ?? "0.0",
                lon: homecontro.filteredStores[index].lon ?? "0.0",
                storeImages: homecontro.filteredStores[index].serviceImages![0]
                    .toString(),
                sname: homecontro
                    .filteredStores[index]
                    .serviceName!
                    .capitalizeFirst
                    .toString(),
                cname: homecontro
                    .filteredStores[index]
                    .categoryName!
                    .capitalizeFirst
                    .toString(),
                vname: homecontro.filteredStores[index].vendorFirstName
                    .toString(),
                vendorImages: homecontro.filteredStores[index].vendorImage
                    .toString(),
                isfeatured: homecontro.filteredStores[index].isFeatured ?? 0,
                ratingCount:
                    homecontro.filteredStores[index].totalAvgReview!.isNotEmpty
                    ? double.parse(
                        homecontro.filteredStores[index].totalAvgReview!,
                      )
                    : 0,
                avrageReview: homecontro.filteredStores[index].totalReviewCount!
                    .toString(),
                isLike: userID.isEmpty
                    ? 0
                    : homecontro.filteredStores[index].isLike!,
                onTaplike: () {
                  if (userID.isEmpty) {
                    snackBar('Please login to like this service');
                    loginPopup(bottomsheetHeight: Get.height * 0.95);
                  } else {
                    for (var i = 0; i < homecontro.nearbylist.length; i++) {
                      if (homecontro.filteredStores[index].id ==
                          homecontro.nearbylist[i].id) {
                        if (homecontro.nearbylist[i].isLike == 0) {
                          homecontro.nearbylist[i].isLike = 1;
                        } else {
                          homecontro.nearbylist[i].isLike = 0;
                        }
                        homecontro.nearbylist.refresh();
                      }
                    }
                    likecontro.likeApi(
                      homecontro.filteredStores[index].id.toString(),
                    );

                    // Toggle the isLike value for the UI update (you may want to update this dynamically after the API call succeeds)
                    setState(() {
                      homecontro.filteredStores[index].isLike =
                          homecontro.filteredStores[index].isLike == 0 ? 1 : 0;
                      for (
                        int i = 0;
                        i < homecontro.filteredStores.length;
                        i++
                      ) {
                        if (homecontro.filteredStores[i].id ==
                            homecontro.nearbylist[index].id) {
                          homecontro.filteredStores[i].isLike =
                              homecontro.nearbylist[index].isLike;
                        }
                      }
                    });
                  }
                },
                onTapstore: () {
                  Get.to(
                    Details(
                      serviceid: homecontro.filteredStores[index].id.toString(),
                      isVendorService: false,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                location: homecontro.filteredStores[index].address.toString(),
                price: 'From ${homecontro.filteredStores[index].priceRange}',
              );
            },
          ).paddingSymmetric(horizontal: 15, vertical: 15)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizeBoxHeight(200),
                SizedBox(
                  height: 100,
                  child: Image.asset(
                    AppAsstes.emptyImage,
                    width: 200,
                    height: 180,
                  ),
                ),
                label(
                  languageController.textTranslate("No Data Found"),
                  fontSize: 15,
                  textColor: themeContro.isLightMode.value
                      ? Appcolors.black
                      : Appcolors.white,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          );
  }

  Widget searchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 0,
      child: TextField(
        controller: searchController,
        cursorColor: themeContro.isLightMode.value
            ? Appcolors.appPriSecColor.appPrimblue
            : Appcolors.white,
        onChanged: (value) {
          setState(() {
            homecontro.searchStores(value);
          });
        },
        style: poppinsFont(
          13,
          themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
          FontWeight.w500,
        ),
        decoration: InputDecoration(
          fillColor: themeContro.isLightMode.value
              ? const Color(0xffF3F3F3)
              : Appcolors.darkGray,
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
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolors.greyColor, width: 5),
          ),
          hintText: languageController.textTranslate("Search your store"),
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
      ).paddingSymmetric(horizontal: 20),
    );
  }
}
