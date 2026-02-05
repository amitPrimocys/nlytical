import 'package:flutter/material.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/review_contro.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/shimmer_custom/shimmer.dart';

double? h, w;

ReviewContro reviewcontro = Get.find();

Widget reviewlistLoader(BuildContext context) {
  h = MediaQuery.sizeOf(context).height;
  w = MediaQuery.sizeOf(context).width;
  return SingleChildScrollView(
    child: Column(
      children: [
        ListView.builder(
          itemCount: reviewcontro.riviewlist.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Shimmer.fromColors(
                baseColor: themeContro.isLightMode.value
                    ? Appcolors.grey300
                    : Appcolors.white12,
                highlightColor: themeContro.isLightMode.value
                    ? Appcolors.grey100
                    : Appcolors.white24,
                child: Container(
                  height: Get.height * 0.19,
                  width: Get.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Appcolors.grey200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: getProportionateScreenHeight(60),
                              width: getProportionateScreenWidth(60),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Appcolors.grey,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    sizeBoxWidth(15),
                                    Container(
                                      height: 13,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: Appcolors.grey400,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                            color: Appcolors.white,
                                            fontSize: 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    sizeBoxWidth(Get.width * 0.42),
                                    Container(
                                      height: 13,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: Appcolors.grey400,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                            color: Appcolors.white,
                                            fontSize: 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                sizeBoxHeight(8),
                                label(
                                  '',
                                  fontSize: 11,
                                  textColor: Appcolors.brown,
                                  fontWeight: FontWeight.w600,
                                ).paddingSymmetric(horizontal: 15),
                              ],
                            ),
                          ],
                        ),
                        sizeBoxHeight(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                              itemPadding: const EdgeInsets.only(left: 1.5),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 14.5,
                              ignoreGestures: true,
                              unratedColor: Appcolors.grey400,
                              itemBuilder: (context, _) => Image.asset(
                                'assets/images/Star.png',
                                height: 16,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                        sizeBoxHeight(10),
                        label(
                          '',
                          fontSize: 9,
                          maxLines: 3,
                          textColor: Appcolors.brown,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
              ),
            );
          },
        ),
      ],
    ),
  );
}
