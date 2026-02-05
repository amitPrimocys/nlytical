// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';

class BusinessVideo extends StatefulWidget {
  const BusinessVideo({super.key});

  @override
  State<BusinessVideo> createState() => _BusinessVideoState();
}

class _BusinessVideoState extends State<BusinessVideo> {
  StoreController storeController = Get.find();

  //========== multiple video select ============================
  FilePickerResult? pickedFileVideo;
  String? thumbnailPath = '';
  String compressedVideoPath = '';

  double fileSizeInMB = 0.0;
  bool isThumbnail = false;

  Future<void> openVideoPicker() async {
    try {
      setState(() {
        isThumbnail = true;
      });
      pickedFileVideo = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mkv', 'MKV', 'avi'],
        allowCompression: true,
        allowMultiple: false,
      );
      File file = File(pickedFileVideo!.files.first.path!);
      int fileSizeInBytes = file.lengthSync();
      fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB <= 30) {
        try {
          thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: pickedFileVideo!.files.first.path!,
            imageFormat: ImageFormat.WEBP,
            quality: 50,
          );
          setState(() {
            isThumbnail = false;
          });
        } catch (e) {
          pickedFileVideo = null;
        }
      } else {
        snackBar("max video size is 30MB");
      }
      setState(() {
        isThumbnail = false;
      });
    } catch (e) {
      setState(() {
        isThumbnail = false;
      });
    }
  }

  @override
  void initState() {
    if (storeController.storeList[0].businessDetails!.video != "") {
      thumbnailPath =
          storeController.storeList[0].businessDetails!.videoThumbnail!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      body: SizedBox(
        height: Get.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: Get.width,
              height: getProportionateScreenHeight(150),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAsstes.line_design),
                ),
                color: Appcolors.appPriSecColor.appPrimblue,
              ),
            ),
            Positioned(
              top: getProportionateScreenHeight(50),
              child: Row(
                children: [
                  sizeBoxWidth(20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/arrow-left1.png',
                      color: Appcolors.white,
                      height: 24,
                    ),
                  ),
                  sizeBoxWidth(10),
                  Text(
                    "Business Videos",
                    style: poppinsFont(20, Appcolors.white, FontWeight.w500),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 100,
              child: Container(
                width: Get.width,
                height: getProportionateScreenHeight(800),
                decoration: BoxDecoration(
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.darkMainBlack,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      sizeBoxHeight(30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: themeContro.isLightMode.value
                                ? Appcolors.appPriSecColor.appPrimblue
                                : Appcolors.white,
                            size: 15,
                          ),
                          Flexible(
                            child: Text(
                              " Make your business look more trustworthy by uploding videos of your business premises",
                              style: poppinsFont(
                                10,
                                themeContro.isLightMode.value
                                    ? Appcolors.appPriSecColor.appPrimblue
                                    : Appcolors.white,
                                FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      sizeBoxHeight(20),
                      twoText(
                        fontWeight: FontWeight.w600,
                        text1: "Add Business Video",
                        text2: "",
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      sizeBoxHeight(6),
                      GestureDetector(
                        onTap: () {
                          openVideoPicker();
                        },
                        child: Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Appcolors.appStrokColor.cF0F0F0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                AppAsstes.videoStore,
                                height: getProportionateScreenHeight(27),
                                width: getProportionateScreenWidth(27),
                              ),
                              sizeBoxHeight(4),
                              label(
                                "Service Video",
                                style: poppinsFont(
                                  8,
                                  Appcolors.colorB0B0B0,
                                  FontWeight.w400,
                                ),
                              ),
                            ],
                          ).paddingSymmetric(vertical: 25),
                        ),
                      ),
                      sizeBoxHeight(10),
                      label(
                        "Note: You can upload only one video",
                        maxLines: 2,
                        style: poppinsFont(
                          9,
                          Appcolors.appTextColor.textLighGray,
                          FontWeight.w400,
                        ),
                      ),
                      thumbnailPath!.isEmpty
                          ? const SizedBox.shrink()
                          : sizeBoxHeight(12),
                      thumbnailPath!.isEmpty
                          ? isThumbnail == true
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: commonLoading(),
                                  ).paddingOnly(top: 5)
                                : const SizedBox()
                          : Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Appcolors.appStrokColor.cF0F0F0,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.antiAlias,
                                      children: [
                                        storeController
                                                    .storeList[0]
                                                    .businessDetails!
                                                    .video ==
                                                ""
                                            ? Image.file(
                                                File(thumbnailPath!),
                                                fit: BoxFit.cover,
                                                height:
                                                    getProportionateScreenHeight(
                                                      53,
                                                    ),
                                                width:
                                                    getProportionateScreenWidth(
                                                      68,
                                                    ),
                                              )
                                            : Image.network(
                                                thumbnailPath!,
                                                fit: BoxFit.cover,
                                                height:
                                                    getProportionateScreenHeight(
                                                      53,
                                                    ),
                                                width:
                                                    getProportionateScreenWidth(
                                                      68,
                                                    ),
                                              ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Appcolors.white.withValues(
                                              alpha: 0.06,
                                            ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Appcolors.colorB0B0B0
                                                  .withValues(alpha: 0.12),
                                              width: 0.33,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 4.9,
                                                sigmaY: 4.9,
                                              ),
                                              child: Image.asset(
                                                AppAsstes.play2,
                                                height:
                                                    getProportionateScreenHeight(
                                                      7,
                                                    ),
                                                width:
                                                    getProportionateScreenWidth(
                                                      7,
                                                    ),
                                              ).paddingAll(3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -5,
                                  top: -5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        thumbnailPath = '';
                                        pickedFileVideo = null;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Appcolors.colorBABABA,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 8,
                                        color: Appcolors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ).paddingSymmetric(horizontal: 20),
                ),
              ),
            ),
            Positioned(
              bottom: keyboardHeight > 0
                  ? keyboardHeight +
                        -280 // Place above the keyboard
                  : 30, // Default position
              left: (Get.width - getProportionateScreenWidth(260)) / 2,
              child: Obx(() {
                return storeController.isUpdate.value
                    ? Center(child: commonLoading()).paddingSymmetric(
                        horizontal: getProportionateScreenWidth(100),
                      )
                    : customBtn(
                        onTap: () {
                          if (isDemo == "false") {
                            if (thumbnailPath!.isEmpty) {
                              snackBar("Please add business video");
                            } else {
                              storeController.storeVideoUpdateApi(
                                storeVideoThumbnail: thumbnailPath!.isEmpty
                                    ? ""
                                    : thumbnailPath!,
                                storeVideo: pickedFileVideo == null
                                    ? ""
                                    : pickedFileVideo!.files.first.path!,
                              );
                            }
                          } else {
                            snackBar(
                              "This is for demo, We can not allow to edit or update",
                            );
                          }
                        },
                        title: "Save",
                        fontSize: 15,
                        weight: FontWeight.w400,
                        radius: BorderRadius.circular(10),
                        width: getProportionateScreenWidth(260),
                        height: getProportionateScreenHeight(55),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
