// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';

class FloatingScreen1 extends StatelessWidget {
  String sname;
  double ratingCount;
  String avrageReview;
  int isLike;
  Function() onTaplike;
  Function() storeOnTap;
  FloatingScreen1({
    super.key,
    required this.sname,
    required this.ratingCount,
    required this.avrageReview,
    required this.isLike,
    required this.onTaplike,
    required this.storeOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.appBgColor.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
        ).copyWith(top: 20, bottom: 3),
        child: GestureDetector(
          onTap: onTaplike,
          child: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Appcolors.white,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: isLike == 0
                    ? Image.asset(AppAsstes.heart) // Unlike
                    : Image.asset(AppAsstes.fill_heart),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        color: Appcolors.white,
        notchMargin: 0,
        clipBehavior: Clip.none,
        elevation: 0,
        height: 60,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(20),
            ),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(120),
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: label(
                sname,
                maxLines: 1,
                fontSize: 11,
                textColor: Appcolors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                RatingBar.builder(
                  itemPadding: const EdgeInsets.only(left: 1.5),
                  initialRating: ratingCount,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 10.5,
                  ignoreGestures: true,
                  unratedColor: Appcolors.grey400,
                  itemBuilder: (context, _) =>
                      Image.asset('assets/images/Star.png', height: 6),
                  onRatingUpdate: (rating) {},
                ),
                const SizedBox(width: 5),
                label(
                  '($avrageReview Review)',
                  fontSize: 8,
                  textColor: Appcolors.black,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 5),
      ),
    );
  }
}
