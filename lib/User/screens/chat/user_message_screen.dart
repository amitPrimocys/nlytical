import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/User/screens/homeScreen/chat_screen2.dart';
import 'package:nlytical/Vendor/screens/add_store.dart';
import 'package:nlytical/Vendor/screens/auth/subcription.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/chat_contro.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/models/user_models/chat_list_model.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class UserMessageScreen extends StatefulWidget {
  const UserMessageScreen({super.key});

  @override
  State<UserMessageScreen> createState() => _UserMessageScreenState();
}

class _UserMessageScreenState extends State<UserMessageScreen> {
  final ChatController messageController = Get.find();
  TextEditingController searchcontroller = TextEditingController();

  final searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  String userid = '';
  String vendorid = '';

  @override
  void initState() {
    messageController.chatApi(issearch: false, userid: userID);
    searchcontroller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  GetprofileContro getprofilecontro = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      body: SizedBox(
        height: Get.height,
        child: Stack(
          clipBehavior: Clip.antiAlias,
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
              left: 10,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      languageController.textTranslate("Message"),
                      style: AppTypography.h1(
                        context,
                      ).copyWith(color: Appcolors.appTextColor.textWhite),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    AppAsstes.search,
                    color: Colors.transparent,
                    height: 22,
                  ),
                ],
              ).paddingSymmetric(horizontal: 30),
            ),
            Positioned(
              top: 100,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: Get.width,
                    height: getProportionateScreenHeight(800),
                    decoration: BoxDecoration(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appBgColor.white
                          : Appcolors.darkMainBlack,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(children: [sizeBoxHeight(27), chatWidget()]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatWidget() {
    return Expanded(
      child: StreamBuilder(
        stream: messageController.streamController1.stream,
        builder: (BuildContext context, AsyncSnapshot<ChatListModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Appcolors.appPriSecColor.appPrimblue,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          }
          if (snapshot.hasData) {
            final chatList = snapshot.data!.chatList ?? [];

            final filteredList = searchcontroller.text.isEmpty
                ? chatList
                : chatList.where((chat) {
                    final fullName =
                        "${chat.firstName ?? ''} ${chat.lastName ?? ''}"
                            .toLowerCase();
                    final searchText = searchcontroller.text.toLowerCase();
                    return fullName.contains(searchText);
                  }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Platform.isIOS ? sizeBoxHeight(15) : sizeBoxHeight(5),
                searchBar(),
                sizeBoxHeight(5),
                filteredList.isEmpty
                    ? searchempty()
                    : ListView.separated(
                        itemCount: filteredList.length,
                        shrinkWrap: true,
                        clipBehavior: Clip.antiAlias,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: themeContro.isLightMode.value
                                ? Appcolors.appStrokColor.cF0F0F0
                                : Appcolors.darkGray,
                            height: 1,
                          );
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              messageController.chatlistIndex.value = index;
                              FocusScope.of(context).unfocus();
                              Get.to(
                                ChatScreen2(
                                  isLead: "0",
                                  toUserID: filteredList[index].secondId
                                      .toString(),
                                  fname: filteredList[index].firstName
                                      .toString(),
                                  lname: filteredList[index].lastName
                                      .toString(),
                                  lastSeen: filteredList[index].lastSeen
                                      .toString(),
                                  profile: filteredList[index].profilePic
                                      .toString(),
                                  block: filteredList[index].isBlock!,
                                  isRought: false,
                                ),
                              )!.then((_) {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  if (userRole == "user") {
                                    messageController.chatApi(
                                      issearch: false,
                                      userid: userID,
                                    );
                                  } else {
                                    messageController.chatApi(
                                      issearch: false,
                                      userid: userID,
                                    );
                                  }
                                });
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Appcolors.appStrokColor.cF0F0F0,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            filteredList[index].profilePic!,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) {
                                          return containerCapiltal(
                                            height:
                                                getProportionateScreenHeight(
                                                  50,
                                                ),
                                            width: getProportionateScreenWidth(
                                              50,
                                            ),
                                            fontSize: 20,
                                            text:
                                                filteredList[index].firstName!,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                sizeBoxWidth(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${filteredList[index].firstName!} ${filteredList[index].lastName!}",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.text14Medium(
                                          context,
                                        ),
                                      ),
                                      filteredList[index].type == "doc"
                                          ? rowMsgType(
                                              img: AppAsstes.file,
                                              title: "Document",
                                            )
                                          : filteredList[index].type == "image"
                                          ? rowMsgType(
                                              img: AppAsstes.gallery,
                                              title: "Photo",
                                            )
                                          : Text(
                                              filteredList[index].lastMessage!,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  AppTypography.text12Ragular(
                                                    context,
                                                  ).copyWith(
                                                    color: Appcolors
                                                        .appTextColor
                                                        .textLighGray,
                                                  ),
                                            ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      userID ==
                                              snapshot
                                                  .data!
                                                  .chatList![index]
                                                  .myId
                                                  .toString()
                                          ? SizedBox.shrink()
                                          : snapshot
                                                    .data!
                                                    .chatList![index]
                                                    .isLead ==
                                                "1"
                                          ? Text(
                                              "Lead",
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  AppTypography.text8Medium(
                                                    context,
                                                  ).copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Appcolors
                                                        .appExtraColor
                                                        .greenColor,
                                                  ),
                                            )
                                          : SizedBox.shrink(),
                                      Text(
                                        snapshot.data!.chatList![index].time!,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            AppTypography.text8Medium(
                                              context,
                                            ).copyWith(
                                              color: Appcolors
                                                  .appTextColor
                                                  .textLighGray,
                                            ),
                                      ),
                                      filteredList[index].unreadMessage == "0"
                                          ? const SizedBox.shrink()
                                          : Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Appcolors
                                                    .appPriSecColor
                                                    .appPrimblue,
                                              ),
                                              child: label(
                                                filteredList[index]
                                                    .unreadMessage!,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    AppTypography.text8Medium(
                                                      context,
                                                    ).copyWith(
                                                      color: Appcolors
                                                          .appTextColor
                                                          .textWhite,
                                                    ),
                                              ).paddingAll(6),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 20, vertical: 12),
                          );
                        },
                      ),
                sizeBoxHeight(20),
              ],
            );
          } else {
            return Column(
              children: [
                sizeBoxHeight(300),
                Text(languageController.textTranslate("No Messages to show")),
              ],
            );
          }
        },
      ),
    );
  }

  Widget searchempty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.28),
          SizedBox(
            height: 100,
            child: Image.asset(AppAsstes.emptyImage, width: 200, height: 180),
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

  Widget rowMsgType({required String img, required String title}) {
    return Row(
      children: [
        Image.asset(
          img,
          height: 15,
          color: Appcolors.appTextColor.textLighGray,
        ),
        Text(
          " $title",
          style: AppTypography.text8Medium(
            context,
          ).copyWith(color: Appcolors.appTextColor.textLighGray),
        ),
      ],
    );
  }

  Widget searchBar() {
    return SizedBox(
      width: Get.width,
      height: 42,
      child: TextField(
        focusNode: searchFocusNode,
        controller: searchcontroller,
        onChanged: (value) {
          setState(() {});
        },
        style: AppTypography.text10Medium(context),
        cursorColor: themeContro.isLightMode.value
            ? Appcolors.grey300
            : Appcolors.white,
        readOnly: false,
        decoration: InputDecoration(
          fillColor: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
          hintText: languageController.textTranslate("User Search"),
          hintStyle: AppTypography.text10Medium(
            context,
          ).copyWith(color: Appcolors.appTextColor.textLighGray),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 11, top: 11),
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

  Widget userVendorTab() {
    return Obx(() {
      return InkWell(
        onTap: () {
          roleController.isUser.value = !roleController.isUser.value;
          if (kDebugMode) {
            (roleController.isUser.value);
          }
          messageController.chatApi(issearch: false, userid: userID);
        },
        child: Container(
          height: getProportionateScreenHeight(45),
          width: Get.width * 0.90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Appcolors.white,
          ),
          child: Container(
            width: Get.width * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Appcolors.cD9D9D9,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                roleController.isUser.value
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.white,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Appcolors.appPriSecColor.appPrimblue,
                          ),
                        ).paddingOnly(right: 3),
                      ).paddingOnly(right: 140)
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.white,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Appcolors.appPriSecColor.appPrimblue,
                          ),
                        ).paddingOnly(left: 3),
                      ).paddingOnly(left: 140),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Text(
                        "Users",
                        style: AppTypography.text10Medium(context).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: roleController.isUser.value
                              ? Appcolors.appTextColor.textWhite
                              : Appcolors.appPriSecColor.appPrimblue,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Vendor",
                        style: AppTypography.text10Medium(context).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: !roleController.isUser.value
                              ? Appcolors.appTextColor.textWhite
                              : Appcolors.appPriSecColor.appPrimblue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).paddingAll(2),
        ),
      );
    });
  }

  Widget subscribedUserAlertWidget() {
    return Column(
      children: [
        sizeBoxHeight(150),
        Image.asset(
          "assets/images/subAlert.png",
          height: getProportionateScreenHeight(98),
        ),
        sizeBoxHeight(30),
        Text(
          languageController.textTranslate("Subscribe to Become Vendor"),
          style: AppTypography.text12Medium(
            context,
          ).copyWith(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        sizeBoxHeight(10),
        Text(
          languageController.textTranslate(
            "Subscribe the plan to become vendor so you can add the store details",
          ),
          textAlign: TextAlign.center,
          style: AppTypography.text12Medium(
            context,
          ).copyWith(fontWeight: FontWeight.w600, fontSize: 10),
        ).paddingSymmetric(horizontal: 30),
        sizeBoxHeight(30),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 136, height: 30),
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => SubscriptionSceen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.appPriSecColor.appPrimblue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              languageController.textTranslate("Subscribe"),
              style: AppTypography.text10Medium(
                context,
              ).copyWith(color: Appcolors.appTextColor.textWhite),
            ),
          ),
        ),
      ],
    );
  }

  Widget addingStore() {
    return Column(
      children: [
        sizeBoxHeight(150),
        Image.asset(
          "assets/images/subAlert.png",
          height: getProportionateScreenHeight(78),
        ),
        sizeBoxHeight(30),
        Text(
          languageController.textTranslate("Start Adding Store"),
          style: AppTypography.text12Medium(
            context,
          ).copyWith(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        sizeBoxHeight(10),
        Text(
          languageController.textTranslate(
            "As you have subscribed, you can proceed to start adding the store",
          ),
          textAlign: TextAlign.center,
          style: AppTypography.text12Medium(
            context,
          ).copyWith(fontWeight: FontWeight.w600, fontSize: 10),
        ).paddingSymmetric(horizontal: 60),
        sizeBoxHeight(30),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 136, height: 30),
          child: ElevatedButton(
            onPressed: () {
              // if (isDemo == "false") {
              //   Get.to(() => AddStore());
              // } else {
              //   snackBar("This is for demo, We can not allow to add");
              // }
              Get.to(() => AddStore());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.appPriSecColor.appPrimblue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              languageController.textTranslate("Add Store"),
              style: AppTypography.text10Medium(
                context,
              ).copyWith(color: Appcolors.appTextColor.textWhite),
            ),
          ),
        ),
      ],
    );
  }
}
