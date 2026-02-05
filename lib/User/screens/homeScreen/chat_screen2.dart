// ignore_for_file: must_be_immutable, unused_local_variable, avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/block_contro.dart';
import 'package:nlytical/controllers/user_controllers/chat_contro.dart';
import 'package:nlytical/controllers/user_controllers/report_contro.dart';
import 'package:nlytical/models/user_models/chat_get_model.dart';
import 'package:nlytical/User/screens/homeScreen/vendor_info.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/pdf.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ChatScreen2 extends StatefulWidget {
  final String toUserID;
  final bool isRought;
  String? fname;
  String? lname;
  String? profile;
  String? lastSeen;
  int? block;
  String isLead;
  ChatScreen2({
    super.key,
    required this.toUserID,
    required this.isRought,
    this.fname,
    this.lname,
    this.profile,
    this.lastSeen,
    this.block,
    required this.isLead,
  });

  @override
  State<ChatScreen2> createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  final ChatController messageController = Get.find();
  BlockContro blockcontro = Get.find();
  ReportContro reportcontro = Get.find();

  final sendMessageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();

  Timer? timer;
  bool onTapbutton = false;

  void _scrollToLastMessage() {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  @override
  void initState() {
    reportcontro.reportgetApi();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      messageController.chatgetApi(toUSerID: widget.toUserID, fromUser: userID);
    });
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    messageController.getMessageModel = GetMessageModel().obs;
    isSendLoader = false;
    super.dispose();
  }

  void _scrollListener() {}

  bool isSendLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: GestureDetector(
            onTap: () {
              setState(() {
                isSendLoader = false;
              });
              Get.back();
            },
            child: Image.asset(
              userTextDirection == "ltr"
                  ? 'assets/images/arrow-left1.png'
                  : "assets/images/arrow-left (1).png",
              color: Appcolors.white,
              height: 24,
            ),
          ).paddingAll(15),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: GestureDetector(
            onTap: () {
              if (messageController.userROLE.value == 'vendor') {
                Get.to(VendorInfo(oppositeid: widget.toUserID));
              }
            },
            child: Row(
              children: [
                widget.isRought == true
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(47),
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(47),
                          child: commonImage(
                            image: widget.profile!,
                            height: getProportionateScreenHeight(47),
                            width: getProportionateScreenWidth(47),
                            radius: 47,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(47),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(47),
                          child: commonImage(
                            image: widget.profile!,
                            height: getProportionateScreenHeight(47),
                            width: getProportionateScreenWidth(47),
                            radius: 47,
                          ),
                        ),
                      ),
                SizedBox(width: 15),
                widget.isRought == true
                    ? SizedBox(
                        width: getProportionateScreenWidth(200),
                        child: label(
                          "${widget.fname!.capitalizeFirst} ${widget.lname!}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTypography.text16(
                            context,
                          ).copyWith(color: Appcolors.appTextColor.textWhite),
                        ),
                      )
                    : SizedBox(
                        width: getProportionateScreenWidth(200),
                        child: label(
                          "${widget.fname!.capitalizeFirst} ${widget.lname!}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTypography.text16(
                            context,
                          ).copyWith(color: Appcolors.appTextColor.textWhite),
                        ),
                      ),
              ],
            ),
          ),
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  color: Appcolors.white,
                  shadowColor: themeContro.isLightMode.value
                      ? Appcolors.grey.withValues(alpha: 0.5)
                      : Appcolors.darkShadowColor,
                  elevation: 12,
                ),
              ),
              child: PopupMenuButton<String>(
                onOpened: () {
                  FocusScope.of(context).unfocus();
                },
                color: themeContro.isLightMode.value
                    ? Appcolors.white
                    : Appcolors.darkGray,
                icon: Icon(Icons.more_vert, color: Appcolors.white, size: 30),
                onSelected: (value) {
                  if (value == 'Report') {
                    reportcontro.reportgetApi();
                    bottomSheetGobal(
                      context,
                      bottomsheetHeight: 392,
                      title: languageController.textTranslate("Report"),
                      child: report(),
                    );
                  } else if (value == 'Block') {
                    bottomSheetGobal(
                      context,
                      bottomsheetHeight: 250,
                      title: widget.block == 0
                          ? languageController.textTranslate("Block Account")
                          : languageController.textTranslate("Unblock Account"),
                      child: selectblock(),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'Report',
                    child: Text(
                      languageController.textTranslate('Report'),
                      style: AppTypography.text14Medium(context),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Block',
                    child: widget.block == 0
                        ? Text(
                            languageController.textTranslate('Block'),
                            style: AppTypography.text14Medium(context),
                          )
                        : Text(
                            languageController.textTranslate('UnBlock'),
                            style: AppTypography.text14Medium(context),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: innerContainer(
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              sizeBoxHeight(27),
              Expanded(
                child: StreamBuilder(
                  stream: messageController.streamController.stream,
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<GetMessageModel> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Appcolors.appPriSecColor.appPrimblue,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error.toString()}"),
                          );
                        }
                        if (snapshot.hasData) {
                          return snapshot.data!.chatMessages!.isEmpty
                              ? Column(
                                  children: [
                                    sizeBoxHeight(270),
                                    Text(
                                      languageController.textTranslate(
                                        "Start your conversation",
                                      ),
                                      style: AppTypography.text14Medium(context)
                                          .copyWith(
                                            color: Appcolors
                                                .appTextColor
                                                .textLighGray,
                                          ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemCount:
                                      snapshot.data!.chatMessages!.length,
                                  itemBuilder: (context, index1) {
                                    return StickyHeader(
                                      header: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 15,
                                        ),
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Appcolors
                                                  .appPriSecColor
                                                  .appPrimblue
                                                  .withValues(alpha: 0.06),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                            ),
                                            child: Text(
                                              formatDate1(
                                                snapshot
                                                    .data!
                                                    .chatMessages![index1]
                                                    .date!,
                                              ),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Appcolors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      content: ListView.builder(
                                        itemCount: snapshot
                                            .data!
                                            .chatMessages![index1]
                                            .messages!
                                            .length,
                                        shrinkWrap: true,
                                        reverse: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return _buildType(
                                            index,
                                            snapshot
                                                .data!
                                                .chatMessages![index1]
                                                .messages![index],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                        } else {
                          return Column(
                            children: [
                              sizeBoxHeight(350),
                              label(
                                languageController.textTranslate(
                                  "No Messages to show",
                                ),
                              ),
                            ],
                          );
                        }
                      },
                ),
              ),
              isSendLoader
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: commonLoading(),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Align(
                alignment: Alignment.bottomCenter,
                child: widget.block == 0
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: globalTextField(
                              controller: sendMessageController,
                              onEditingComplete: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(signUpPasswordFocusNode);
                              },
                              isEmail: false,
                              isNumber: false,
                              focusNode: signUpEmailIDFocusNode,
                              hintText: languageController.textTranslate(
                                'Type Message',
                              ),
                              context: context,
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      signUpEmailIDFocusNode.unfocus();
                                      signUpPasswordFocusNode.unfocus();
                                      chatimageselect();
                                    },
                                    child: Image.asset(
                                      AppAsstes.pin,
                                      scale: 3.5,
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.grey1,
                                    ),
                                  ),
                                  sizeBoxWidth(5),
                                  GestureDetector(
                                    onTap: () {
                                      signUpEmailIDFocusNode.unfocus();
                                      signUpPasswordFocusNode.unfocus();
                                      openImagePickerCAMERA();
                                    },
                                    child: Image.asset(
                                      AppAsstes.camerachat,
                                      scale: 3.5,
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.black
                                          : Appcolors.grey1,
                                    ),
                                  ),
                                ],
                              ).paddingOnly(right: 13, left: 13),
                            ),
                          ),
                          sizeBoxWidth(13),
                          InkWell(
                            onTap: () {
                              if (sendMessageController.text.isEmpty ||
                                  sendMessageController.text.trim().isEmpty) {
                                snackBar(
                                  languageController.textTranslate(
                                    "Please type message",
                                  ),
                                );
                              } else {
                                addChatAPI();
                              }

                              sendMessageController.clear();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Appcolors.appPriSecColor.appPrimblue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                AppAsstes.share,
                                height: getProportionateScreenHeight(28),
                                width: getProportionateScreenWidth(24),
                              ).paddingSymmetric(horizontal: 13, vertical: 11),
                            ).paddingOnly(top: 13),
                          ),
                        ],
                      ).paddingOnly(left: 14, right: 14, bottom: 15)
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            color: Appcolors.appPriSecColor.appPrimblue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languageController.textTranslate(
                                "This user is currently blocked and unavailable.",
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Appcolors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ).paddingOnly(bottom: 15),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildType(int index, Messages data) {
    switch (data.type) {
      case "text":
        return getTextMessageType(index, data);
      case "image":
        return getIMAGEMessageType(index, data);
      case "doc":
        return getDOCMessageType(index, data);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget getTextMessageType(int index, Messages data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: data.message!));
          snackBar("Message copied");
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: data.fromUser.toString() != userID ? 12 : 12,
                right: 12,
                top: 0,
                bottom: 0,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: (data.fromUser.toString() != userID
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Column(
                      crossAxisAlignment: data.fromUser.toString() != userID
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: data.fromUser.toString() != userID
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      )
                                    : const BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                gradient: data.fromUser.toString() != userID
                                    ? Appcolors
                                          .appGradientColor
                                          .chatOppositeColor
                                    : Appcolors.appGradientColor.chatMyColor,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                data.message!,
                                style: AppTypography.text12Medium(context)
                                    .copyWith(
                                      color: data.fromUser.toString() != userID
                                          ? Appcolors.appTextColor.textBlack
                                          : Appcolors.appTextColor.textWhite,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: SizedBox(
                            child: Text(
                              convertUTCTimeTo12HourFormat(data.chatTime!),
                              style: AppTypography.text10Medium(context)
                                  .copyWith(
                                    color: Appcolors.appTextColor.textLighGray,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getIMAGEMessageType(int index, Messages data) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
          padding: EdgeInsets.only(
            left: data.fromUser.toString() != userID ? 12 : 12,
            right: 12,
            top: 0,
            bottom: 0,
          ),
          child: Column(
            children: [
              Align(
                alignment: (data.fromUser.toString() != userID
                    ? Alignment.topLeft
                    : Alignment.topRight),
                child: Column(
                  crossAxisAlignment: data.fromUser.toString() != userID
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: data.fromUser.toString() != userID
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )
                                : const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                            gradient: data.fromUser.toString() != userID
                                ? Appcolors.appGradientColor.chatOppositeColor
                                : Appcolors.appGradientColor.chatMyColor,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Appcolors.black.withValues(
                                  alpha: 0.5,
                                ),
                                builder: (BuildContext context) {
                                  return BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5.0,
                                      sigmaY: 5.0,
                                    ),
                                    child: AlertDialog(
                                      backgroundColor:
                                          Appcolors.appBgColor.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      content: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: InteractiveViewer(
                                          child: Image.network(
                                            data.url!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight:
                                      data.fromUser.toString() != userID
                                      ? Radius.circular(10)
                                      : Radius.circular(0),
                                  bottomLeft: data.fromUser.toString() != userID
                                      ? Radius.circular(0)
                                      : Radius.circular(10),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight:
                                      data.fromUser.toString() != userID
                                      ? Radius.circular(10)
                                      : Radius.circular(0),
                                  bottomLeft: data.fromUser.toString() != userID
                                      ? Radius.circular(0)
                                      : Radius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: data.url!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return const CupertinoActivityIndicator();
                                  },
                                  errorWidget: (context, url, error) {
                                    return Icon(
                                      Icons.error,
                                      size: 20,
                                      color:
                                          Appcolors.appTextColor.textRedColor,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        data.fromUser.toString() != userID
                            ? Positioned(
                                bottom: 5,
                                left: 5,
                                child: Text(
                                  convertUTCTimeTo12HourFormat(data.chatTime!),
                                  style: AppTypography.text10Medium(context)
                                      .copyWith(
                                        color:
                                            Appcolors.appTextColor.textLighGray,
                                      ),
                                ),
                              )
                            : Positioned(
                                bottom: 5,
                                right: 5,
                                child: Text(
                                  convertUTCTimeTo12HourFormat(data.chatTime!),
                                  style: AppTypography.text10Medium(context)
                                      .copyWith(
                                        color: Appcolors.appTextColor.textWhite
                                            .withValues(alpha: 0.78),
                                      ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDOCMessageType(int index, Messages data) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
          padding: EdgeInsets.only(
            left: data.fromUser.toString() != userID ? 12 : 12,
            right: 12,
            top: 0,
            bottom: 0,
          ),
          child: Column(
            children: [
              Align(
                alignment: (data.fromUser.toString() != userID
                    ? Alignment.topLeft
                    : Alignment.topRight),
                child: Column(
                  crossAxisAlignment: data.fromUser.toString() != userID
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: data.fromUser.toString() != userID
                                  ? Radius.circular(10)
                                  : Radius.circular(0),
                              bottomLeft: data.fromUser.toString() != userID
                                  ? Radius.circular(0)
                                  : Radius.circular(10),
                            ),
                            gradient: data.fromUser.toString() != userID
                                ? Appcolors.appGradientColor.chatOppositeColor
                                : Appcolors.appGradientColor.chatMyColor,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => PDFViewerScreen(data.url!));
                            },
                            child: Container(
                              width: 300,
                              height: 76,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight:
                                      data.fromUser.toString() != userID
                                      ? Radius.circular(10)
                                      : Radius.circular(0),
                                  bottomLeft: data.fromUser.toString() != userID
                                      ? Radius.circular(0)
                                      : Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: Appcolors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/pdf2.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            getShortFileName(
                                              data.url!,
                                            ).toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  data.fromUser.toString() !=
                                                      userID
                                                  ? Appcolors.black
                                                  : Appcolors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 10),
                                  ),
                                  sizeBoxHeight(1),
                                  Align(
                                    alignment:
                                        data.fromUser.toString() != userID
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Text(
                                      convertUTCTimeTo12HourFormat(
                                        data.chatTime!,
                                      ),
                                      style: AppTypography.text10Medium(context)
                                          .copyWith(
                                            color: Appcolors
                                                .appTextColor
                                                .textWhite
                                                .withValues(alpha: 0.78),
                                          ),
                                    ),
                                  ).paddingSymmetric(horizontal: 5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  String extractFilename(String url) {
    // Extract the filename from the URL
    return url.split('/').last;
  }

  String getShortFileName(String url, {int maxBaseLength = 15}) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last;

    // Split into name and extension
    int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1) return fileName; // No extension found

    String baseName = fileName.substring(0, dotIndex);
    String extension = fileName.substring(dotIndex);

    // If base name is longer than max, shorten it
    if (baseName.length > maxBaseLength) {
      baseName = baseName.substring(0, maxBaseLength);
    }

    return '$baseName$extension';
  }

  final _picker = ImagePicker();
  String imagePath = "";
  Future<void> openImagePickerCAMERA() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;

        String fileName = imagePath.split('/').last;

        messageController.addChatText(
          isLead: widget.isLead,
          imagePath, // Pass the image here
          toUSerID: widget.toUserID,
          message: sendMessageController.text.isEmpty
              ? ""
              : sendMessageController.text.trim(),
          type: "image", // Or another type based on your API requirement
        );
      });
    }
  }

  Future<void> pickAndSendImage() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["png", "jpg", "jpeg", "webp"],
      allowCompression: true,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      String filePath = pickedFile.files.single.path!;
      String fileName = filePath.split('/').last;

      setState(() async {
        setState(() {
          isSendLoader = true;
        });
        final success = await messageController.addChatText(
          isLead: widget.isLead,
          filePath, // Image file path
          toUSerID: widget.toUserID,
          message: sendMessageController.text.isEmpty
              ? ""
              : sendMessageController.text.trim(),
          type: "image", // File type as image
        );
        if (success) {
          setState(() {
            isSendLoader = false;
          });
        } else {
          setState(() {
            isSendLoader = false;
          });
        }
      });
    }
  }

  Future<void> pickAndSendDocument() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        "pdf",
        "doc",
        "docx",
        "xls",
        "xlsx",
        "ppt",
        "pptx",
        "txt",
        "rtf",
        "odt",
        "csv",
      ],
      allowCompression: true,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      String filePath = pickedFile.files.single.path!;
      String fileName = filePath.split('/').last;

      setState(() async {
        isSendLoader = true;
        final success = await messageController.addChatText(
          isLead: widget.isLead,
          filePath,
          toUSerID: widget.toUserID,
          message: sendMessageController.text.isEmpty
              ? ""
              : sendMessageController.text.trim(),
          type: "doc",
        );
        if (success) {
          isSendLoader = false;
        } else {
          isSendLoader = false;
        }
      });
    }
  }

  Future<void> addChatAPI() async {
    final success = await messageController.addChatText(
      isLead: widget.isLead,
      null, // If there's no image, pass `null`
      toUSerID: widget.toUserID,
      message: sendMessageController.text.isEmpty
          ? ""
          : sendMessageController.text.trim(),
      type: "message", // Ensure the type is correct for a text message
    );

    if (success) {
      messageController.chatApi(issearch: false, userid: userID);
      sendMessageController.clear();
      _scrollToLastMessage();
      sendMessageController.text = '';
    }
  }

  Future<void> chatimageselect() async {
    signUpEmailIDFocusNode.unfocus();
    signUpPasswordFocusNode.unfocus();
    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Appcolors.appBgColor.transparent,
      builder: (BuildContext context) {
        double bottomInset = MediaQuery.of(context).viewInsets.bottom;
        double dialogBottomPadding = bottomInset == 0 ? 65 : bottomInset + 20;
        return AlertDialog(
          alignment: Alignment.bottomCenter,
          insetPadding: EdgeInsets.only(
            bottom: dialogBottomPadding,
            left: 10,
            right: 10,
          ),
          contentPadding: EdgeInsets.zero,
          backgroundColor: Appcolors.appBgColor.transparent,
          content: StatefulBuilder(
            builder: (context, kk) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickAndSendImage();
                        Get.back();
                      },
                      child: Container(
                        height: 70,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Appcolors.appPriSecColor.appPrimblue
                              .withValues(alpha: 0.10),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Appcolors.appPriSecColor.appPrimblue,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/gallery.png',
                                    ),
                                  ),
                                ),
                                sizeBoxHeight(5),
                                label(
                                  languageController.textTranslate('Gallery'),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  textColor: Appcolors.brown,
                                ),
                              ],
                            ),
                            sizeBoxWidth(20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    pickAndSendDocument();
                                    Get.back();
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Appcolors.appPriSecColor.appPrimblue,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/document.png',
                                      ),
                                    ),
                                  ),
                                ),
                                sizeBoxHeight(5),
                                label(
                                  languageController.textTranslate('Document'),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  textColor: Appcolors.brown,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) {
        Future.delayed(Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(signUpEmailIDFocusNode);
          FocusScope.of(context).requestFocus(signUpPasswordFocusNode);
        });
      }
    });
    if (mounted) {
      Future.delayed(Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(signUpEmailIDFocusNode);
        FocusScope.of(context).requestFocus(signUpPasswordFocusNode);
      });
    }
  }

  Column selectblock() {
    return Column(
      children: [
        sizeBoxHeight(20),
        Center(
          child: Text(
            widget.block == 0
                ? languageController.textTranslate(
                    "Are you sure you want to \nBlock Account?",
                  )
                : languageController.textTranslate(
                    "Are you sure you want to \nUnblock Account?",
                  ),
            textAlign: TextAlign.center,
            style: poppinsFont(16, Appcolors.greyColor, FontWeight.w500),
          ),
        ),
        sizeBoxHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: getProportionateScreenWidth(150),
                decoration: BoxDecoration(
                  color: themeContro.isLightMode.value
                      ? Appcolors.white
                      : Appcolors.appBgColor.transparent,
                  border: Border.all(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appPriSecColor.appPrimblue
                        : Appcolors.grey1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: label(
                    languageController.textTranslate('Cancel'),
                    fontSize: 14,
                    textColor: themeContro.isLightMode.value
                        ? Appcolors.black
                        : Appcolors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            sizeBoxWidth(30),
            widget.block == 0
                ? GestureDetector(
                    onTap: () {
                      blockcontro.blockApi(oppsiteId: widget.toUserID);
                      setState(() {
                        widget.block = 1;
                      });
                      Get.back();
                    },
                    child: Container(
                      height: getProportionateScreenHeight(50),
                      width: getProportionateScreenWidth(150),
                      decoration: BoxDecoration(
                        color: Appcolors.appPriSecColor.appPrimblue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: label(
                          widget.block == 0
                              ? languageController.textTranslate('Block')
                              : languageController.textTranslate("Unblock"),
                          fontSize: 14,
                          textColor: Appcolors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      blockcontro.unBlockApi(oppsiteId: widget.toUserID);
                      setState(() {
                        widget.block = 0;
                      });
                      Get.back();
                    },
                    child: Container(
                      height: getProportionateScreenHeight(50),
                      width: getProportionateScreenWidth(150),
                      decoration: BoxDecoration(
                        color: Appcolors.appPriSecColor.appPrimblue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: label(
                          languageController.textTranslate('UnBlock'),
                          fontSize: 14,
                          textColor: Appcolors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  report() {
    return Obx(() {
      return reportcontro.isreport.value
          ? Center(
              child: CircularProgressIndicator(
                color: themeContro.isLightMode.value
                    ? Appcolors.appBgColor.transparent
                    : Appcolors.appPriSecColor.appPrimblue,
              ),
            )
          : Column(
              children: [
                sizeBoxHeight(20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    languageController.textTranslate(
                      "why are you reporting this Post?",
                    ),
                    textAlign: TextAlign.center,
                    style: poppinsFont(
                      12,
                      themeContro.isLightMode.value
                          ? Appcolors.greyColor
                          : Appcolors.white,
                      FontWeight.w600,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(10),
                reportcontro.reportlist.isNotEmpty
                    ? ListView.separated(
                        itemCount: reportcontro.reportlist.length,
                        shrinkWrap: true,
                        clipBehavior: Clip.antiAlias,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textLighGray
                                : Colors.grey.shade900,
                            height: 1,
                          );
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              reportcontro.reportUserApi(
                                reportoppsiteId: widget.toUserID,
                                reportText: reportcontro.reportlist[index].text
                                    .toString(),
                              );
                              Get.back();
                            },
                            child:
                                label(
                                      reportcontro.reportlist[index].text
                                          .toString(),
                                      fontSize: 12,
                                      textColor: themeContro.isLightMode.value
                                          ? const Color.fromRGBO(58, 58, 58, 1)
                                          : Appcolors.grey1,
                                      fontWeight: FontWeight.w600,
                                    )
                                    .paddingSymmetric(vertical: 10)
                                    .paddingSymmetric(horizontal: 20),
                          );
                        },
                      )
                    : const Text('Report List Empty'),
              ],
            );
    });
  }
}
