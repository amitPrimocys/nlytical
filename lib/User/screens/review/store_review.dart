// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/service_contro.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class StoreReview extends StatefulWidget {
  const StoreReview({super.key});

  @override
  State<StoreReview> createState() => _StoreReviewState();
}

class _StoreReviewState extends State<StoreReview> {
  ServiceContro servicecontro = Get.find();
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
            languageController.textTranslate("Reviews"),
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
            sizeBoxHeight(20),
            avrageReviewWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    sizeBoxHeight(30),
                    servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .reviews!
                            .isNotEmpty
                        ? ListView.builder(
                            itemCount: servicecontro
                                .servicemodel
                                .value!
                                .serviceDetail!
                                .reviews!
                                .length,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return review(
                                context,
                                time: servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .reviews![index]
                                    .createdAt
                                    .toString(),
                                fname:
                                    '${servicecontro.servicemodel.value!.serviceDetail!.reviews![index].firstName.toString() + " " + servicecontro.servicemodel.value!.serviceDetail!.reviews![index].lastName.toString()}',
                                descname: servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .reviews![index]
                                    .reviewMessage
                                    .toString(),
                                // content: 'super',
                                imagepath: servicecontro
                                    .servicemodel
                                    .value!
                                    .serviceDetail!
                                    .reviews![index]
                                    .image
                                    .toString(),
                                ratingCount:
                                    servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .reviews![index]
                                            .reviewStar
                                            .toString() !=
                                        ''
                                    ? double.parse(
                                        servicecontro
                                            .servicemodel
                                            .value!
                                            .serviceDetail!
                                            .reviews![index]
                                            .reviewStar
                                            .toString(),
                                      )
                                    : 0.0,
                              ).paddingSymmetric(horizontal: 15, vertical: 15);
                            },
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: SizedBox(
                                height: 250,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    sizeBoxHeight(Get.height * 0.2),
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
                              ),
                            ),
                          ),
                  ],
                ).paddingSymmetric(horizontal: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget avrageReviewWidget() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border(
          bottom: BorderSide(
            color: Appcolors.appExtraColor.yellowColor.withValues(alpha: 0.08),
          ),
        ),
        color: Appcolors.appExtraColor.yellowColor.withValues(alpha: 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageController.textTranslate("Average review received"),
            style: AppTypography.text12Medium(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          sizeBoxHeight(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: servicecontro
                              .servicemodel
                              .value!
                              .serviceDetail!
                              .totalAvgReview!,
                          style: AppTypography.text16Semi(
                            context,
                          ).copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: "/5",
                          style: AppTypography.text16Semi(
                            context,
                          ).copyWith(fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    languageController.textTranslate(
                      "Based on ${servicecontro.servicemodel.value!.serviceDetail!.reviews!.length} reviews",
                    ),
                    style: AppTypography.text12Medium(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  sizeBoxHeight(10),
                  RatingBar.builder(
                    itemPadding: const EdgeInsets.only(left: 1.5),
                    initialRating: double.parse(
                      servicecontro
                          .servicemodel
                          .value!
                          .serviceDetail!
                          .totalAvgReview!,
                    ),
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 14.5,
                    ignoreGestures: true,
                    unratedColor: Appcolors.appExtraColor.yellowColor
                        .withValues(alpha: 0.23),
                    itemBuilder: (context, _) =>
                        Image.asset('assets/images/Star.png', height: 16),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: RatingBreakdown(
                  allRatings:
                      servicecontro
                                  .servicemodel
                                  .value
                                  ?.serviceDetail
                                  ?.reviews !=
                              null &&
                          servicecontro
                              .servicemodel
                              .value!
                              .serviceDetail!
                              .reviews!
                              .isNotEmpty
                      ? servicecontro
                            .servicemodel
                            .value!
                            .serviceDetail!
                            .reviews!
                            .map((e) => e.reviewStar)
                            .toList()
                      : [],
                ),
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 15, vertical: 15),
    ).paddingSymmetric(horizontal: 20);
  }
}

class RatingBreakdown extends StatelessWidget {
  final List<String?> allRatings; // e.g., ['5', '4.5', '3', '5', '2', '4', ...]

  const RatingBreakdown({super.key, required this.allRatings});

  @override
  Widget build(BuildContext context) {
    // Count exact stars only (round to int)
    Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var rating in allRatings) {
      int star = double.parse(rating!).round().clamp(1, 5);
      ratingCounts[star] = ratingCounts[star]! + 1;
    }

    // Get total reviews
    int total = allRatings.length;

    return Column(
      children: List.generate(5, (index) {
        int star = 5 - index;
        int count = ratingCounts[star]!;
        double percentage = total > 0 ? count / total : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            children: [
              Text(
                "$star star",
                style: AppTypography.text10Medium(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Appcolors.appExtraColor.yellowColor.withValues(
                          alpha: 0.23,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Appcolors.appExtraColor.yellowColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
