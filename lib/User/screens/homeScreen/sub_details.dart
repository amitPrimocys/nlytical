// ignore_for_file: must_be_immutable, avoid_print, deprecated_member_use, empty_catches

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:nlytical/User/screens/homeScreen/chat_screen2.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/utils/html_text_convert.dart';
import 'package:nlytical/utils/rating_bar/src/rating_bar.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/service_contro.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/pdf.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class SubDetails extends StatefulWidget {
  int? index;
  SubDetails({super.key, this.index});

  @override
  State<SubDetails> createState() => _SubDetailsState();
}

class _SubDetailsState extends State<SubDetails> {
  ServiceContro servicecontro = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            servicecontro.servicemodel.value!.stores![widget.index!].storeName
                .toString(),
            style: poppinsFont(20, Appcolors.white, FontWeight.w500),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      bottomNavigationBar: Obx(() {
        return servicecontro.isservice.value
            ? SizedBox.shrink()
            : servicecontro.servicemodel.value!.vendor.toString() == userID
            ? SizedBox.shrink()
            : Container(
                decoration: BoxDecoration(
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.darkMainBlack,

                  // Background color of bottom navigation bar
                  boxShadow: !themeContro.isLightMode.value
                      ? [
                          BoxShadow(
                            color: Appcolors.black,
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(5, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Appcolors.black.withValues(alpha: 0.11),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                ),
                child: BottomAppBar(
                  height: 70,
                  color: Appcolors.appBgColor.white,
                  child: bottam(),
                ),
              );
      }),
      body: innerContainer(
        child: Column(
          children: [
            sizeBoxHeight(10),
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    sizeBoxHeight(15),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: Get.height * 0.28,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: themeContro.isLightMode.value
                                ? Appcolors.white
                                : Appcolors.darkGray,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 0,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.grey300
                                    : Appcolors.darkShadowColor,
                                offset: const Offset(0.0, 3.0),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(
                                servicecontro
                                    .servicemodel
                                    .value!
                                    .stores![widget.index!]
                                    .storeImages![0]
                                    .toString(),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 70,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.white
                                  : Appcolors.darkGray,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 240,
                                    child: label(
                                      servicecontro
                                          .servicemodel
                                          .value!
                                          .serviceDetail!
                                          .serviceName!
                                          .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      textColor: themeContro.isLightMode.value
                                          ? Appcolors.brown
                                          : Appcolors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            servicecontro
                                                    .servicemodel
                                                    .value!
                                                    .serviceDetail!
                                                    .totalAvgReview!
                                                    .toString() !=
                                                ''
                                            ? double.parse(
                                                servicecontro
                                                    .servicemodel
                                                    .value!
                                                    .serviceDetail!
                                                    .totalAvgReview!
                                                    .toString(),
                                              )
                                            : 0.0,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 12.5,
                                        ignoreGestures: true,
                                        unratedColor: Appcolors.grey400,
                                        itemBuilder: (context, _) =>
                                            Image.asset(
                                              'assets/images/Star.png',
                                              height: 16,
                                            ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const SizedBox(width: 5),
                                      label(
                                        '(${servicecontro.servicemodel.value!.serviceDetail!.totalReviewCount!.toString()} Review)',
                                        fontSize: 10,
                                        textColor: themeContro.isLightMode.value
                                            ? Appcolors.black
                                            : Appcolors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ).paddingOnly(right: 14),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 14,
                          child: Container(
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(3),
                                bottomRight: Radius.circular(3),
                              ),
                              color: Appcolors.appPriSecColor.appPrimblue,
                            ),
                            child: Center(
                              child: label(
                                servicecontro
                                    .servicemodel
                                    .value!
                                    .stores![widget.index!]
                                    .category
                                    .toString(),
                                fontSize: 8,
                                textColor: Appcolors.white,
                                fontWeight: FontWeight.w600,
                              ).paddingSymmetric(horizontal: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    sizeBoxHeight(15),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Appcolors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HtmlReadMoreView(
                              htmlData: cleanHtmlText(
                                servicecontro
                                    .servicemodel
                                    .value!
                                    .stores![widget.index!]
                                    .storeDescription
                                    .toString(),
                              ),
                              trimLines: 3,
                              textColor: themeContro.isLightMode.value
                                  ? Appcolors.appTextColor.textBlack
                                  : Appcolors.appTextColor.textWhite,
                            ),
                          ],
                        ),
                      ),
                    ),
                    sizeBoxHeight(15),
                    Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Appcolors.black12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          label(
                            'Price',
                            fontSize: 12,
                            textColor: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          label(
                            servicecontro
                                .servicemodel
                                .value!
                                .stores![widget.index!]
                                .price
                                .toString(),
                            fontSize: 12,
                            textColor: Appcolors.appPriSecColor.appPrimblue,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                    ),
                    sizeBoxHeight(15),
                    Container(
                      height: Get.height * 0.2,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Appcolors.black12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          label(
                            'Attachment',
                            fontSize: 12,
                            textColor: themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 50,
                            child:
                                servicecontro
                                    .servicemodel
                                    .value!
                                    .stores![widget.index!]
                                    .storeAttachments!
                                    .isNotEmpty
                                ? ListView.builder(
                                    itemCount: servicecontro
                                        .servicemodel
                                        .value!
                                        .stores![widget.index!]
                                        .storeAttachments!
                                        .length, // Replace with the actual number of attachments
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      String attachmentUrl = servicecontro
                                          .servicemodel
                                          .value!
                                          .stores![widget.index!]
                                          .storeAttachments![index];

                                      bool isImage =
                                          attachmentUrl.endsWith('.jpg') ||
                                          attachmentUrl.endsWith('.jpeg') ||
                                          attachmentUrl.endsWith('.png');

                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (isImage) {
                                                showDialog(
                                                  context: context,
                                                  barrierColor: Appcolors.black
                                                      .withOpacity(0.5),
                                                  builder: (BuildContext context) {
                                                    return BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                        sigmaX: 5.0,
                                                        sigmaY: 5.0,
                                                      ),
                                                      child: AlertDialog(
                                                        backgroundColor:
                                                            Appcolors
                                                                .appBgColor
                                                                .transparent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        insetPadding:
                                                            EdgeInsets.zero,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                          child: posterDialog2(
                                                            context,
                                                            attachmentUrl,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                Get.to(
                                                  () => PDFViewerScreen(
                                                    attachmentUrl,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: isImage
                                                  ? Image.network(
                                                      servicecontro
                                                          .servicemodel
                                                          .value!
                                                          .stores![widget
                                                              .index!]
                                                          .storeAttachments![0],
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.fill,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Icon(
                                                              Icons.error,
                                                              color:
                                                                  themeContro
                                                                      .isLightMode
                                                                      .value
                                                                  ? Appcolors
                                                                        .black
                                                                  : Appcolors
                                                                        .white,
                                                            );
                                                          },
                                                    )
                                                  : Image.asset(
                                                      'assets/images/pdf.png',
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : Center(
                                    child: label(
                                      'No attachments available',
                                      fontSize: 12,
                                      textColor: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.appTextColor.textLighGray,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                    ),
                    Platform.isIOS ? sizeBoxHeight(150) : sizeBoxHeight(100),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottam() {
    return Row(
      children: [
        Expanded(
          child: btnCallChatWhp(
            onTap: () async {
              if (userID.isEmpty) {
                snackBar("Login must need for see mobile number");
              } else {
                String phoneNum = Uri.encodeComponent(
                  servicecontro.servicemodel.value!.serviceDetail!.servicePhone!
                      .toString(),
                );
                Uri tel = Uri.parse("tel:$phoneNum");
                if (await launchUrl(tel)) {
                  //phone dail app is opened
                } else {
                  //phone dail app is not opened
                  snackBar('Phone dail not opened');
                }
              }
            },
            title: languageController.textTranslate("Call"),
            img: 'assets/images/call.png',
            isValue:
                servicecontro
                    .servicemodel
                    .value!
                    .serviceDetail!
                    .servicePhone!
                    .isNotEmpty
                ? true
                : false,
          ),
        ),
        sizeBoxWidth(10),
        Expanded(
          child: btnCallChatWhp(
            onTap: () {
              if (userID.isEmpty) {
                snackBar("Login must need for chat with vendor");
              } else {
                Get.to(
                  ChatScreen2(
                    isLead: "1",
                    toUserID: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .id
                        .toString(),
                    isRought: true,
                    fname: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .firstName,
                    lname: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .lastName,
                    profile:
                        servicecontro.servicemodel.value!.vendorDetails!.image,
                    lastSeen: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .lastSeen,
                    block: servicecontro
                        .servicemodel
                        .value!
                        .vendorDetails!
                        .isBlock,
                  ),
                  transition: Transition.rightToLeft,
                );
              }
            },
            title: languageController.textTranslate('Chat'),
            img: 'assets/images/message-2.png',
            isValue: true,
          ),
        ),
        sizeBoxWidth(10),
        Expanded(
          child: btnCallChatWhp(
            onTap: () async {
              if (userID.isEmpty) {
                snackBar("Login must need for see what's app number");
              } else {
                // whatsapp();
                _launchWhatsapp(
                  servicecontro.servicemodel.value!.serviceDetail!.whatsappLink,
                );
              }
            },
            title: languageController.textTranslate('Whatsapp'),
            img: 'assets/images/whatsapp.png',
            isValue:
                servicecontro
                    .servicemodel
                    .value!
                    .serviceDetail!
                    .whatsappLink!
                    .isNotEmpty
                ? true
                : false,
          ),
        ),
      ],
    );
  }

  Future<void> _launchWhatsapp(url) async {
    url = url;
    //"https://wa.me/?text=Hey buddy, try this super cool new app!";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> whatsapp() async {
    var contact = servicecontro.servicemodel.value!.serviceDetail!.servicePhone!
        .toString();

    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }

  Widget btnCallChatWhp({
    required Function() onTap,
    required String title,
    required String img,
    required bool isValue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isValue
                ? Appcolors.appPriSecColor.appPrimblue
                : Appcolors.appTextColor.textLighGray,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              img,
              height: 12,
              color: title == 'Whatsapp'
                  ? null
                  : isValue
                  ? Appcolors.appPriSecColor.appPrimblue
                  : Appcolors.appTextColor.textLighGray,
            ),
            sizeBoxWidth(5),
            Text(
              title,
              style: AppTypography.text10Regular(context).copyWith(
                color: isValue
                    ? Appcolors.appPriSecColor.appPrimblue
                    : Appcolors.appTextColor.textLighGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget posterDialog2(BuildContext context, String imgUrl) {
  return FutureBuilder<Size>(
    future: _getImageSize(imgUrl),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(
            color: Appcolors.appPriSecColor.appPrimblue,
          ),
        );
      }

      final imageSize = snapshot.data!;
      final isPortrait = imageSize.height > imageSize.width;

      double dialogWidth = isPortrait ? Get.width * 0.65 : Get.width * 0.90;
      double dialogHeight = isPortrait ? Get.height * 0.65 : Get.height * 0.5;

      return SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            imgUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.error,
                  color: Appcolors.appTextColor.textRedColor,
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

Future<Size> _getImageSize(String imageUrl) async {
  final Completer<Size> completer = Completer();
  final Image image = Image.network(imageUrl);
  image.image
      .resolve(const ImageConfiguration())
      .addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          final myImage = info.image;
          completer.complete(
            Size(myImage.width.toDouble(), myImage.height.toDouble()),
          );
        }),
      );
  return completer.future;
}
