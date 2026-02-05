// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/add_review_contro.dart';
import 'package:nlytical/controllers/user_controllers/edit_review_contro.dart';
import 'package:nlytical/controllers/user_controllers/review_contro.dart';
import 'package:nlytical/User/screens/shimmer_loader/my_review_loader.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  ReviewContro reviewcontro = Get.find();
  int page = 1;
  bool isLoadingMore = false;
  // ItemScrollController _scrollController1 = ItemScrollController();
  final scrollController = ScrollController();

  AddreviewContro addreviewcontro = Get.find();
  EditReviewContro editreview = Get.find();

  final msgController = TextEditingController();

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    reviewcontro.reviewApi(page: page.toString());

    // Load initial data
    fetchRestaurants();

    super.initState();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true; // Start showing the loader
        page++; // Increment the page number
      });
      fetchRestaurants(); // Fetch next page data
    }
  }

  Future<void> fetchRestaurants() async {
    try {
      await reviewcontro.reviewApi(page: page.toString());

      setState(() {
        isLoadingMore = false;
      });
    } catch (error) {
      setState(() {
        isLoadingMore = false;
      });
      ("Error fetching data: $error");
    }
  }

  @override
  dispose() {
    scrollController.dispose();

    super.dispose();
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
            languageController.textTranslate("My Review"),
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
            Expanded(
              child: Obx(() {
                return reviewcontro.isfav.value
                    ? reviewlistLoader(context)
                    : SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [sizeBoxHeight(15), reeviewlist()],
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget reeviewlist() {
    return reviewcontro.riviewlist.isNotEmpty
        ? ListView.builder(
            itemCount: reviewcontro.riviewlist.length + 1,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (index == reviewcontro.riviewlist.length) {
                return isLoadingMore // Check if more data is being loaded
                    ? Center(
                        child: Column(
                          children: [
                            sizeBoxHeight(10),
                            CircularProgressIndicator(
                              color: Appcolors.appPriSecColor.appPrimblue,
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(); // If no more data, show nothing
              }
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  // height: Get.height * 0.19,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: themeContro.isLightMode.value
                        ? Appcolors.white
                        : Appcolors.darkGray,
                    border: Border.all(
                      color: themeContro.isLightMode.value
                          ? Appcolors.grey200
                          : Appcolors.appBgColor.transparent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Appcolors.black12,
                        blurRadius: 14,
                        spreadRadius: 0,
                        offset: Offset(2, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width * 0.9,
                          child: Text(
                            reviewcontro.riviewlist[index].serviceName
                                .toString(),
                            maxLines: 1,
                            style: AppTypography.text16Semi(
                              context,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ).paddingOnly(left: 3),
                        ),
                        sizeBoxHeight(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              itemPadding: const EdgeInsets.only(left: 1.5),
                              initialRating:
                                  reviewcontro.riviewlist[index].reviewStar
                                          .toString() !=
                                      ''
                                  ? double.parse(
                                      reviewcontro.riviewlist[index].reviewStar
                                          .toString(),
                                    )
                                  : 0.0,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 14.5,
                              ignoreGestures: true,
                              unratedColor: Appcolors.grey400,
                              itemBuilder: (context, _) => Image.asset(
                                AppAsstes.myReviewIcons.star,
                                height: 16,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(width: 4),
                            Text(
                              formatDateTime(
                                DateTime.parse(
                                  reviewcontro.riviewlist[index].createdAt!,
                                ),
                              ),
                              style: AppTypography.text9Regular(context)
                                  .copyWith(
                                    color: Appcolors.appTextColor.textLighGray,
                                  ),
                            ),
                          ],
                        ),
                        sizeBoxHeight(10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            reviewcontro.riviewlist[index].reviewMessage
                                .toString(),
                            style: AppTypography.text9Regular(
                              context,
                            ).copyWith(),
                          ),
                        ),
                        sizeBoxHeight(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                (reviewcontro.riviewlist[index].id);
                                deleteReviewAsk(index);
                              },
                              child: Container(
                                height: 32,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Appcolors.appPriSecColor.appPrimblue,
                                ),
                                child: Center(
                                  child: Text(
                                    languageController.textTranslate('Delete'),
                                    style: AppTypography.text11Regular(context)
                                        .copyWith(
                                          color:
                                              Appcolors.appTextColor.textWhite,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            sizeBoxWidth(10),
                            GestureDetector(
                              onTap: () {
                                editreview.reviewEditApi(
                                  isupdate: true,
                                  serviceId: reviewcontro
                                      .riviewlist[index]
                                      .serviceId
                                      .toString(),
                                  reviewid: reviewcontro.riviewlist[index].id
                                      .toString(),
                                );
                                ('Tapped');
                                _confirmReview(index);
                              },
                              child: Container(
                                height: 32,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: themeContro.isLightMode.value
                                        ? Appcolors.appPriSecColor.appPrimblue
                                        : Appcolors.white,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    languageController.textTranslate('Edit'),
                                    style: poppinsFont(
                                      11,
                                      themeContro.isLightMode.value
                                          ? Appcolors.appPriSecColor.appPrimblue
                                          : Appcolors.white,
                                      FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        sizeBoxHeight(10),
                      ],
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
              );
            },
          )
        : reviewempty();
  }

  Widget reviewempty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizeBoxHeight(300),
          SizedBox(
            height: 100,
            child: Image.asset(AppAsstes.emptyImage, width: 200, height: 180),
          ),
          label(
            languageController.textTranslate("Review not Found"),
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

  Future deleteReviewAsk(int index) {
    return bottomSheetGobal(
      context,
      bottomsheetHeight: getProportionateScreenHeight(300),
      title: languageController.textTranslate("Delete Review"),
      child: Column(
        children: [
          sizeBoxHeight(20),
          Center(
            child: Text(
              languageController.textTranslate(
                "Are you sure you want to Delete Review?",
              ),
              textAlign: TextAlign.center,
              style: poppinsFont(
                15,
                themeContro.isLightMode.value
                    ? Appcolors.appTextColor.textLighGray
                    : Appcolors.white,
                FontWeight.w500,
              ),
            ),
          ).paddingSymmetric(horizontal: 50),
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
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    final success = await editreview.reviewdelete(
                      reviewid: reviewcontro.riviewlist[index].id.toString(),
                    );

                    if (success) {
                      reviewcontro.riviewlist.removeAt(index);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    width: getProportionateScreenWidth(140),
                    decoration: BoxDecoration(
                      color: Appcolors.appPriSecColor.appPrimblue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: editreview.isdelete.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: commonLoadingWhite(),
                            )
                          : label(
                              languageController.textTranslate("Delete"),
                              fontSize: 14,
                              textColor: Appcolors.white,
                              fontWeight: FontWeight.w400,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmReview(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            alignment: Alignment.bottomCenter,
            insetPadding: EdgeInsets.only(),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Appcolors.appBgColor.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: StatefulBuilder(
              builder: (context, kk) {
                return SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: getProportionateScreenHeight(380),
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: themeContro.isLightMode.value
                                    ? Appcolors.white
                                    : Appcolors.darkGray,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sizeBoxHeight(30),
                                  label(
                                    languageController.textTranslate(
                                      'Feel Free to share your review and ratings',
                                    ),
                                    maxLines: 2,
                                    fontSize: 14,
                                    textColor: themeContro.isLightMode.value
                                        ? Appcolors.black
                                        : Appcolors.white,
                                    fontWeight: FontWeight.w500,
                                  ).paddingSymmetric(horizontal: 25),
                                  sizeBoxHeight(12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RatingBar.builder(
                                        initialRating: editreview
                                            .rateValue
                                            .value, // Start with 3 stars selected
                                        minRating:
                                            1, // The minimum rating the user can give is 1 star
                                        direction: Axis
                                            .horizontal, // Stars are laid out horizontally
                                        allowHalfRating:
                                            false, // Full stars only, no half-star ratings
                                        unratedColor: Colors
                                            .grey
                                            .shade400, // Color for unselected stars
                                        itemCount:
                                            5, // Total number of stars is 5
                                        itemSize: 25,
                                        itemPadding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ), // Space between stars
                                        itemBuilder: (context, _) =>
                                            Image.asset(
                                              AppAsstes.star,
                                              color: Appcolors
                                                  .appExtraColor
                                                  .yellowColor,
                                            ),
                                        onRatingUpdate: (rating) {
                                          editreview.rateValue.value =
                                              rating; // Update the rating value

                                          (
                                            'Select Review :- ${editreview.rateValue.value.toString().replaceAll(".0", "")}',
                                          );
                                        },
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 25),
                                  sizeBoxHeight(22),
                                  TextFormField(
                                    cursorColor: themeContro.isLightMode.value
                                        ? Appcolors.black
                                        : Appcolors.white,
                                    autofocus: false,
                                    controller: editreview.msgController,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    readOnly: false,
                                    keyboardType: TextInputType.text,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 20,
                                          ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: BorderSide(
                                          color: Appcolors
                                              .appPriSecColor
                                              .appPrimblue,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: BorderSide(
                                          color: Appcolors.grey,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: BorderSide(
                                          color: Appcolors.grey,
                                        ),
                                      ),
                                      hintText: languageController
                                          .textTranslate(
                                            "Write Your Review....",
                                          ),
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        color: Appcolors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: BorderSide(
                                          color: Appcolors.grey,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: BorderSide(
                                          color: Appcolors.grey,
                                        ),
                                      ),
                                      errorStyle: TextStyle(
                                        color:
                                            Appcolors.appTextColor.textRedColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ).paddingSymmetric(horizontal: 25),
                                  sizeBoxHeight(20),
                                  Obx(() {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            height:
                                                getProportionateScreenHeight(
                                                  50,
                                                ),
                                            width: getProportionateScreenWidth(
                                              140,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                    themeContro
                                                        .isLightMode
                                                        .value
                                                    ? Appcolors
                                                          .appPriSecColor
                                                          .appPrimblue
                                                    : Appcolors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: label(
                                                languageController
                                                    .textTranslate('Cancel'),
                                                fontSize: 14,
                                                textColor:
                                                    themeContro
                                                        .isLightMode
                                                        .value
                                                    ? Appcolors.black
                                                    : Appcolors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        sizeBoxWidth(10),
                                        GestureDetector(
                                          onTap: () async {
                                            editreview.reviewEditApi(
                                              isupdate: false,
                                              review_messsage:
                                                  editreview.msgController.text,
                                              serviceId: reviewcontro
                                                  .riviewlist[index]
                                                  .serviceId
                                                  .toString(),
                                              reviewid: reviewcontro
                                                  .riviewlist[index]
                                                  .id
                                                  .toString(),
                                              reviewstar: editreview.rateValue
                                                  .toString(),
                                            );
                                            reviewcontro
                                                    .riviewlist[index]
                                                    .reviewMessage =
                                                editreview.msgController.text;
                                            reviewcontro
                                                .riviewlist[index]
                                                .reviewStar = editreview
                                                .rateValue
                                                .toString();
                                            reviewcontro.riviewlist.refresh();
                                            reviewcontro.riviewmodel.refresh();

                                            setState(() {});

                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height:
                                                getProportionateScreenHeight(
                                                  50,
                                                ),
                                            width: getProportionateScreenWidth(
                                              140,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Appcolors
                                                  .appPriSecColor
                                                  .appPrimblue,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: label(
                                                languageController
                                                    .textTranslate('Save'),
                                                fontSize: 14,
                                                textColor: Appcolors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -40,
                              child: Container(
                                height: 58,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: themeContro.isLightMode.value
                                      ? Appcolors.white
                                      : Appcolors.darkgray1,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Appcolors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(
                                        0.0,
                                        2.0,
                                      ), // shadow direction: bottom right
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(22),
                                    topLeft: Radius.circular(22),
                                    bottomRight: Radius.circular(22),
                                    topRight: Radius.circular(22),
                                  ),
                                ),
                                child: Center(
                                  child: label(
                                    languageController.textTranslate(
                                      'Review & Rating',
                                    ),
                                    fontSize: 18,
                                    textAlign: TextAlign.center,
                                    textColor: themeContro.isLightMode.value
                                        ? Appcolors.black
                                        : Appcolors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
