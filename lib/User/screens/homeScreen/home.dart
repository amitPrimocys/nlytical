// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nlytical/User/screens/controller/user_tab_controller.dart';
import 'package:nlytical/User/screens/homeScreen/near_by_store.dart';
import 'package:nlytical/Vendor/screens/auth/subcription.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/controllers/user_controllers/home_contro.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/auth/login.dart';
import 'package:nlytical/User/screens/categories/subcategories.dart';
import 'package:nlytical/User/screens/homeScreen/details.dart';
import 'package:nlytical/User/screens/homeScreen/find_store.dart';
import 'package:nlytical/User/screens/homeScreen/search.dart';
import 'package:nlytical/User/screens/settings/profile.dart';
import 'package:nlytical/User/screens/shimmer_loader/home_Loader.dart';
import 'package:nlytical/controllers/vendor_controllers/lang_controller.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_screen.dart';
import 'package:nlytical/utils/comman_screen_new.dart';
import 'package:nlytical/utils/comman_widgets.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/spinkit_loader.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';
import 'package:nlytical/utils/image_slide_show/src/image_slideshow.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchcontroller = TextEditingController();
  FocusNode passFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  HomeContro homecontro = Get.find();
  // NearbyContro nearcontro = Get.find();
  LikeContro likecontro = Get.find();
  GetprofileContro getprofilecontro = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userTextDirection.isEmpty && userTextDirection == "") {
        Get.find<LanguageController>().getLanguages;
        Get.find<LanguageController>().getLanguageTranslation();
        Get.find<LanguageController>().loadTextDirection();
      }
      apis();
    });
    super.initState();
  }

  Future<void> apis() async {
    if (userID.isNotEmpty) {
      getprofilecontro.getprofileApi();
    }
    await homecontro.homeApi(
      latitudee: userLatitude,
      longitudee: userLongitude,
    );
  }

  File? selectedImages;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Appcolors.appPriSecColor.appPrimblue,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkMainBlack,

        body: Column(
          children: [
            myLocationWidget(),
            sizeBoxHeight(25),
            Expanded(
              child: Obx(() {
                return (homecontro.ishome.value &&
                        homecontro.homemodel.value!.categories == null &&
                        homecontro.homemodel.value!.latestService == null)
                    ? homeLoader(context)
                    : RefreshIndicator(
                        color: Appcolors.appPriSecColor.appPrimblue,
                        onRefresh: () async {
                          await homecontro.homeApi(
                            latitudee: userLatitude,
                            longitudee: userLongitude,
                          );
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              homecontro.homemodel.value!.slides == null
                                  ? SizedBox.shrink()
                                  : homecontro
                                        .homemodel
                                        .value!
                                        .slides!
                                        .isNotEmpty
                                  ? _poster2(context)
                                  : SizedBox.shrink(),
                              sizeBoxHeight(8),
                              category(),
                              isStoreGlobal == 0
                                  ? addStoreBanner()
                                  : SizedBox.shrink(),
                              sizeBoxHeight(15),
                              nearby(),
                              sizeBoxHeight(18),
                              store(),
                              sizeBoxHeight(65),
                            ],
                          ),
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget myLocationWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: getProportionateScreenHeight(170),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAsstes.line_design),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Appcolors.appPriSecColor.appPrimblue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeBoxHeight(60),
                    Obx(() {
                      return homecontro.ishome.value &&
                              // homecontro.homemodel.value == null &&
                              homecontro.homemodel.value!.firstName == null
                          ? Text(
                              "${languageController.textTranslate('Hello')},",
                              style: AppTypography.h1(context).copyWith(
                                color: Appcolors.appTextColor.textWhite,
                              ),
                            )
                          : userID.isEmpty
                          ? Text(
                              '${languageController.textTranslate('Hello')}, ${languageController.textTranslate('Guest')}',
                              style: AppTypography.h1(context).copyWith(
                                color: Appcolors.appTextColor.textWhite,
                              ),
                            )
                          : Text(
                              '${languageController.textTranslate('Hello')}, $userName',
                              style: AppTypography.h1(context).copyWith(
                                color: Appcolors.appTextColor.textWhite,
                              ),
                            );
                    }),
                    RichText(
                      maxLines: 1,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: InkWell(
                              onTap: () {
                                homecontro.checkLocationPermission(
                                  isRought: true,
                                );
                              },
                              child: Image.asset(
                                'assets/images/location1.png',
                                height: 16,
                                color: Appcolors.white,
                              ),
                            ),
                          ),
                          WidgetSpan(child: sizeBoxWidth(2)),
                          TextSpan(
                            text: homecontro.currentAddress,
                            style: AppTypography.text11Regular(
                              context,
                            ).copyWith(color: Appcolors.appTextColor.textWhite),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              userID.isEmpty
                  ? Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Appcolors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(AppAsstes.default_user1),
                      ),
                    )
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Appcolors.white,
                      ),
                      child: Obx(() {
                        return getprofilecontro.isprofile.value
                            ? Center(
                                child: SpinKitSpinningLines(
                                  size: 30,
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (await SecurePrefs.getInt(
                                        SecureStorageKeys.ISGUEST,
                                      ) ==
                                      1) {
                                    await SecurePrefs.clear();
                                    Get.to(
                                      const Login(isLogin: true),
                                      transition: Transition.rightToLeft,
                                    );
                                  } else {
                                    Get.to(
                                      () => const Profile(),
                                      transition: Transition.rightToLeft,
                                    );
                                  }
                                },
                                child: ClipOval(
                                  child: (Image.network(
                                    userIMAGE,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (
                                          BuildContext ctx,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: SpinKitSpinningLines(
                                                size: 30,
                                                color: Appcolors
                                                    .appPriSecColor
                                                    .appPrimblue,
                                              ),
                                            );
                                          }
                                        },
                                    errorBuilder:
                                        (
                                          BuildContext? context,
                                          Object? exception,
                                          StackTrace? stackTrace,
                                        ) {
                                          return Container(
                                            height:
                                                getProportionateScreenHeight(
                                                  40,
                                                ),
                                            width: getProportionateScreenWidth(
                                              40,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Appcolors
                                                  .appOppaColor
                                                  .appPrimOppacity,
                                            ),
                                            child: Center(
                                              child: Text(
                                                getFirstCapitalLetter(
                                                  userFirstName,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Poppins",
                                                  color: Appcolors
                                                      .appTextColor
                                                      .textBlack,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                  )),
                                ),
                              );
                      }),
                    ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
        Positioned(bottom: -17, left: 9, child: searchBar()),
      ],
    );
  }

  Widget searchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: TextField(
        controller: searchcontroller,
        onTap: () {
          Get.to(() => const Search());
        },
        cursorColor: themeContro.isLightMode.value
            ? Appcolors.appBgColor.transparent
            : Appcolors.white,
        readOnly: true,
        style: poppinsFont(
          13,
          themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
          FontWeight.w500,
        ),
        decoration: InputDecoration(
          fillColor: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeContro.isLightMode.value
                  ? Appcolors.grey300
                  : Appcolors.darkGray,
              width: 1.5,
            ),
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
          hintText: languageController.textTranslate("Search Store"),
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

  Widget category() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languageController.textTranslate('Category'),
              style: AppTypography.text14Medium(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            InkWell(
              onTap: () {
                Get.find<UserTabController>().currentTabIndex.value = 2;
              },
              child: Text(
                languageController.textTranslate('See all'),
                style: AppTypography.text11Regular(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appPriSecColor.appPrimblue
                      : Appcolors.appTextColor.textWhite,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 20),
        sizeBoxHeight(18),
        homecontro.categories.isNotEmpty
            ? Container(
                height: Get.height * 0.26,
                decoration: BoxDecoration(
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.darkMainBlack,
                ),
                child: GridView.builder(
                  itemCount: homecontro.categories.length.clamp(0, 6),
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return cateWidgets(
                      context,
                      imagepath: homecontro.categories[index].categoryImage
                          .toString(),
                      cname: homecontro
                          .categories[index]
                          .categoryName!
                          .capitalizeFirst
                          .toString(),
                      cateOnTap: () {
                        Get.to(
                          SubCategories(
                            cat: homecontro.categories[index].id.toString(),
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                    );
                  },
                ).paddingSymmetric(horizontal: 25),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: SizedBox(
                    height: 100,
                    child: label(
                      languageController.textTranslate("No Category Found"),
                      fontSize: 16,
                      textColor: themeContro.isLightMode.value
                          ? Appcolors.brown
                          : Appcolors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget addStoreBanner() {
    return Container(
      height: getProportionateScreenHeight(100),
      decoration: BoxDecoration(
        color: Appcolors.color53ABFD.withValues(alpha: 0.65),
        image: DecorationImage(
          image: AssetImage("assets/images/banner2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  languageController.textTranslate(
                    "Become Vendor To Add Store",
                  ),
                  style: AppTypography.text14Medium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                sizeBoxHeight(10),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                  width: getProportionateScreenWidth(110),
                  child: CustomButtom(
                    borderRadius: 5,
                    title: languageController.textTranslate(
                      "Click To Register",
                    ),
                    onPressed: () {
                      if (userID.isEmpty) {
                        snackBar(
                          languageController.textTranslate(
                            'Please login to access to add store',
                          ),
                        );
                        loginPopup(bottomsheetHeight: Get.height * 0.95);
                      } else {
                        Get.to(
                          () => SubscriptionSceen(),
                          transition: Transition.rightToLeft,
                        );
                      }
                    },
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    height: getProportionateScreenHeight(20),
                    width: getProportionateScreenWidth(100),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nearby() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languageController.textTranslate('Nearby Stores'),
              style: AppTypography.text14Medium(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            homecontro.nearbylist.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      Get.to(
                        const NearByStore(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Text(
                      languageController.textTranslate('See all'),
                      style: AppTypography.text11Regular(context).copyWith(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appPriSecColor.appPrimblue
                            : Appcolors.appTextColor.textWhite,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ).paddingSymmetric(horizontal: 20),
        const SizedBox(height: 15),
        homecontro.nearbylist.isNotEmpty
            ? SizedBox(
                height: 310,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  itemCount: homecontro.nearbylist.length.clamp(0, 7),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CommanScreenNew(
                        lat: homecontro.nearbylist[index].lat ?? "0.0",
                        lon: homecontro.nearbylist[index].lon ?? "0.0",
                        storeImages: homecontro
                            .nearbylist[index]
                            .serviceImages![0]
                            .toString(),
                        cname: homecontro.nearbylist[index].categoryName
                            .toString(),
                        sname: homecontro.nearbylist[index].serviceName
                            .toString(),
                        vname: homecontro.nearbylist[index].vendorFirstName
                            .toString(),
                        vendorImages: homecontro.nearbylist[index].vendorImage
                            .toString(),
                        year:
                            '${homecontro.nearbylist[index].totalYearsCount} Years in Business',
                        ratingCount:
                            homecontro
                                .nearbylist[index]
                                .totalAvgReview!
                                .isNotEmpty
                            ? double.parse(
                                homecontro.nearbylist[index].totalAvgReview!,
                              )
                            : 0,
                        avrageReview: homecontro
                            .nearbylist[index]
                            .totalReviewCount!
                            .toString(),
                        isfeatured:
                            homecontro.nearbylist[index].isFeatured ?? 0,
                        isLike: userID.isEmpty
                            ? 0
                            : homecontro.nearbylist[index].isLike!,
                        onTaplike: () {
                          if (userID.isEmpty) {
                            snackBar('Please login to like this service');
                            loginPopup(bottomsheetHeight: Get.height * 0.95);
                          } else {
                            likecontro.likeApi(
                              homecontro.nearbylist[index].id.toString(),
                            );

                            // Toggle the isLike value for the UI update (you may want to update this dynamically after the API call succeeds)
                            setState(() {
                              homecontro.nearbylist[index].isLike =
                                  homecontro.nearbylist[index].isLike == 0
                                  ? 1
                                  : 0;

                              for (
                                int i = 0;
                                i < homecontro.allcatelist.length;
                                i++
                              ) {
                                if (homecontro.allcatelist[i].id ==
                                    homecontro.nearbylist[index].id) {
                                  homecontro.allcatelist[i].isLike =
                                      homecontro.nearbylist[index].isLike;
                                }
                              }
                            });
                          }
                        },
                        onTapstore: () {
                          Get.to(
                            Details(
                              serviceid: homecontro.nearbylist[index].id
                                  .toString(),
                              isVendorService: false,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        location: homecontro.nearbylist[index].address
                            .toString(),
                        price:
                            'From ${homecontro.nearbylist[index].priceRange}',
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: SizedBox(
                    height: 100,
                    child: label(
                      languageController.textTranslate("No Nearby Store Found"),
                      fontSize: 16,
                      textColor: themeContro.isLightMode.value
                          ? Appcolors.brown
                          : Appcolors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget store() {
    return Column(
      children: [
        sizeBoxHeight(3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languageController.textTranslate('Find Your Perfect Store'),
              style: AppTypography.text14Medium(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            homecontro.allcatelist.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      Get.to(
                        const FindStore(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Text(
                      languageController.textTranslate('See all'),
                      style: AppTypography.text11Regular(context).copyWith(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appPriSecColor.appPrimblue
                            : Appcolors.appTextColor.textWhite,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ).paddingSymmetric(horizontal: 20),
        sizeBoxHeight(22),
        homecontro.allcatelist.isNotEmpty
            ? GridView.builder(
                itemCount: homecontro.allcatelist.length.clamp(0, 4),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items in a row
                  childAspectRatio: 0.58, // Adjust for image and text ratio
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return CommanScreen(
                    lat: homecontro.allcatelist[index].lat ?? "0.0",
                    lon: homecontro.allcatelist[index].lon ?? "0.0",
                    storeImages: homecontro.allcatelist[index].serviceImages![0]
                        .toString(),
                    sname: homecontro
                        .allcatelist[index]
                        .serviceName!
                        .capitalizeFirst
                        .toString(),
                    cname: homecontro
                        .allcatelist[index]
                        .categoryName!
                        .capitalizeFirst
                        .toString(),
                    vname: homecontro.allcatelist[index].vendorFirstName
                        .toString(),
                    vendorImages: homecontro.allcatelist[index].vendorImage
                        .toString(),
                    isfeatured: homecontro.allcatelist[index].isFeatured ?? 0,
                    ratingCount:
                        homecontro.allcatelist[index].totalAvgReview!.isNotEmpty
                        ? double.parse(
                            homecontro.allcatelist[index].totalAvgReview!,
                          )
                        : 0,
                    avrageReview: homecontro
                        .allcatelist[index]
                        .totalReviewCount!
                        .toString(),
                    isLike: userID.isEmpty
                        ? 0
                        : homecontro.allcatelist[index].isLike!,
                    onTaplike: () {
                      if (userID.isEmpty) {
                        snackBar('Please login to like this service');
                        loginPopup(bottomsheetHeight: Get.height * 0.95);
                      } else {
                        if (homecontro.nearbylist.isNotEmpty) {
                          for (
                            var i = 0;
                            i < homecontro.nearbylist.length;
                            i++
                          ) {
                            if (homecontro.nearbylist.isNotEmpty) {
                              for (
                                var i = 0;
                                i < homecontro.nearbylist.length;
                                i++
                              ) {
                                if (homecontro.allcatelist[index].id ==
                                    homecontro.nearbylist[i].id) {
                                  if (homecontro.nearbylist[i].isLike == 0) {
                                    homecontro.nearbylist[i].isLike = 1;
                                  } else {
                                    homecontro.nearbylist[i].isLike = 0;
                                  }
                                  homecontro.nearbylist.refresh();
                                }
                              }
                            } else {
                              for (
                                var i = 0;
                                i < homecontro.allcatelist.length;
                                i++
                              ) {
                                if (homecontro.allcatelist[index].id ==
                                    homecontro.allcatelist[i].id) {
                                  homecontro.allcatelist[i].isLike == 0
                                      ? homecontro.allcatelist[i].isLike = 1
                                      : homecontro.allcatelist[i].isLike = 0;
                                }
                                homecontro.nearbylist.refresh();
                              }
                            }
                            if (homecontro.allcatelist[index].id ==
                                homecontro.nearbylist[i].id) {
                              if (homecontro.nearbylist[i].isLike == 0) {
                                homecontro.nearbylist[i].isLike = 1;
                              } else {
                                homecontro.nearbylist[i].isLike = 0;
                              }
                              homecontro.nearbylist.refresh();
                            }
                          }
                        } else {
                          for (
                            var i = 0;
                            i < homecontro.allcatelist.length;
                            i++
                          ) {
                            if (homecontro.allcatelist[index].id ==
                                homecontro.allcatelist[i].id) {
                              homecontro.allcatelist[i].isLike == 0
                                  ? homecontro.allcatelist[i].isLike = 1
                                  : homecontro.allcatelist[i].isLike = 0;
                            }
                            homecontro.nearbylist.refresh();
                          }
                        }
                        likecontro.likeApi(
                          homecontro.allcatelist[index].id.toString(),
                        );
                        setState(() {
                          homecontro.allcatelist[index].isLike =
                              homecontro.allcatelist[index].isLike == 0 ? 1 : 0;
                          if (homecontro.nearbylist.isNotEmpty) {
                            for (
                              int i = 0;
                              i < homecontro.allcatelist.length;
                              i++
                            ) {
                              if (homecontro.allcatelist[i].id ==
                                  homecontro.nearbylist[index].id) {
                                homecontro.allcatelist[i].isLike =
                                    homecontro.nearbylist[index].isLike;
                              }
                              homecontro.nearbylist.refresh();
                            }
                          } else {
                            for (
                              var i = 0;
                              i < homecontro.allcatelist.length;
                              i++
                            ) {
                              if (homecontro.allcatelist[index].id ==
                                  homecontro.allcatelist[i].id) {
                                homecontro.allcatelist[i].isLike == 0
                                    ? homecontro.allcatelist[i].isLike = 1
                                    : homecontro.allcatelist[i].isLike = 0;
                              }
                              homecontro.nearbylist.refresh();
                            }
                          }
                        });
                      }
                    },
                    onTapstore: () {
                      Get.to(
                        Details(
                          serviceid: homecontro.allcatelist[index].id
                              .toString(),
                          isVendorService: false,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    location: homecontro.allcatelist[index].address.toString(),
                    price: 'From ${homecontro.allcatelist[index].priceRange}',
                  );
                },
              ).paddingSymmetric(horizontal: 15)
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: SizedBox(
                    height: 100,
                    child: label(
                      languageController.textTranslate(
                        "No Perfect Store Found",
                      ),
                      fontSize: 16,
                      textColor: Appcolors.brown,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  final List<String> images = [
    'assets/images/Frame 3398.png',
    'assets/images/Frame 3398.png',
    'assets/images/Frame 3398.png',
  ];

  Widget _poster2(BuildContext context) {
    Widget carousel =
        homecontro.homemodel.value!.slides == null ||
            homecontro.homemodel.value!.slides!.isEmpty
        ? postershimmer(context, imageUrls)
        : Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Appcolors.grey100),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(11)),
                  child: ImageSlideshow(
                    initialPage: 0,
                    autoPlayInterval: 3000,
                    isLoop: homecontro.homemodel.value!.slides!.length > 1,
                    indicatorColor: Appcolors.white,
                    indicatorBackgroundColor: Appcolors.grey400,
                    indicatorRadius: 3,

                    children: homecontro.homemodel.value!.slides!.map((img) {
                      return CachedNetworkImage(
                        imageUrl: img, // Use the image URL from your API
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return shimmerLoader(200, 200, 10);
                        },
                        errorWidget: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.error,
                              color: Appcolors.appTextColor.textRedColor,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );

    return Container(
      height: 200,
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: carousel.paddingSymmetric(horizontal: 10),
      ),
    );
  }

  Widget postershimmer(BuildContext context, List<String> imageUrls) {
    Widget carousel = Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: ImageSlideshow(
            initialPage: 0, // You can set this to any valid index
            autoPlayInterval: 3000,
            isLoop: true,
            indicatorColor: Appcolors.white,
            indicatorBackgroundColor: Appcolors.grey400,
            indicatorRadius: 3,
            children: imageUrls.map((img) {
              return Shimmer.fromColors(
                baseColor: themeContro.isLightMode.value
                    ? Appcolors.grey300
                    : Appcolors.white12,
                highlightColor: themeContro.isLightMode.value
                    ? Appcolors.grey100
                    : Appcolors.white24,
                child: Container(
                  height: 200,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Appcolors.grey300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );

    return Container(
      height: 200,
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: carousel.paddingSymmetric(horizontal: 10),
      ),
    );
  }
}
