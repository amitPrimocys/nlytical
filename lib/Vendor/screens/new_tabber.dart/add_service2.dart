// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:nlytical/utils/custome_gallery.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/service_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddSrvice2 extends StatefulWidget {
  final bool isvalue;
  const AddSrvice2({super.key, required this.isvalue});

  @override
  State<AddSrvice2> createState() => _AddSrvice2State();
}

class _AddSrvice2State extends State<AddSrvice2> {
  Future<void> requestStoragePermission() async {
    final status = await Permission.photos.request(); // iOS
    final storageStatus = await Permission.storage.request(); // Android
  }

  ServiceController serviceController = Get.find();
  final serviceNameController = TextEditingController();
  final serviceDescController = TextEditingController();
  final servicePriceController = TextEditingController();
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

  final nameFocus = FocusNode();
  final nameFocus1 = FocusNode();
  final descFocus = FocusNode();
  final descFocus1 = FocusNode();
  final prieFocus = FocusNode();
  final priceFocus1 = FocusNode();

  @override
  void initState() {
    requestStoragePermission();
    _loadAssets();
    if (serviceController.serviceIndex.value != -1) {
      serviceNameController.text = serviceController
          .serviceList[serviceController.serviceIndex.value]
          .storeName
          .toString();
      serviceDescController.text = serviceController
          .serviceList[serviceController.serviceIndex.value]
          .storeDescription
          .toString();
      servicePriceController.text = serviceController
          .serviceList[serviceController.serviceIndex.value]
          .price
          .toString();
    }

    super.initState();
  }

  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();

  /////////////////////////////////////////////////////////////////////////////////
  Future<void> pickImages() async {
    setState(() {
      nameFocus.unfocus();
      nameFocus1.unfocus();
      descFocus.unfocus();
      descFocus1.unfocus();
      prieFocus.unfocus();
      priceFocus1.unfocus();
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

  void openGalleryPicker(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomGalleryPicker()),
    );
  }

  /////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom + 100;
    // service image
    List<dynamic> combinedImages = serviceController.serviceIndex.value == -1
        ? [...selectedImageFiles]
        : [
            if (serviceController
                    .serviceList[serviceController.serviceIndex.value]
                    .storeImages !=
                null)
              ...serviceController
                  .serviceList[serviceController.serviceIndex.value]
                  .storeImages!,
            ...selectedImageFiles,
          ];

    // service attachment
    List<dynamic> combinedAttchment = serviceController.serviceIndex.value == -1
        ? [...selectedFile]
        : [
            if (serviceController
                    .serviceList[serviceController.serviceIndex.value]
                    .storeAttachments !=
                null)
              ...serviceController
                  .serviceList[serviceController.serviceIndex.value]
                  .storeAttachments!,
            ...selectedFile,
          ];

    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            widget.isvalue
                ? languageController.textTranslate("Update Service")
                : languageController.textTranslate("Add Service"),
            style: poppinsFont(20, Appcolors.white, FontWeight.w500),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        color: Appcolors.appBgColor.transparent,
        elevation: 0,
        height: 80,
        child: button(),
      ),
      body: InkWell(
        onTap: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: innerContainer(
          child: SingleChildScrollView(
            child: Form(
              key: _keyform,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizeBoxHeight(50),
                  twoText(
                    fontWeight: FontWeight.w600,
                    text1: languageController.textTranslate(
                      "Add Business Images",
                    ),
                    text2: " *",
                    size: 11,
                    mainAxisAlignment: MainAxisAlignment.start,
                    style1: AppTypography.outerMedium(context).copyWith(
                      color: themeContro.isLightMode.value
                          ? Appcolors.appTextColor.textBlack
                          : Appcolors.appTextColor.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  sizeBoxHeight(7),
                  GestureDetector(
                    onTap: () {
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
                                      setState(() {});
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
                                final isSelected = selectedAssets.contains(
                                  asset,
                                );

                                return GestureDetector(
                                  onTap: () {
                                    if (isSelected) {
                                      selectedAssets.remove(asset);
                                    } else if (selectedAssets.length < 10) {
                                      selectedAssets.add(asset);
                                    }
                                    setState(() {});
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: thumb != null
                                            ? Image.memory(
                                                thumb,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                color: Colors.grey[300],
                                              ),
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
                    },
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
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
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: getProportionateScreenHeight(58),
                          child: serviceController.serviceIndex.value == -1
                              ? ListView.separated(
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
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.topRight,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedAssets.removeAt(index);
                                              selectedImageFiles.removeAt(
                                                index,
                                              );
                                              selectedAssets;
                                              selectedImageFiles;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Appcolors.colorB0B0B0,
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                combinedImages[index],
                                                fit: BoxFit.cover,
                                                height:
                                                    getProportionateScreenHeight(
                                                      52,
                                                    ),
                                                width:
                                                    getProportionateScreenWidth(
                                                      52,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: -5,
                                          top: -5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedAssets.removeAt(index);
                                                selectedImageFiles.removeAt(
                                                  index,
                                                );
                                                selectedAssets;
                                                selectedImageFiles;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
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
                                )
                              : ListView.separated(
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
                                    bool isEventImage =
                                        index <
                                        serviceController
                                            .serviceList[serviceController
                                                .serviceIndex
                                                .value]
                                            .storeImages!
                                            .length;

                                    return Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.topRight,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (isEventImage) {
                                              serviceController.removeServiceImgApi(
                                                serviceID: serviceController
                                                    .serviceList[serviceController
                                                        .serviceIndex
                                                        .value]
                                                    .id
                                                    .toString(),
                                                serviceIMGID: serviceController
                                                    .serviceList[serviceController
                                                        .serviceIndex
                                                        .value]
                                                    .storeImages![index]
                                                    .id
                                                    .toString(),
                                              );
                                              setState(() {
                                                serviceController
                                                    .serviceList[serviceController
                                                        .serviceIndex
                                                        .value]
                                                    .storeImages!
                                                    .removeAt(index);
                                              });
                                            } else {
                                              setState(() {
                                                selectedAssets.removeAt(
                                                  index -
                                                      serviceController
                                                          .serviceList[serviceController
                                                              .serviceIndex
                                                              .value]
                                                          .storeImages!
                                                          .length,
                                                );
                                                selectedImageFiles.removeAt(
                                                  index -
                                                      serviceController
                                                          .serviceList[serviceController
                                                              .serviceIndex
                                                              .value]
                                                          .storeImages!
                                                          .length,
                                                );
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Appcolors.colorB0B0B0,
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: isEventImage
                                                  ? Image.network(
                                                      combinedImages[index]!.url
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      height:
                                                          getProportionateScreenHeight(
                                                            52,
                                                          ),
                                                      width:
                                                          getProportionateScreenWidth(
                                                            52,
                                                          ),
                                                    )
                                                  : Image.file(
                                                      combinedImages[index]!,
                                                      fit: BoxFit.cover,
                                                      height:
                                                          getProportionateScreenHeight(
                                                            52,
                                                          ),
                                                      width:
                                                          getProportionateScreenWidth(
                                                            52,
                                                          ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: -5,
                                          top: -5,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (isEventImage) {
                                                serviceController.removeServiceImgApi(
                                                  serviceID: serviceController
                                                      .serviceList[serviceController
                                                          .serviceIndex
                                                          .value]
                                                      .id
                                                      .toString(),
                                                  serviceIMGID: serviceController
                                                      .serviceList[serviceController
                                                          .serviceIndex
                                                          .value]
                                                      .storeImages![index]
                                                      .id
                                                      .toString(),
                                                );
                                                setState(() {
                                                  serviceController
                                                      .serviceList[serviceController
                                                          .serviceIndex
                                                          .value]
                                                      .storeImages!
                                                      .removeAt(index);
                                                });
                                              } else {
                                                setState(() {
                                                  selectedAssets.removeAt(
                                                    index -
                                                        serviceController
                                                            .serviceList[serviceController
                                                                .serviceIndex
                                                                .value]
                                                            .storeImages!
                                                            .length,
                                                  );
                                                  selectedImageFiles.removeAt(
                                                    index -
                                                        serviceController
                                                            .serviceList[serviceController
                                                                .serviceIndex
                                                                .value]
                                                            .storeImages!
                                                            .length,
                                                  );
                                                });
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
                  sizeBoxHeight(20),
                  globalTextField(
                    lable: languageController.textTranslate("Service Name"),
                    lable2: " *",
                    controller: serviceNameController,
                    onEditingComplete: () {
                      Focus.of(context).requestFocus(nameFocus);
                    },
                    isEmail: false,
                    isNumber: false,
                    focusNode: nameFocus1,
                    hintText: languageController.textTranslate("Service Name"),
                    context: context,
                  ),
                  sizeBoxHeight(20),
                  globalTextField(
                    lable: languageController.textTranslate(
                      "Service Description",
                    ),
                    lable2: " *",
                    controller: serviceDescController,
                    maxLines: 5,
                    onEditingComplete: () {
                      Focus.of(context).requestFocus(descFocus);
                    },
                    isEmail: false,
                    isNumber: false,
                    focusNode: descFocus1,
                    hintText: languageController.textTranslate(
                      "Service Description",
                    ),
                    context: context,
                  ),
                  sizeBoxHeight(20),
                  globalTextField(
                    lable: languageController.textTranslate("Price"),
                    lable2: " *",
                    maxLength: 7,
                    isNumber: true,
                    controller: servicePriceController,
                    onEditingComplete: () {
                      Focus.of(context).requestFocus(prieFocus);
                    },
                    focusNode: priceFocus1,
                    hintText: languageController.textTranslate("Add Price"),
                    context: context,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  sizeBoxHeight(20),
                  label(
                    languageController.textTranslate("Attach Files"),
                    style: AppTypography.outerMedium(context).copyWith(
                      fontSize: 13,
                      color: themeContro.isLightMode.value
                          ? Appcolors.appTextColor.textBlack
                          : Appcolors.appTextColor.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  sizeBoxHeight(7),
                  GestureDetector(
                    onTap: () {
                      openDocPicker();
                    },
                    child: Container(
                      height: getProportionateScreenHeight(100),
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appStrokColor.cF0F0F0
                              : Appcolors.grey1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppAsstes.file, height: 25),
                          sizeBoxHeight(5),
                          Text(
                            languageController.textTranslate("Add Files"),
                            style: poppinsFont(
                              11,
                              Appcolors.appTextColor.textLighGray,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  combinedAttchment.isEmpty
                      ? const SizedBox.shrink()
                      : sizeBoxHeight(12),
                  combinedAttchment.isEmpty
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: getProportionateScreenHeight(30),
                          child: serviceController.serviceIndex.value == -1
                              ? ListView.builder(
                                  clipBehavior: Clip.none,
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: combinedAttchment.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Appcolors
                                              .appPriSecColor
                                              .appPrimblue,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            extractFilename(
                                              combinedAttchment[index]!.path,
                                            ).toString().split("-").last,
                                            style: poppinsFont(
                                              8,
                                              themeContro.isLightMode.value
                                                  ? Appcolors.black
                                                  : Appcolors.white,
                                              FontWeight.w500,
                                            ),
                                          ),
                                          sizeBoxWidth(5),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedFile.removeAt(index);
                                                selectedFile;
                                              });
                                            },
                                            child: Image.asset(
                                              AppAsstes.close,
                                              height: 10,
                                            ),
                                          ),
                                        ],
                                      ).paddingAll(5),
                                    ).paddingOnly(right: 5);
                                  },
                                )
                              : ListView.builder(
                                  clipBehavior: Clip.none,
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: combinedAttchment.length,
                                  itemBuilder: (context, index) {
                                    bool isAttachment =
                                        index <
                                        serviceController
                                            .serviceList[serviceController
                                                .serviceIndex
                                                .value]
                                            .storeAttachments!
                                            .length;
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Appcolors
                                              .appPriSecColor
                                              .appPrimblue,
                                        ),
                                      ),
                                      child: isAttachment
                                          ? Row(
                                              children: [
                                                Text(
                                                  extractFilename(
                                                    combinedAttchment[index].url
                                                        .toString(),
                                                  ).toString().split("-").last,
                                                  style: poppinsFont(
                                                    8,
                                                    themeContro
                                                            .isLightMode
                                                            .value
                                                        ? Appcolors.black
                                                        : Appcolors.white,
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                                sizeBoxWidth(5),
                                                GestureDetector(
                                                  onTap: () {
                                                    serviceController.removeServiceAttachApi(
                                                      serviceID: serviceController
                                                          .serviceList[serviceController
                                                              .serviceIndex
                                                              .value]
                                                          .id
                                                          .toString(),
                                                      serviceIMGID: serviceController
                                                          .serviceList[serviceController
                                                              .serviceIndex
                                                              .value]
                                                          .storeAttachments![index]
                                                          .id
                                                          .toString(),
                                                    );
                                                    setState(() {
                                                      serviceController
                                                          .serviceList[serviceController
                                                              .serviceIndex
                                                              .value]
                                                          .storeAttachments!
                                                          .removeAt(index);
                                                      (combinedAttchment);
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    AppAsstes.close,
                                                    height: 10,
                                                  ),
                                                ),
                                              ],
                                            ).paddingAll(5)
                                          : Row(
                                              children: [
                                                Text(
                                                  extractFilename(
                                                    combinedAttchment[index]!
                                                        .path,
                                                  ).toString().split("-").last,
                                                  style: poppinsFont(
                                                    8,
                                                    themeContro
                                                            .isLightMode
                                                            .value
                                                        ? Appcolors.black
                                                        : Appcolors.white,
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                                sizeBoxWidth(5),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedFile.removeAt(
                                                        index -
                                                            serviceController
                                                                .serviceList[serviceController
                                                                    .serviceIndex
                                                                    .value]
                                                                .storeAttachments!
                                                                .length,
                                                      );
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    AppAsstes.close,
                                                    height: 10,
                                                  ),
                                                ),
                                              ],
                                            ).paddingAll(5),
                                    ).paddingOnly(right: 5);
                                  },
                                ),
                        ),
                  sizeBoxHeight(200),
                ],
              ).paddingOnly(left: 20, right: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget button() {
    return Obx(() {
      if (serviceController.serviceIndex.value == -1) {
        return serviceController.isloading.value
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
                    if (_keyform.currentState!.validate()) {
                      if (selectedImageFiles.isEmpty) {
                        snackBar(
                          languageController.textTranslate(
                            "Please add your business images",
                          ),
                        );
                      } else {
                        serviceController.addServiceApi(
                          name: serviceNameController.text,
                          desc: serviceDescController.text,
                          price: servicePriceController.text,
                          storeImages: selectedImageFiles
                              .map((file) => file.path)
                              .toList(),
                          storeAttachment: selectedFilePaths,
                        );
                      }
                    }
                  } else {
                    snackBar("This is for demo, We can not allow to add");
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
                left: 20,
                right: 20,
              );
      } else {
        return serviceController.isUpdate.value
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
                    if (_keyform.currentState!.validate()) {
                      if (selectedImageFiles.isEmpty) {
                        snackBar(
                          languageController.textTranslate(
                            "Please add your business images",
                          ),
                        );
                      } else {
                        serviceController.updateServiceApi(
                          serviceID: serviceController
                              .serviceList[serviceController.serviceIndex.value]
                              .id
                              .toString(),
                          name: serviceNameController.text,
                          desc: serviceDescController.text,
                          price: servicePriceController.text,
                          storeImages: selectedImageFiles
                              .map((file) => file.path)
                              .toList(),
                          storeAttachment: selectedFilePaths,
                        );
                      }
                    }
                  } else {
                    snackBar("This is for demo, We can not allow to add");
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
                left: 20,
                right: 20,
              );
      }
    }).paddingSymmetric(horizontal: 35);
  }

  FilePickerResult? pickedFileDoc;
  List<File?> selectedFile = [];
  List<String> selectedFilePaths = [];

  Future<void> openDocPicker() async {
    nameFocus.unfocus();
    nameFocus1.unfocus();
    descFocus.unfocus();
    descFocus1.unfocus();
    prieFocus.unfocus();
    priceFocus1.unfocus();
    pickedFileDoc = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      dialogTitle: "Nlytical Vendor",
      allowCompression: true,
      allowMultiple: true,
    );

    if (pickedFileDoc != null && pickedFileDoc!.files.isNotEmpty) {
      selectedFile = pickedFileDoc!.paths.map((path) => File(path!)).toList();
      selectedFilePaths = pickedFileDoc!.paths.map((path) => (path!)).toList();
      setState(() {});
    }
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
                      borderRadius: BorderRadius.circular(20),
                      color: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      boxShadow: [
                        BoxShadow(
                          color: Appcolors.black.withValues(alpha: 0.12),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          offset: const Offset(0.0, 2.0),
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
