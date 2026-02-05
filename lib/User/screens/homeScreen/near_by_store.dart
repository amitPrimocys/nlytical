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

class NearByStore extends StatefulWidget {
  const NearByStore({super.key});

  @override
  State<NearByStore> createState() => _NearByStoreState();
}

class _NearByStoreState extends State<NearByStore> {
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
            languageController.textTranslate("Nearby Stores"),
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
            sizeBoxHeight(10),
            searchBar(),
            sizeBoxHeight(10),
            Expanded(
              child: SingleChildScrollView(child: Column(children: [store()])),
            ),
          ],
        ),
      ),
    );
  }

  Widget store() {
    return homecontro.nearbyFiltlist.isNotEmpty
        ? GridView.builder(
            itemCount: homecontro.nearbyFiltlist.length,
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
                lat: homecontro.nearbyFiltlist[index].lat ?? "0.0",
                lon: homecontro.nearbyFiltlist[index].lon ?? "0.0",
                storeImages: homecontro.nearbyFiltlist[index].serviceImages![0]
                    .toString(),
                sname: homecontro
                    .nearbyFiltlist[index]
                    .serviceName!
                    .capitalizeFirst
                    .toString(),
                cname: homecontro
                    .nearbyFiltlist[index]
                    .categoryName!
                    .capitalizeFirst
                    .toString(),
                vname: homecontro.nearbyFiltlist[index].vendorFirstName
                    .toString(),
                vendorImages: homecontro.nearbyFiltlist[index].vendorImage
                    .toString(),
                isfeatured: homecontro.nearbyFiltlist[index].isFeatured ?? 0,
                ratingCount:
                    homecontro.nearbyFiltlist[index].totalAvgReview!.isNotEmpty
                    ? double.parse(
                        homecontro.nearbyFiltlist[index].totalAvgReview!,
                      )
                    : 0,
                avrageReview: homecontro.nearbyFiltlist[index].totalReviewCount!
                    .toString(),
                isLike: userID.isEmpty
                    ? 0
                    : homecontro.nearbyFiltlist[index].isLike!,
                onTaplike: () {
                  if (userID.isEmpty) {
                    snackBar('Please login to like this service');
                    loginPopup(bottomsheetHeight: Get.height * 0.95);
                  } else {
                    likecontro.likeApi(
                      homecontro.nearbyFiltlist[index].id.toString(),
                    );

                    // Toggle the isLike value for the UI update (you may want to update this dynamically after the API call succeeds)
                    setState(() {
                      homecontro.nearbyFiltlist[index].isLike =
                          homecontro.nearbyFiltlist[index].isLike == 0 ? 1 : 0;

                      for (int i = 0; i < homecontro.allcatelist.length; i++) {
                        if (homecontro.allcatelist[i].id ==
                            homecontro.nearbyFiltlist[index].id) {
                          homecontro.allcatelist[i].isLike =
                              homecontro.nearbyFiltlist[index].isLike;
                        }
                      }
                    });
                  }
                },
                onTapstore: () {
                  Get.to(
                    Details(
                      serviceid: homecontro.nearbyFiltlist[index].id.toString(),
                      isVendorService: false,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                location: homecontro.nearbyFiltlist[index].address.toString(),
                price: 'From ${homecontro.nearbyFiltlist[index].priceRange}',
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
