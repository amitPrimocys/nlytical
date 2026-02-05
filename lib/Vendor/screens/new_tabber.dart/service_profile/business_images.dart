// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class BusinessImages extends StatefulWidget {
  const BusinessImages({super.key});

  @override
  State<BusinessImages> createState() => _BusinessImagesState();
}

class _BusinessImagesState extends State<BusinessImages> {
  StoreController storeController = Get.find();

  Future<void> pickImages() async {
    setState(() {
      FocusScope.of(context).unfocus();
    });
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        requestType: RequestType.image,
        maxAssets: 10,
      ),
    );

    if (result != null) {
      List<File> files = [];

      for (final asset in result) {
        final file = await asset.file;
        if (file != null) files.add(file);
      }

      setState(() {
        selectedAssets = result;
        selectedImageFiles = files;
      });
    }
  }

  //####################################################################################
  List<AssetEntity> allAssets = [];
  List<AssetEntity> selectedAssets = [];
  List<File> selectedImageFiles = [];
  Map<AssetEntity, Uint8List> thumbnailCache = {};
  Future<void> _loadAssets() async {
    final permission = await PhotoManager.requestPermissionExtend();

    if (!permission.isAuth) {
      await PhotoManager.openSetting();
      return;
    }

    List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (paths.isNotEmpty) {
      List<AssetEntity> assets = await paths[0].getAssetListPaged(
        page: 0,
        size: 100,
      );

      Map<AssetEntity, Uint8List> thumbMap = {};
      for (AssetEntity asset in assets) {
        final thumb = await asset.thumbnailDataWithSize(
          const ThumbnailSize(200, 200),
        );
        if (thumb != null) {
          thumbMap[asset] = thumb;
        }
      }

      setState(() {
        allAssets = assets;
        thumbnailCache = thumbMap;
      });
    }
  }

  Future<void> _confirmSelection() async {
    List<File> files = [];

    for (final asset in selectedAssets) {
      final file = await asset.file;
      if (file != null) files.add(file);
    }

    setState(() {
      selectedImageFiles = files;
    });

    Navigator.pop(context, selectedImageFiles);
  }
  //####################################################################################

  List<dynamic> combinedImages = [];

  @override
  Widget build(BuildContext context) {
    if (storeController.storeList.isNotEmpty &&
        storeController.storeList[0].businessDetails?.serviceImages != null) {
      combinedImages = [
        ...storeController.storeList[0].businessDetails!.serviceImages!,
        ...selectedImageFiles,
      ];
    } else {
      combinedImages = [...selectedImageFiles];
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Business Images"),
            style: poppinsFont(20, Appcolors.white, FontWeight.w500),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: innerContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      " ${languageController.textTranslate("Make your business look more trustworthy by uploding images of your business premises")}",
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
                text1: languageController.textTranslate("Add Business Images"),
                text2: " *",
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              sizeBoxHeight(6),
              GestureDetector(
                onTap: () {
                  if (isDemo == "false") {
                    bottomSheetGobal2(
                      context,
                      bottomsheetHeight: Get.height * 0.90,
                      title: "Gallery Images",
                      trailingBuilder: (setState) => selectedAssets.isEmpty
                          ? GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(
                                Icons.close,
                                size: 22,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                await _confirmSelection();
                              },
                              child: Icon(
                                Icons.check,
                                size: 22,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                              ),
                            ),
                      childBuilder: (setState) {
                        if (thumbnailCache.isEmpty && allAssets.isNotEmpty) {
                          for (final asset in allAssets) {
                            asset
                                .thumbnailDataWithSize(
                                  const ThumbnailSize(200, 200),
                                )
                                .then((thumb) {
                                  if (thumb != null) {
                                    thumbnailCache[asset] = thumb;
                                    setState(
                                      () {},
                                    ); // Rebuild when each image is ready
                                  }
                                });
                          }
                        }
                        if (allAssets.isEmpty) {
                          _loadAssets().then((_) => setState(() {}));
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return GridView.builder(
                            padding: const EdgeInsets.all(4),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                ),
                            itemCount: allAssets.length,
                            itemBuilder: (context, index) {
                              final asset = allAssets[index];
                              final thumb = thumbnailCache[asset];
                              final isSelected = selectedAssets.contains(asset);

                              return GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    selectedAssets.remove(asset);
                                  } else if (selectedAssets.length < 10) {
                                    selectedAssets.add(asset);
                                  }
                                  setState(() {}); // Rebuild selection state
                                },
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: thumb != null
                                          ? Image.memory(
                                              thumb,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(color: Colors.grey[300]),
                                    ),
                                    if (isSelected)
                                      const Positioned(
                                        right: 4,
                                        top: 4,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 24,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  } else {
                    snackBar("This is for demo, We can not allow to add");
                  }
                },
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appBgColor.transparent
                        : Appcolors.darkGray,
                    border: Border.all(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appStrokColor.cF0F0F0
                          : Appcolors.grey1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        AppAsstes.add_business1,
                        height: getProportionateScreenHeight(27),
                        width: getProportionateScreenWidth(27),
                      ),
                      sizeBoxHeight(4),
                      label(
                        languageController.textTranslate("Service Image"),
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
              sizeBoxHeight(5),
              Text(
                languageController.textTranslate(
                  "Note: You can upload images with ‘jpg’, ‘png’, ‘jpeg’ extensions & you can select multiple images",
                ),
                style: poppinsFont(
                  9,
                  Appcolors.appTextColor.textLighGray,
                  FontWeight.w500,
                ),
              ),
              combinedImages.isEmpty
                  ? const SizedBox.shrink()
                  : sizeBoxHeight(12),
              combinedImages.isEmpty
                  ? (storeController.storeList.isEmpty
                        ? const Center(child: Text('No images available'))
                        : const SizedBox.shrink())
                  : SizedBox(
                      height: getProportionateScreenHeight(58),
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: combinedImages.length,
                        separatorBuilder: (context, index) {
                          return sizeBoxWidth(15);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          bool isEventImage = storeController.storeList.isEmpty
                              ? false
                              : index <
                                    storeController
                                        .storeList[0]
                                        .businessDetails!
                                        .serviceImages!
                                        .length;
                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Appcolors.colorB0B0B0,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: isEventImage
                                      ? Image.network(
                                          combinedImages[index].url.toString(),
                                          height: getProportionateScreenHeight(
                                            52,
                                          ),
                                          width: getProportionateScreenWidth(
                                            52,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(combinedImages[index]!.path),
                                          fit: BoxFit.cover,
                                          height: getProportionateScreenHeight(
                                            52,
                                          ),
                                          width: getProportionateScreenWidth(
                                            52,
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                right: -5,
                                top: -5,
                                child: InkWell(
                                  onTap: () {
                                    if (isDemo == "false") {
                                      if (isEventImage) {
                                        storeController.removeServiceImgApi(
                                          serviceIMGID: storeController
                                              .storeList[0]
                                              .businessDetails!
                                              .serviceImages![index]
                                              .id
                                              .toString(),
                                        );
                                        setState(() {
                                          storeController
                                              .storeList[0]
                                              .businessDetails!
                                              .serviceImages!
                                              .removeAt(index);
                                        });
                                      } else {
                                        setState(() {
                                          selectedAssets.removeAt(
                                            index -
                                                storeController
                                                    .storeList[0]
                                                    .businessDetails!
                                                    .serviceImages!
                                                    .length,
                                          );
                                          selectedImageFiles.removeAt(
                                            index -
                                                storeController
                                                    .storeList[0]
                                                    .businessDetails!
                                                    .serviceImages!
                                                    .length,
                                          );
                                          (selectedImageFiles);
                                        });
                                      }
                                    } else {
                                      snackBar(
                                        "This is for demo, We can not allow to delete",
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
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
                          );
                        },
                      ),
                    ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return storeController.isUpdate.value
            ? SizedBox(
                height: 50,
                width: 50,
                child: Center(child: commonLoading()),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 20,
                right: 20,
              )
            : customBtn(
                onTap: () {
                  if (isDemo == "false") {
                    if (selectedImageFiles.isEmpty && combinedImages.isEmpty) {
                      snackBar("Please add you store images");
                    } else {
                      storeController.storeIMAGEUpdateApi(
                        storeImages: selectedImageFiles
                            .map((file) => file.path)
                            .toList(),
                      );
                    }
                  } else {
                    snackBar("This is for demo, We can not allow to update");
                  }
                },
                title: languageController.textTranslate("Save"),
                fontSize: 15,
                weight: FontWeight.w400,
                radius: BorderRadius.circular(10),
                width: getProportionateScreenWidth(260),
                height: getProportionateScreenHeight(55),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 60,
                right: 60,
              );
      }),
    );
  }

  //####################################################################################
  Future<dynamic> bottomSheetGobal2(
    BuildContext context, {
    required double bottomsheetHeight,
    required String title,
    required Widget Function(StateSetter) childBuilder,
    required Widget Function(StateSetter) trailingBuilder,
  }) {
    final ap = Get.bottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.57),
      elevation: 0,
      backgroundColor: Appcolors.appBgColor.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.8, sigmaY: 3.8),
        child: Container(
          decoration: BoxDecoration(
            color: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkMainBlack,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: getProportionateScreenHeight(
            bottomsheetHeight - MediaQuery.of(context).padding.bottom,
          ),
          width: Get.width,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Container(
                    height: getProportionateScreenHeight(70),
                    width: Get.width,
                    decoration: BoxDecoration(
                      // color: Appcolors.white,
                      borderRadius: BorderRadius.circular(20),
                      color: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      boxShadow: [
                        BoxShadow(
                          color: Appcolors.black.withValues(alpha: 0.12),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          offset: const Offset(
                            0.0,
                            2.0,
                          ), // shadow direction: bottom right
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.close,
                          size: 22,
                          color: Appcolors.appBgColor.transparent,
                        ),
                        Text(
                          title,
                          style: AppTypography.text16Semi(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: themeContro.isLightMode.value
                                ? Appcolors.appTextColor.textBlack
                                : Appcolors.appTextColor.textWhite,
                          ),
                        ),
                        // sizeBoxWidth(145),
                        trailingBuilder(setState),
                      ],
                    ).paddingSymmetric(horizontal: 15),
                  ),
                  Expanded(child: childBuilder(setState)),
                ],
              );
            },
          ),
        ),
      ),
    );

    return ap;
  }
}
