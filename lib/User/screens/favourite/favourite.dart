// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/favourite_contro.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:nlytical/User/screens/shimmer_loader/favourite_loader.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_screen.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class Favourite extends StatefulWidget {
  bool tap = true;
  Favourite({super.key, required this.tap});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  FavouriteContro favcontro = Get.find();
  LikeContro likecontro = Get.find();

  @override
  void initState() {
    favcontro.favApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Favorites"),
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
        child: Column(
          children: [
            sizeBoxHeight(10),
            Expanded(child: SingleChildScrollView(child: favlist())),
          ],
        ),
      ),
    );
  }

  Widget favlist() {
    return Obx(() {
      return (favcontro.isfav.value)
          ? wishListLoader(context)
          : Column(children: [store()]);
    });
  }

  Widget store() {
    return favcontro.favemodel.value.serviceLikedList!.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            itemCount: favcontro.favemodel.value.serviceLikedList!.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58, // Adjust for image and text ratio
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return CommanScreen(
                lat:
                    favcontro.favemodel.value.serviceLikedList![index].lat ??
                    "0.0",
                lon:
                    favcontro.favemodel.value.serviceLikedList![index].lon ??
                    "0.0",
                storeImages: favcontro
                    .favemodel
                    .value
                    .serviceLikedList![index]
                    .serviceImages!,
                sname: favcontro
                    .favemodel
                    .value
                    .serviceLikedList![index]
                    .serviceName!
                    .capitalizeFirst
                    .toString(),
                cname: favcontro
                    .favemodel
                    .value
                    .serviceLikedList![index]
                    .categoryName!
                    .capitalizeFirst
                    .toString(),
                vname: favcontro
                    .favemodel
                    .value
                    .serviceLikedList![index]
                    .vendorFirstName
                    .toString(),
                vendorImages: favcontro
                    .favemodel
                    .value
                    .serviceLikedList![index]
                    .vendorImage
                    .toString(),
                isfeatured:
                    favcontro
                        .favemodel
                        .value
                        .serviceLikedList![index]
                        .isFeatured ??
                    0,
                ratingCount:
                    favcontro
                        .favemodel
                        .value
                        .serviceLikedList![index]
                        .totalAvgReview!
                        .isNotEmpty
                    ? double.parse(
                        favcontro
                            .favemodel
                            .value
                            .serviceLikedList![index]
                            .totalAvgReview!,
                      )
                    : 0,
                avrageReview: favcontro
                    .favemodel
                    .value
                    .serviceLikedList![index]
                    .totalReviewCount!
                    .toString(),
                isLike: 1,
                onTaplike: () {
                  likecontro.likeApi(
                    favcontro.favemodel.value.serviceLikedList![index].id
                        .toString(),
                  );
                  favcontro.favemodel.value.serviceLikedList!.removeAt(index);
                  favcontro.favemodel.refresh();
                  setState(() {});
                },
                onTapstore: () {
                  Get.to(
                    Details(
                      serviceid: favcontro
                          .favemodel
                          .value
                          .serviceLikedList![index]
                          .id
                          .toString(),
                      isVendorService: false,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                location: favcontro
                    .favemodel
                    .value
                    .serviceLikedList![index]
                    .address
                    .toString(),
                price: favcontro
                    .favemodel
                    .value
                    .serviceLikedList![index]
                    .priceRange
                    .toString(),
              );
            },
          ).paddingSymmetric(horizontal: 15)
        : favouriteempty();
  }

  Widget favouriteempty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizeBoxHeight(Get.height * 0.35),
          SizedBox(
            height: 100,
            child: Image.asset(
              AppAsstes.emptyImage,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              filterQuality: FilterQuality.high,
            ),
          ),
          sizeBoxHeight(10),
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
}
