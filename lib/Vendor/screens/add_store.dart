// ignore_for_file: avoid_print, deprecated_member_use, depend_on_referenced_packages, unused_field

import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/user_models/subcate_model.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/theame_switch.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:nlytical/models/vendor_models/category_model.dart';

class AddStore extends StatefulWidget {
  const AddStore({super.key});

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  final ScrollController _scrollController = ScrollController();
  final StoreController storeController = Get.put(StoreController());
  int currentIndex = 1;
  bool featuredon = false;
  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> requestPermission() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.storage.request();
  }

  String? categoryValue;
  String? categoryName;
  String categoryID = '';

  String? subCategoryValue;
  String? subCategoryName;
  String subCategoryID = '';

  @override
  void initState() {
    storeController.getCategory();
    categoryValue = null;

    subCategoryValue = null;
    emailController.text = userEmail;

    boolData();
    super.initState();
  }

  Future<void> getdata() async {
    contrycode = (await SecurePrefs.getString(
      SecureStorageKeys.COUINTRY_CODE,
    ))!;
    mobilecontroller.text = getMobile(
      (await SecurePrefs.getString(SecureStorageKeys.USER_MOBILE))!,
    );
  }

  @override
  void dispose() {
    requestPermission();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollAndNextSection() {
    currentIndex++;
    if (currentIndex < 3) {
      _scrollToTop();
    }
    setState(() {});
  }

  double getProgressValue() {
    return currentIndex / 3; // Calculates progress as a fraction
  }

  bool isOpen = false;

  final businessNameController = TextEditingController();
  final businessDesciptionController = TextEditingController();
  final businessAddressController = TextEditingController();
  final mobilecontroller = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final whpLinkController = TextEditingController();
  final faceBookLinkController = TextEditingController();
  final instaLinkController = TextEditingController();
  final twitterLinkController = TextEditingController();
  final startPeriodController = TextEditingController();
  final endPeriodController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode nameFocus1 = FocusNode();

  FocusNode descFocus = FocusNode();
  FocusNode descFocus1 = FocusNode();

  FocusNode addressFocus = FocusNode();
  FocusNode addressFocus1 = FocusNode();

  FocusNode mobileFocus = FocusNode();
  FocusNode mobileFocus1 = FocusNode();

  FocusNode emailFocus = FocusNode();
  FocusNode emailFocus1 = FocusNode();

  FocusNode webFocus = FocusNode();
  FocusNode webFocus1 = FocusNode();

  FocusNode whpFocus = FocusNode();
  FocusNode whpFocus1 = FocusNode();

  FocusNode fcFocus = FocusNode();
  FocusNode fcFocus1 = FocusNode();

  FocusNode instaFocus = FocusNode();
  FocusNode instaFocus1 = FocusNode();

  FocusNode twiFocus = FocusNode();
  FocusNode twiFocus1 = FocusNode();

  // mutiple image select
  FilePickerResult? pickedFileImage;
  List<File?> files = [];
  List<String> filePaths = [];

  List<File?> coverfiles = [];
  List<String> coverfilePaths = [];

  Future<void> openImagePicker() async {
    pickedFileImage = await FilePicker.platform.pickFiles(
      type: FileType.image,
      // allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      allowCompression: true,
      allowMultiple: true,
    );
    if (pickedFileImage != null) {
      files = pickedFileImage!.paths.map((path) => File(path!)).toList();
      filePaths = pickedFileImage!.paths.map((path) => (path!)).toList();
      setState(() {});
    }
  }

  Future<void> openCoverImagePicker() async {
    pickedFileImage = await FilePicker.platform.pickFiles(
      type: FileType.image,
      // allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      allowCompression: true,
      allowMultiple: true,
    );
    if (pickedFileImage != null) {
      coverfiles = pickedFileImage!.paths.map((path) => File(path!)).toList();
      coverfilePaths = pickedFileImage!.paths.map((path) => (path!)).toList();
      setState(() {});
    }
  }

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

  TimeOfDay _selectedTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context, bool isForStartTime) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: poppinsFont(
                  16,
                  Appcolors.black,
                  FontWeight.w500,
                ),
              ),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _selectedTime = TimeOfDay.fromDateTime(newDateTime);

                  // Format time as 12-hour with AM/PM using intl
                  String formattedTime = DateFormat.jm().format(newDateTime);

                  if (isForStartTime) {
                    startTimeController.text = formattedTime;
                  } else {
                    endTimeController.text = formattedTime;
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  final List<String> _monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  String? selectedMonthValue;

  final List<String> _yearList = List.generate(
    DateTime.now().year - 1990 + 1,
    (index) => (DateTime.now().year - index).toString(),
  );

  String? selectedYearValue; // To store the selected year

  bool whpvalue = false;
  bool fcvalue = false;
  bool instavalue = false;
  bool twvalue = false;
  Future boolData() async {
    whpLinkController.text.trim().isNotEmpty
        ? whpvalue = true
        : whpvalue = false;

    faceBookLinkController.text.trim().isNotEmpty
        ? fcvalue = true
        : fcvalue = false;

    instaLinkController.text.trim().isNotEmpty
        ? instavalue = true
        : instavalue = false;

    twitterLinkController.text.trim().isNotEmpty
        ? twvalue = true
        : twvalue = false;
  }

  bool isValidInstagramUrl(String url) {
    final regex = RegExp(
      r'^(https?:\/\/)?(www\.)?instagram\.com\/[a-zA-Z0-9(_)?\-\.]+\/?(\?.*)?$',
    );
    return regex.hasMatch(url.trim());
  }

  bool isValidFacebookUrl(String url) {
    final regex = RegExp(
      r'^(https?:\/\/)?(www\.)?facebook\.com\/[a-zA-Z0-9(\.\-)?]+\/?(\?.*)?$',
    );
    return regex.hasMatch(url.trim());
  }

  bool isValidTwitterUrl(String url) {
    final regex = RegExp(
      r'^(https?:\/\/)?(www\.)?twitter\.com\/[A-Za-z0-9_]+\/?(\?.*)?$',
    );
    return regex.hasMatch(url.trim());
  }

  bool isValidWhatsAppUrl(String url) {
    final regex = RegExp(
      r'^(https?:\/\/)?(wa\.me\/\d+|api\.whatsapp\.com\/(send\?phone=\d+|[\d]+))([&?].*)?$',
      caseSensitive: false,
    );
    return regex.hasMatch(url.trim());
  }

  String? validateInstagram(String? value) {
    if (value == null || value.isEmpty) return null;
    return isValidInstagramUrl(value) ? null : 'Invalid Instagram URL';
  }

  String? validateFacebook(String? value) {
    if (value == null || value.isEmpty) return null;
    return isValidFacebookUrl(value) ? null : 'Invalid Facebook URL';
  }

  String? validateTwitter(String? value) {
    if (value == null || value.isEmpty) return null;
    return isValidTwitterUrl(value) ? null : 'Invalid Twitter URL';
  }

  String? validateWhatsApp(String? value) {
    if (value == null || value.isEmpty) return null;
    return isValidWhatsAppUrl(value) ? null : 'Invalid WhatsApp URL';
  }

  void getBackRemove() {
    storeController.caategoryName.value = '';
    storeController.subCategoryNames.value = [];
    storeController.subCategories.value = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: AppBar(
        backgroundColor: Appcolors.appBgColor.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
          child: Image.asset(
            userTextDirection == "ltr"
                ? 'assets/images/arrow-left1.png'
                : "assets/images/arrow-left (1).png",
            color: Appcolors.white,
            height: 25,
          ),
          onTap: () {
            if (currentIndex == 1) {
              // getBackRemove();
              Get.back();
            } else {
              setState(() {
                currentIndex--; // go back to previous step
              });
            }
          },
        ).paddingAll(15),
        titleSpacing: 20,
        flexibleSpace: flexibleSpace(),
        centerTitle: true,
        title: Text(
          currentIndex == 1
              ? languageController.textTranslate("Add Store")
              : currentIndex == 2
              ? languageController.textTranslate("Contact Details")
              : languageController.textTranslate("Business Time"),
          style: AppTypography.h1(
            context,
          ).copyWith(color: Appcolors.appTextColor.textWhite),
        ),
      ),
      body: Container(
        width: Get.width,
        decoration: BoxDecoration(color: Appcolors.appPriSecColor.appPrimblue),
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: themeContro.isLightMode.value
                ? Color(0xffEEF5FF)
                : Color(0xff1E242C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // ******* top progress bar ******
              progress(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: themeContro.isLightMode.value
                        ? Appcolors.white
                        : Appcolors.darkMainBlack,
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizeBoxHeight(20),
                        currentIndex == 1
                            ? businessDetails().paddingSymmetric(horizontal: 20)
                            : currentIndex == 2
                            ? contactDetails().paddingSymmetric(horizontal: 20)
                            : businessTime().paddingSymmetric(horizontal: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    addStore();
                  },
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    color: Appcolors.appPriSecColor.appPrimblue,
                    child: storeController.addStoreLoad.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Appcolors.white,
                                strokeAlign: -6,
                                strokeWidth: 2,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                    strokeAlign: -6,
                                    strokeCap: StrokeCap.round,
                                    value:
                                        getProgressValue(), // Update progress based on index
                                    backgroundColor: Appcolors.appBgColor.white
                                        .withValues(alpha: 0.12),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Appcolors.white,
                                    ),
                                  ),
                                  Text(
                                    currentIndex
                                        .toString(), // Display the percentage here
                                    style: poppinsFont(
                                      10,
                                      Appcolors.white,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              sizeBoxWidth(10),
                              Text(
                                currentIndex == 1
                                    ? languageController.textTranslate(
                                        "Next Step",
                                      )
                                    : currentIndex == 2
                                    ? languageController.textTranslate(
                                        "Next Step",
                                      )
                                    : languageController.textTranslate(
                                        "Submit",
                                      ),
                                style: poppinsFont(
                                  14,
                                  Appcolors.white,
                                  FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                  ),
                ).paddingOnly(bottom: 10);
              }),
            ],
          ).paddingOnly(top: 10),
        ),
      ),
    );
  }

  void addStore() {
    if (currentIndex == 1) {
      if (businessNameController.text.trim().isNotEmpty &&
          businessDesciptionController.text.trim().isNotEmpty &&
          businessAddressController.text.isNotEmpty &&
          coverfiles.isNotEmpty &&
          files.isNotEmpty && // Corrected this condition
          storeController.caategoryName.isNotEmpty &&
          storeController.subCategoryNames.isNotEmpty &&
          selectedVtypes != "" &&
          selectedMonthValue != "" &&
          selectedYearValue != "") {
        scrollAndNextSection();
      } else {
        snackBar(languageController.textTranslate("Fill the mandatory fields"));
      }
    } else if (currentIndex == 2) {
      if (mobilecontroller.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty) {
        scrollAndNextSection();
      } else {
        snackBar(languageController.textTranslate("Fill the mandatory fields"));
      }
    } else {
      if (isDemo == "false") {
        if (storeController.openingAndClosingDays.isNotEmpty &&
            startTimeController.text.trim().isNotEmpty &&
            endTimeController.text.trim().isNotEmpty) {
          storeController.addSotreApi(
            // featured: featuredon ? "1" : "0",
            storeName: businessNameController.text.trim(),
            storeDescription: businessDesciptionController.text.trim(),
            address: businessAddressController.text.trim(),
            lat: storeController.searchLatitude.toString(),
            lon: storeController.searchLongitude.toString(),
            // Fixed lon
            coverImages: coverfilePaths,
            storeImages: filePaths,
            storeVideoThumbnail: thumbnailPath!.isEmpty ? "" : thumbnailPath!,
            storeVideo: pickedFileVideo == null
                ? ""
                : pickedFileVideo!.files.first.path!,
            categoryId: storeController.categoryData.value.data!
                .where(
                  (element) =>
                      element.categoryName ==
                      storeController.caategoryName.value,
                )
                .first
                .id
                .toString(),
            subCategoryId: storeController.categoryData.value.data!
                .where(
                  (category) =>
                      category.categoryName ==
                      storeController.caategoryName.value,
                )
                .first
                .subCategoryData!
                .where(
                  (subCategory) => storeController.subCategoryNames.contains(
                    subCategory.subcategoryName,
                  ),
                )
                .map((subCategory) => subCategory.id.toString())
                .toList()
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll(' ', ''),
            employeeStrength: selectedVtypes.toString(),
            publishedMonth: selectedMonthValue.toString(),
            publishedYear: selectedYearValue.toString(),
            openDays: storeController.openingAndClosingDays
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', ''),
            closeDays: storeController.days
                .toSet()
                .difference(storeController.openingAndClosingDays.toSet())
                .toList()
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', ''),
            openTime:
                "${startTimeController.text.trim()} ${startPeriodController.text.trim()}",
            closeTime:
                "${endTimeController.text.trim()} ${endPeriodController.text.trim()}",
            countryCode: contrycode,
            storePhone: contrycode + mobilecontroller.text.trim(),
            storeEmail: emailController.text.trim(),
            storeSite: websiteController.text.trim(),
            facebooklink: faceBookLinkController.text.trim().isNotEmpty
                ? faceBookLinkController.text.trim()
                : "",
            instagramlink: instaLinkController.text.trim().isNotEmpty
                ? instaLinkController.text.trim()
                : "",
            twitterlink: twitterLinkController.text.trim().isNotEmpty
                ? twitterLinkController.text.trim()
                : "",
            whatsapplink: whpLinkController.text.trim().isNotEmpty
                ? whpLinkController.text.trim()
                : "",
          );
          storeController.caategoryName.value = '';
          storeController.subCategoryNames.value = [];
          storeController.subCategories.value = [];
        } else {
          snackBar(
            languageController.textTranslate("Fill the mandatory fields"),
          );
        }
      } else {
        snackBar("This is for demo, We can not allow to add");
      }
    }
  }

  Widget textH3({required String title}) {
    return Text(
      title,
      style: AppTypography.h3(
        context,
      ).copyWith(fontWeight: FontWeight.w600).copyWith(fontSize: 14.5),
    );
  }

  //=============================================================== ADD BUSINESS DETAIL ====================================================================================
  //=============================================================== ADD BUSINESS DETAIL ====================================================================================
  //=============================================================== ADD BUSINESS DETAIL ====================================================================================
  Widget businessDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //*********************************** Business Name ************************************ */
        textH3(title: languageController.textTranslate("Business Detail")),
        sizeBoxHeight(20),
        globalTextField(
          lable: languageController.textTranslate("Business Name"),
          lable2: " *",
          controller: businessNameController,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(nameFocus);
          },
          isEmail: false,
          isNumber: false,
          focusNode: nameFocus1,
          hintText: languageController.textTranslate("Business Name"),
          context: context,
        ),
        sizeBoxHeight(20),
        //*********************************** Business Description ************************************ */
        globalTextField(
          maxLines: 5,
          lable2: " *",
          lable: languageController.textTranslate("Business Description"),
          controller: businessDesciptionController,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(descFocus);
          },
          isEmail: false,
          isNumber: false,
          focusNode: descFocus1,
          hintText: languageController.textTranslate("Business Description"),
          context: context,
        ),
        sizeBoxHeight(20),
        //*********************************** Business Address ************************************ */
        globalTextField(
          maxLines: 5,
          lable2: " *",
          lable: languageController.textTranslate("Business Address"),
          controller: businessAddressController,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(addressFocus);
          },
          isEmail: false,
          isNumber: false,
          onChanged: (p0) async {
            setState(() {});
            await storeController.getLonLat(p0);
            await storeController.getsuggestion(p0);
            setState(() {});
          },
          focusNode: addressFocus1,
          hintText: languageController.textTranslate("Business Address"),
          context: context,
        ),
        businessAddressController.text.isEmpty
            ? const SizedBox()
            : storeController.mapresult.isEmpty
            ? const SizedBox()
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: storeController.mapresult.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          businessAddressController.text =
                              storeController.mapresult[index]['description'];
                          storeController.mapresult.clear();
                          storeController.getLonLat(
                            businessAddressController.text,
                          );
                        });
                      },
                      child:
                          Text(
                            storeController.mapresult[index]['description'],
                            style: TextStyle(
                              color: themeContro.isLightMode.value
                                  ? Appcolors.black
                                  : Appcolors.white,
                            ),
                          ).paddingOnly(
                            left: 12,
                            bottom:
                                storeController.mapresult.length - 1 == index
                                ? 0
                                : 15,
                          ),
                    );
                  },
                ),
              ),
        sizeBoxHeight(20),
        twoText(
          fontWeight: FontWeight.w600,
          text1: languageController.textTranslate("Add Cover Images"),
          text2: " *",
          style1: AppTypography.outerMedium(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
            fontWeight: FontWeight.w600,
          ),
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(6),
        GestureDetector(
          onTap: () {
            openCoverImagePicker();
          },
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: themeContro.isLightMode.value
                  ? Appcolors.white
                  : Appcolors.darkGray,
              border: Border.all(
                color: themeContro.isLightMode.value
                    ? Appcolors.appStrokColor.cF0F0F0
                    : Appcolors.darkBorder,
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
                  style: poppinsFont(8, Appcolors.colorB0B0B0, FontWeight.w400),
                ),
              ],
            ).paddingSymmetric(vertical: 25),
          ),
        ),
        sizeBoxHeight(5),
        coverfiles.isEmpty ? const SizedBox.shrink() : sizeBoxHeight(12),
        coverfiles.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                height: getProportionateScreenHeight(58),
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: coverfiles.length,
                  separatorBuilder: (context, index) {
                    return sizeBoxWidth(15);
                  },
                  itemBuilder: (BuildContext context, int index) {
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
                            child: Image.file(
                              coverfiles[index]!,
                              fit: BoxFit.cover,
                              height: getProportionateScreenHeight(52),
                              width: getProportionateScreenWidth(52),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                coverfiles.removeAt(index);
                                coverfiles;
                                (coverfiles);
                              });
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
        twoText(
          fontWeight: FontWeight.w600,
          text1: languageController.textTranslate("Add Business Images"),
          text2: " *",
          style1: AppTypography.outerMedium(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
            fontWeight: FontWeight.w600,
          ),
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(6),
        GestureDetector(
          onTap: () {
            openImagePicker();
          },
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: themeContro.isLightMode.value
                  ? Appcolors.white
                  : Appcolors.darkGray,
              border: Border.all(
                color: themeContro.isLightMode.value
                    ? Appcolors.appStrokColor.cF0F0F0
                    : Appcolors.darkBorder,
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
                  style: poppinsFont(8, Appcolors.colorB0B0B0, FontWeight.w400),
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
        files.isEmpty ? const SizedBox.shrink() : sizeBoxHeight(12),
        files.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                height: getProportionateScreenHeight(58),
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: files.length,
                  separatorBuilder: (context, index) {
                    return sizeBoxWidth(15);
                  },
                  itemBuilder: (BuildContext context, int index) {
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
                            child: Image.file(
                              files[index]!,
                              fit: BoxFit.cover,
                              height: getProportionateScreenHeight(52),
                              width: getProportionateScreenWidth(52),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                files.removeAt(index);
                                files;
                                (files);
                              });
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
        label(
          languageController.textTranslate("Add Business Video"),
          style: AppTypography.outerMedium(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        sizeBoxHeight(6),
        GestureDetector(
          onTap: () {
            openVideoPicker();
          },
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: themeContro.isLightMode.value
                  ? Appcolors.white
                  : Appcolors.darkGray,
              border: Border.all(
                color: themeContro.isLightMode.value
                    ? Appcolors.appStrokColor.cF0F0F0
                    : Appcolors.darkBorder,
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
                  languageController.textTranslate("Service Video"),
                  style: poppinsFont(8, Appcolors.colorB0B0B0, FontWeight.w400),
                ),
              ],
            ).paddingSymmetric(vertical: 25),
          ),
        ),
        sizeBoxHeight(10),
        label(
          languageController.textTranslate(
            "Note: You can upload only one video",
          ),
          maxLines: 2,
          style: poppinsFont(
            9,
            Appcolors.appTextColor.textLighGray,
            FontWeight.w400,
          ),
        ),
        thumbnailPath!.isEmpty ? const SizedBox.shrink() : sizeBoxHeight(12),
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
                          Image.file(
                            File(thumbnailPath!),
                            fit: BoxFit.cover,
                            height: getProportionateScreenHeight(53),
                            width: getProportionateScreenWidth(68),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Appcolors.white.withOpacity(0.06),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Appcolors.colorB0B0B0.withOpacity(0.12),
                                width: 0.33,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 4.9,
                                  sigmaY: 4.9,
                                ),
                                child: Image.asset(
                                  AppAsstes.play2,
                                  height: getProportionateScreenHeight(7),
                                  width: getProportionateScreenWidth(7),
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
              ),
        sizeBoxHeight(20),
        //********************************************************************************************/
        //                                 CATEGORY DROPDOWN                                         /
        //******************************************************************************************/
        twoText(
          text1: languageController.textTranslate("Categories"),
          text2: " *",
          style1: AppTypography.outerMedium(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
            fontWeight: FontWeight.w600,
          ),
          fontWeight: FontWeight.w600,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(7),
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 15, right: 15),
                fillColor: themeContro.isLightMode.value
                    ? Colors.white
                    : Appcolors.appBgColor.darkGray,
                filled: true,
                errorStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.darkBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.darkBorder,
                    width: 1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.darkBorder,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.darkBorder,
                  ),
                ),
              ),
              isEmpty: categoryValue == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: themeContro.isLightMode.value
                      ? Appcolors.appBgColor.white
                      : Appcolors.appBgColor.darkGray,
                  menuMaxHeight: 350,
                  padding: EdgeInsets.zero,
                  icon: Transform.rotate(
                    angle: -pi / 2,
                    child: Image.asset(
                      "assets/images/arrow-left1.png",
                      height: 20,
                      color: themeContro.isLightMode.value
                          ? Appcolors.black
                          : Appcolors.white,
                    ),
                  ),
                  iconEnabledColor: themeContro.isLightMode.value
                      ? Appcolors.appStrokColor.cF0F0F0
                      : Appcolors.darkBorder,
                  iconDisabledColor: themeContro.isLightMode.value
                      ? Appcolors.appStrokColor.cF0F0F0
                      : Appcolors.darkBorder,
                  value: null,
                  isDense: true,
                  hint: Text(
                    "Categories",
                    style: AppTypography.text11Regular(context),
                  ),
                  style: AppTypography.text11Regular(context),
                  onChanged: (String? newValue) {
                    setState(() async {
                      categoryValue = newValue;
                      subCategoryValue = null;
                      storeController.subCategoryNames.clear();

                      // Update categoryID based on selected category name
                      final selectedCategory = storeController.cateListData
                          .firstWhere((item) => item.categoryName == newValue);

                      categoryID = selectedCategory.id.toString();

                      // ✅ Update the controller value
                      storeController.caategoryName.value =
                          selectedCategory.categoryName!;

                      int index = storeController.cateListData.indexWhere(
                        (item) => item.id.toString() == categoryID,
                      );

                      await storeController.getSubCategory(
                        categoryId: categoryID,
                        index: index,
                      );
                      storeController.subCateModel.refresh();
                      storeController.subCategoryList.refresh();
                      // if (storeController.subCategoryList.isEmpty) {
                      //   snackBar(
                      //     "No subcategories found. Please select another category.",
                      //   );
                      // }
                      setState(() {});
                      // Optional: Update form state
                      state.didChange(newValue);
                    });
                  },
                  items: storeController.cateListData.map((Data item) {
                    return DropdownMenuItem(
                      value: item.categoryName,
                      child: Text(
                        item.categoryName!,
                        style: AppTypography.text11Regular(context),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
          validator: (value) {
            if (categoryValue == null || categoryValue!.isEmpty) {
              categoryValue = null;
              return 'Please select a select category';
            }
            return null;
          },
        ),
        // DropDown(forWhat: "Categories"),
        sizeBoxHeight(15),
        Obx(
          () => storeController.caategoryName.isEmpty
              ? const SizedBox.shrink()
              : globButton(
                  name: storeController.caategoryName.value,
                  gradient: Appcolors.logoColork,
                  radius: 6,
                  vertical: 5,
                  horizontal: 15,
                  isOuntLined: true,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      label(
                        storeController.caategoryName.value,
                        style: poppinsFont(
                          9,
                          themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.white,
                          FontWeight.w500,
                        ),
                      ),
                      sizeBoxWidth(8),
                      GestureDetector(
                        onTap: () {
                          storeController.caategoryName.value = '';
                          storeController.subCategoryNames.value = [];
                          storeController.subCategories.value = [];
                          setState(() {});
                        },
                        child: Icon(
                          Icons.close,
                          color: themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.white,
                          size: 10,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 12, vertical: 7),
                ),
        ),
        sizeBoxHeight(20),
        //********************************************************************************************/
        //                                SUB-CATEGORY DROPDOWN                                      /
        //******************************************************************************************/
        twoText(
          text1: languageController.textTranslate("Sub Categories"),
          text2: " *",
          style1: AppTypography.outerMedium(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
            fontWeight: FontWeight.w600,
          ),
          fontWeight: FontWeight.w600,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(7),
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 15, right: 15),
                fillColor: themeContro.isLightMode.value
                    ? Colors.white
                    : Appcolors.appBgColor.darkGray,
                filled: true,
                errorStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.darkBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.darkBorder,
                    width: 1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.darkBorder,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appStrokColor.cF0F0F0
                        : Appcolors.darkBorder,
                  ),
                ),
              ),
              isEmpty: subCategoryValue == '',
              child: DropdownButtonHideUnderline(
                child: InkWell(
                  onTap: () {
                    if (storeController.subCategoryList.isEmpty) {
                      snackBar(
                        "No subcategories found. Please select another category.",
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: storeController.subCategoryList.isEmpty,
                    child: DropdownButton<String>(
                      dropdownColor: themeContro.isLightMode.value
                          ? Appcolors.appBgColor.white
                          : Appcolors.appBgColor.darkGray,
                      menuMaxHeight: 350,
                      padding: EdgeInsets.zero,
                      icon: Transform.rotate(
                        angle: -pi / 2,
                        child: Image.asset(
                          "assets/images/arrow-left1.png",
                          height: 20,
                          color: themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.white,
                        ),
                      ),
                      iconEnabledColor: themeContro.isLightMode.value
                          ? Appcolors.appStrokColor.cF0F0F0
                          : Appcolors.darkBorder,
                      iconDisabledColor: themeContro.isLightMode.value
                          ? Appcolors.appStrokColor.cF0F0F0
                          : Appcolors.darkBorder,
                      value: null,
                      isDense: true,
                      hint: Text(
                        "Sub Categories",
                        style: AppTypography.text11Regular(context),
                      ),
                      style: AppTypography.text11Regular(context),
                      onChanged: (String? newValue) {
                        setState(() {
                          subCategoryValue = newValue;
                          if (newValue != null && newValue.isNotEmpty) {
                            if (!storeController.subCategoryNames.contains(
                              newValue,
                            )) {
                              storeController.subCategoryNames.add(newValue);
                            }
                          }
                        });
                      },
                      items: storeController.subCategoryList.map((
                        SubCategoryData item,
                      ) {
                        return DropdownMenuItem(
                          value: item.subcategoryName,
                          child: Text(
                            item.subcategoryName!,
                            style: AppTypography.text11Regular(context),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          },
          validator: (value) {
            if (subCategoryValue == null || subCategoryValue!.isEmpty) {
              subCategoryValue = null;
              return 'Please select a select sub categories';
            }
            return null;
          },
        ),
        // DropDown(forWhat: "Sub Categories"),
        storeController.subCategoryNames.isEmpty
            ? const SizedBox.shrink()
            : sizeBoxHeight(16),
        Obx(
          () => storeController.subCategoryNames.isEmpty
              ? const SizedBox.shrink()
              : SizedBox(
                  height: getProportionateScreenHeight(35),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: storeController.subCategoryNames.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return globButton(
                        name: "",
                        gradient: Appcolors.logoColork,
                        radius: 6,
                        vertical: 5,
                        horizontal: 15,
                        isOuntLined: true,
                        child: Row(
                          children: [
                            label(
                              storeController.subCategoryNames[index],
                              style: poppinsFont(
                                9,
                                themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                FontWeight.w500,
                              ),
                            ),
                            sizeBoxWidth(8),
                            GestureDetector(
                              onTap: () {
                                storeController.subCategoryNames.removeAt(
                                  index,
                                );
                              },
                              child: Icon(
                                Icons.close,
                                color: themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                size: 10,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 15),
                      ).paddingOnly(
                        right:
                            storeController.subCategoryNames.length - 1 == index
                            ? 0
                            : 10,
                      );
                    },
                  ),
                ),
        ),
        // sizeBoxHeight(7),
        // featuredSwitch(),
        sizeBoxHeight(20),
        twoText(
          text1: languageController.textTranslate("Select Number of Employees"),
          text2: " *",
          style1: AppTypography.outerMedium(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
            fontWeight: FontWeight.w600,
          ),
          fontWeight: FontWeight.w600,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(7),
        selectEmployee(),
        sizeBoxHeight(20),
        Text(
          languageController.textTranslate("Year of Establishment"),
          style: poppinsFont(
            13,
            themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
            FontWeight.w600,
          ),
        ),
        sizeBoxHeight(10),
        monthYearWidget(),
        sizeBoxHeight(30),
      ],
    );
  }

  Widget featuredSwitch() {
    return Container(
      height: 50,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkGray,
        border: Border.all(
          color: themeContro.isLightMode.value
              ? Appcolors.appStrokColor.cF0F0F0
              : Appcolors.darkBorder,
        ),
        // color: Appcolors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              label(
                languageController.textTranslate("Featured Service"),
                fontSize: 12,
                textColor: themeContro.isLightMode.value
                    ? Appcolors.black
                    : Appcolors.white,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          CustomSwitch(
            value: featuredon,
            onChanged: (bool val) {
              setState(() {
                featuredon = val;
              });
            },
          ),
        ],
      ).paddingSymmetric(horizontal: 15),
    );
  }

  String? selectedVtypes; // Allow null value
  Widget selectEmployee() {
    return Container(
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkGray,
        border: Border.all(
          color: themeContro.isLightMode.value
              ? Appcolors.appStrokColor.cF0F0F0
              : Appcolors.darkBorder,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton<String>(
        dropdownColor: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkGray,
        isExpanded: true,
        underline: const SizedBox(),
        // alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        hint: Text(
          selectedVtypes ??
              languageController.textTranslate('Select an option'),
          style: poppinsFont(
            12,
            themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
            FontWeight.w500,
          ),
        ),
        items:
            [
              'Less than 10',
              '10-100',
              '100-500',
              '500-1000',
              '1000-2000',
              '2000-5000',
              '5000-10000',
              'More than 10000',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: StatefulBuilder(
                  builder: (BuildContext context, aa) {
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.only(left: 0),
                      title: Text(
                        value,
                        style: poppinsFont(
                          12,
                          themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.white,
                          FontWeight.w600,
                        ),
                      ),
                      leading: IgnorePointer(
                        child: Radio<String>(
                          activeColor: Appcolors.appPriSecColor.appPrimblue,
                          value: value,
                          groupValue: selectedVtypes,
                          onChanged: (val) {},
                        ),
                      ), // Hide radio button if the item is selected
                    );
                  },
                ),
              );
            }).toList(),
        icon: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Transform.rotate(
            angle: -pi / 2,
            child: Image.asset(
              "assets/images/arrow-left1.png",
              height: 20,
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
            ),
          ),
        ),
        onChanged: (String? vtype) {
          setState(() {
            selectedVtypes = vtype;
          });
        },
      ),
    );
  }

  DateTime currentDate = DateTime.now();
  Widget monthYearWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              twoText(
                fontWeight: FontWeight.w600,
                text1: languageController.textTranslate("Month"),
                text2: " *",
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              sizeBoxHeight(7),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      fillColor: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      filled: true,
                      errorStyle: TextStyle(
                        color: Appcolors.appTextColor.textRedColor,
                        fontSize: 16.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: themeContro.isLightMode.value
                              ? Appcolors.bluee4
                              : Appcolors.darkBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Appcolors.black,
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Appcolors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Appcolors.black),
                      ),
                    ),
                    isEmpty: selectedMonthValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        menuMaxHeight: getProportionateScreenHeight(300),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconEnabledColor: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.white,
                        iconDisabledColor: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.white,
                        value: selectedMonthValue,
                        isDense: true,
                        hint: Text(
                          languageController.textTranslate("Select month"),
                          style: poppinsFont(
                            12,
                            themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            FontWeight.w400,
                          ),
                        ),
                        style: TextStyle(
                          color: themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.white,
                        ),
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedMonthValue = newValue!;
                            state.didChange(newValue);
                          });
                        },
                        items: _monthList.map((String month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text(
                              month.toString(),
                              style: poppinsFont(
                                12,
                                themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: (value) {
                  if (selectedMonthValue!.isEmpty) {
                    selectedMonthValue = null;
                    return 'Please select a month';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        sizeBoxWidth(20),
        Expanded(
          child: Column(
            children: [
              twoText(
                fontWeight: FontWeight.w600,
                text1: languageController.textTranslate("Year"),
                text2: " *",
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              sizeBoxHeight(7),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      fillColor: themeContro.isLightMode.value
                          ? Appcolors.white
                          : Appcolors.darkGray,
                      filled: true,
                      errorStyle: TextStyle(
                        color: Appcolors.appTextColor.textRedColor,
                        fontSize: 16.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: themeContro.isLightMode.value
                              ? Appcolors.bluee4
                              : Appcolors.darkBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Appcolors.black,
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Appcolors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Appcolors.black),
                      ),
                    ),
                    isEmpty: selectedYearValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        menuMaxHeight: getProportionateScreenHeight(300),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        dropdownColor: themeContro.isLightMode.value
                            ? Appcolors.white
                            : Appcolors.darkGray,
                        iconEnabledColor: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.white,
                        iconDisabledColor: themeContro.isLightMode.value
                            ? Appcolors.black
                            : Appcolors.white,
                        value: selectedYearValue,
                        isDense: true,
                        hint: Text(
                          languageController.textTranslate("Select Year"),
                          style: poppinsFont(
                            12,
                            themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            FontWeight.w400,
                          ),
                        ),
                        style: TextStyle(
                          color: themeContro.isLightMode.value
                              ? Appcolors.black
                              : Appcolors.white,
                        ),
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedYearValue = newValue!;
                            state.didChange(newValue);
                          });
                        },
                        items: _yearList.map((String year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(
                              year,
                              style: poppinsFont(
                                12,
                                themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white,
                                FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: (value) {
                  if (selectedYearValue == null || selectedYearValue!.isEmpty) {
                    return 'Please select a year';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //==================================================================== CONTACT DETAIL TAB =======================================================================
  //==================================================================== CONTACT DETAIL TAB =======================================================================
  //==================================================================== CONTACT DETAIL TAB =======================================================================

  String phoneNumber = '';
  Widget contactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textH3(title: languageController.textTranslate("Contact Details")),
        sizeBoxHeight(20),
        twoText(
          fontWeight: FontWeight.w600,
          text1: languageController.textTranslate("Mobile Number"),
          text2: " *",
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(7),
        IntlPhoneField(
          textAlign: userTextDirection == "ltr"
              ? TextAlign.left
              : TextAlign.right,
          dropdownTextStyle: AppTypography.text11Regular(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
          ),
          initialValue: contrycode,
          showCountryFlag: true,
          showDropdownIcon: false,
          initialCountryCode: "IN",
          onCountryChanged: (value) {
            contrycode = '+${value.dialCode}';
          },
          onChanged: (number) {
            phoneNumber = number.number;
          },
          focusNode: nameFocus1,
          cursorColor: themeContro.isLightMode.value
              ? Appcolors.bluee4
              : Appcolors.white,
          autofocus: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTypography.text11Regular(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
          ),
          controller: mobilecontroller,
          keyboardType: TextInputType.number,
          flagsButtonPadding: const EdgeInsets.only(left: 5),
          decoration: InputDecoration(
            filled: true,
            fillColor: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkGray,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Appcolors.bluee4),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: themeContro.isLightMode.value
                    ? Appcolors.appStrokColor.cF0F0F0
                    : Appcolors.darkBorder,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Appcolors.appStrokColor.cF0F0F0),
            ),
            hintText: languageController.textTranslate("Add Mobile Number"),
            hintStyle: AppTypography.text11Regular(
              context,
            ).copyWith(color: Appcolors.appTextColor.textLighGray),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Appcolors.appStrokColor.cF0F0F0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Appcolors.appStrokColor.cF0F0F0),
            ),
            errorStyle: TextStyle(
              color: Appcolors.appTextColor.textRedColor,
              fontSize: 10,
            ),
          ),
        ),
        sizeBoxHeight(20),
        globalTextField(
          isEmail: true,
          lable: languageController.textTranslate("Email"),
          lable2: " *",
          controller: emailController,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(emailFocus);
          },
          focusNode: emailFocus1,
          hintText: languageController.textTranslate("Email Address"),
          context: context,
        ),
        sizeBoxHeight(20),
        globalTextField(
          lable: languageController.textTranslate("Website"),
          lable2: " ",
          controller: websiteController,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(webFocus);
          },
          focusNode: webFocus1,
          hintText: languageController.textTranslate("Website"),
          context: context,
        ),
        sizeBoxHeight(20),
        twoText(
          fontWeight: FontWeight.w600,
          text1: languageController.textTranslate("Follow Us on"),
          text2: "",
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(7),
        followeUSOnWidget(),
        sizeBoxHeight(10),
      ],
    );
  }

  Widget followeUSOnWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkgray1,
        border: Border.all(
          color: themeContro.isLightMode.value
              ? Appcolors.grey200
              : Appcolors.darkBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              followContainer(
                img: AppAsstes.whatsapp,
                title: 'What’s app',
                isLinkValue: whpvalue,
              ),
              followContainer(
                img: AppAsstes.Facebook,
                title: 'Facebook',
                isLinkValue: fcvalue,
              ),
              followContainer(
                img: AppAsstes.instagram,
                title: 'Instagram',
                isLinkValue: instavalue,
              ),
              followContainer(
                img: AppAsstes.twitter,
                title: 'Twitter',
                isLinkValue: twvalue,
              ),
            ],
          ),
          sizeBoxHeight(5),
          socialUrlFormField(
            controller: whpLinkController,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(whpFocus);
              whpvalue = true;
            },
            onChanged: (p0) {
              whpvalue = true;
            },
            focusNode: whpFocus1,
            hintText: languageController.textTranslate('Add WhatsApp link'),
            context: context,
            validator: validateWhatsApp,
          ),
          sizeBoxHeight(10),
          socialUrlFormField(
            controller: faceBookLinkController,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(fcFocus);
            },
            onChanged: (p0) {
              fcvalue = true;
            },
            focusNode: fcFocus1,
            hintText: languageController.textTranslate(
              'Add Facebook profile link',
            ),
            context: context,
            validator: validateFacebook,
          ),
          sizeBoxHeight(10),
          socialUrlFormField(
            controller: instaLinkController,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(instaFocus);
            },
            onChanged: (p0) {
              instavalue = true;
            },
            focusNode: instaFocus1,
            hintText: languageController.textTranslate(
              'Add Instagram profile link',
            ),
            context: context,
            validator: validateInstagram,
          ),
          sizeBoxHeight(10),
          socialUrlFormField(
            controller: twitterLinkController,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(twiFocus);
            },
            onChanged: (p0) {
              twvalue = true;
            },
            focusNode: twiFocus1,
            hintText: languageController.textTranslate(
              'Add Twitter profile link',
            ),
            context: context,
            validator: validateTwitter,
          ),
        ],
      ).paddingAll(10),
    );
  }

  Widget followContainer({
    required String img,
    required String title,
    bool isLinkValue = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.darkGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLinkValue
              ? Appcolors.appPriSecColor.appPrimblue
              : Appcolors.grey,
        ),
      ),
      child: Row(
        children: [
          Image.asset(img, height: 16),
          sizeBoxWidth(5),
          Text(
            title,
            style: poppinsFont(
              7,
              themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
              FontWeight.w500,
            ),
          ),
        ],
      ).paddingAll(5),
    );
  }

  //==================================================================== BUSINESS TIME TAB ========================================================================
  //==================================================================== BUSINESS TIME TAB ========================================================================
  //==================================================================== BUSINESS TIME TAB ========================================================================
  Widget businessTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textH3(title: languageController.textTranslate("Business Time")),
        sizeBoxHeight(20),
        twoText(
          fontWeight: FontWeight.w600,
          text1: languageController.textTranslate("Business Opening Hours"),
          text2: " *",
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(7),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            border: Border.all(
              color: themeContro.isLightMode.value
                  ? Appcolors.appStrokColor.cF0F0F0
                  : Appcolors.darkBorder,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(27),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: storeController.days.length,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Obx(
                      () => GestureDetector(
                        onTap: () {
                          if (storeController.openingAndClosingDays.contains(
                            storeController.days[index],
                          )) {
                            storeController.openingAndClosingDays.remove(
                              storeController.days[index],
                            );
                            final today = DateFormat(
                              'E',
                            ).format(DateTime.now()); // e.g., "Mon"
                            setState(() {
                              isOpen = storeController.openingAndClosingDays
                                  .contains(today);
                            });
                          } else {
                            storeController.openingAndClosingDays.add(
                              storeController.days[index],
                            );
                            final today = DateFormat(
                              'E',
                            ).format(DateTime.now()); // e.g., "Mon"
                            setState(() {
                              isOpen = storeController.openingAndClosingDays
                                  .contains(today);
                            });
                          }
                        },
                        child: globButton(
                          name: storeController.days[index],
                          isOuntLined:
                              storeController.openingAndClosingDays.contains(
                                storeController.days[index],
                              )
                              ? false
                              : true,
                          gradient:
                              storeController.openingAndClosingDays.contains(
                                storeController.days[index],
                              )
                              ? Appcolors.logoColork
                              : null,
                          color: Appcolors.appPriSecColor.appPrimblue
                              .withOpacity(0.2),
                          textStyle: poppinsFont(
                            10,
                            storeController.openingAndClosingDays.contains(
                                  storeController.days[index],
                                )
                                ? Appcolors.white
                                : themeContro.isLightMode.value
                                ? Appcolors.black
                                : Appcolors.white,
                            FontWeight.w400,
                          ),
                          radius: 5,
                          horizontal: 7,
                          vertical: 4,
                        ).paddingOnly(right: 10),
                      ),
                    );
                  },
                ),
              ),
              sizeBoxHeight(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppAsstes.infoCircle,
                    height: getProportionateScreenHeight(15),
                    width: getProportionateScreenWidth(15),
                  ),
                  sizeBoxWidth(9),
                  Expanded(
                    child: label(
                      languageController.textTranslate(
                        'Select the multiple days you want to provide the service to the users',
                      ),
                      fontSize: 8,
                      maxLines: 2,
                      textColor: Appcolors.colorB0B0B0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: globalTextField(
                      controller: startTimeController,
                      focusedBorderColor: Appcolors.appStrokColor.cF0F0F0,
                      onTap: () {
                        _selectTime(context, true);
                      },
                      isOnlyRead: true,
                      onEditingComplete: () {},
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      hintText: languageController.textTranslate("Start Time"),
                      context: context,
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(16),
                        child: Image.asset(
                          AppAsstes.clock,
                          fit: BoxFit.contain,
                          height: getProportionateScreenHeight(16),
                          width: getProportionateScreenWidth(16),
                          color: Appcolors.appExtraColor.cB4B4B4,
                        ),
                      ),
                    ),
                  ),
                  sizeBoxWidth(20),
                  Expanded(
                    child: globalTextField(
                      controller: endTimeController,
                      focusedBorderColor: Appcolors.appStrokColor.cF0F0F0,
                      onTap: () {
                        _selectTime(context, false);
                      },
                      isOnlyRead: true,
                      onEditingComplete: () {
                        // FocusScope.of(context).unfocus();
                      },
                      hintText: languageController.textTranslate("End Time"),
                      context: context,
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(16),
                        child: Image.asset(
                          AppAsstes.clock,
                          fit: BoxFit.contain,
                          height: getProportionateScreenHeight(16),
                          width: getProportionateScreenWidth(16),
                          color: Appcolors.appExtraColor.cB4B4B4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 15),
        ),
        sizeBoxHeight(20),
        twoText(
          text1: languageController.textTranslate("Select Days of the Week"),
          text2: " *",
          fontWeight: FontWeight.w600,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        sizeBoxHeight(7),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkGray,
            border: Border.all(
              color: themeContro.isLightMode.value
                  ? Appcolors.appStrokColor.cF0F0F0
                  : Appcolors.darkBorder,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getProportionateScreenHeight(27),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: storeController.days.length,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Obx(
                      () => globButton(
                        name: storeController.days[index],
                        isOuntLined:
                            storeController.openingAndClosingDays.isEmpty
                            ? true
                            : storeController.openingAndClosingDays.contains(
                                storeController.days[index],
                              )
                            ? true
                            : false,
                        gradient: storeController.openingAndClosingDays.isEmpty
                            ? null
                            : storeController.openingAndClosingDays.contains(
                                storeController.days[index],
                              )
                            ? null
                            : Appcolors.logoColork,
                        color: Appcolors.appPriSecColor.appPrimblue.withOpacity(
                          0.2,
                        ),
                        textStyle: poppinsFont(
                          10,
                          storeController.openingAndClosingDays.isEmpty
                              ? themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white
                              : storeController.openingAndClosingDays.contains(
                                  storeController.days[index],
                                )
                              ? themeContro.isLightMode.value
                                    ? Appcolors.black
                                    : Appcolors.white
                              : Appcolors.white,
                          FontWeight.w400,
                        ),
                        radius: 5,
                        horizontal: 7,
                        vertical: 4,
                      ).paddingOnly(right: 10),
                    );
                  },
                ),
              ),
              sizeBoxHeight(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppAsstes.infoCircle,
                    height: getProportionateScreenHeight(15),
                    width: getProportionateScreenWidth(15),
                  ),
                  sizeBoxWidth(9),
                  Expanded(
                    child: label(
                      languageController.textTranslate(
                        'Select the multiple days you want to provide the service to the users',
                      ),
                      fontSize: 8,
                      maxLines: 2,
                      textColor: Appcolors.colorB0B0B0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              sizeBoxHeight(20),
              Container(
                height: 30,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Closed",
                      style: AppTypography.text8Medium(context).copyWith(
                        fontSize: 10,
                        color: themeContro.isLightMode.value
                            ? Appcolors.appTextColor.textBlack
                            : Appcolors.appTextColor.textWhite,
                      ),
                    ),
                    sizeBoxWidth(8),
                    Image.asset(
                      AppAsstes.close,
                      height: getProportionateScreenHeight(16),
                      width: getProportionateScreenWidth(16),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 10),
              ),
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 15),
        ),
      ],
    );
  }

  //========================================================================== TOP PROGRESS BAR ====================================================================
  //========================================================================== TOP PROGRESS BAR ====================================================================
  //========================================================================== TOP PROGRESS BAR ====================================================================
  Widget progress() {
    return Container(
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Color(0xffEEF5FF)
            : Color(0xff1E242C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          sizeBoxHeight(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              prItem(
                image: AppAsstes.addshop,
                title: "Business Detail",
                index: 1,
              ),
              prItem(
                image: AppAsstes.addlocation,
                title: "Contact Details",
                index: 2,
              ),
              prItem(
                image: AppAsstes.addtime,
                title: "Business Time",
                index: 3,
              ),
            ],
          ).paddingSymmetric(horizontal: 65),
          sizeBoxHeight(10),
          prBar(index: currentIndex).paddingOnly(right: 22, left: 22),
          sizeBoxHeight(20),
        ],
      ),
    );
  }

  Widget prBar({required int index}) {
    bool isLtr = userTextDirection == "ltr";
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: index / 3),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                colors: [
                  Appcolors.prColor1,
                  Appcolors.appPriSecColor.appPrimblue,
                  Appcolors.appBgColor.white,
                ],
                stops: [value / 2, value, value],
                begin: isLtr ? Alignment.centerLeft : Alignment.centerRight,
                end: isLtr ? Alignment.centerRight : Alignment.centerLeft,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget prItem({
    required String image,
    required String title,
    required int index,
  }) {
    return Column(
      children: [
        Container(
          height: getProportionateScreenHeight(35),
          width: getProportionateScreenWidth(35),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index <= currentIndex
                ? Appcolors.appPriSecColor.appPrimblue
                : Appcolors.bluee4,
          ),
          child: Image.asset(image).paddingAll(7),
        ),
        sizeBoxHeight(7),
      ],
    );
  }
}

Widget socialUrlFormField({
  String? lable,
  String? lable2,
  required TextEditingController controller,
  required void Function()? onEditingComplete,
  void Function(String)? onChanged,
  required String hintText,
  required BuildContext context,
  bool isBackgroundWhite = false,
  bool isNumber = false,
  bool isOnlyRead = false,
  bool isForPhoneNumber = false,
  bool isLabel = false,
  FocusNode? focusNode,
  bool isEmail = false,
  bool isForProfile = false,
  String imagePath = '',
  int maxLines = 1,
  Widget? suffixIcon,
  Widget? preffixIcon,
  int? maxLength,
  EdgeInsetsGeometry? contentPadding,
  Color? focusedBorderColor,
  void Function()? onTap,
  String? Function(String?)? validator,
}) {
  // Function to check if a string is a valid URL
  final RegExp urlRegex = RegExp(r'^(https?:\/\/|www\.)');

  return Column(
    children: [
      twoText(
        text1: lable ?? "",
        text2: lable2 ?? "",
        style1: poppinsFont(
          10,
          themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
          FontWeight.w600,
        ),
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      (lable == null || lable == "")
          ? const SizedBox.shrink()
          : sizeBoxHeight(5),
      Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Appcolors.bluee4,
            cursorColor: Appcolors.bluee4,
            selectionColor: Appcolors.appPriSecColor.appPrimblue.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        child: TextFormField(
          controller: controller,
          onTap: onTap,
          textCapitalization: isEmail
              ? TextCapitalization.none
              : TextCapitalization.words,
          onEditingComplete: onEditingComplete,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: poppinsFont(
            14,
            urlRegex.hasMatch(controller.text)
                ? Appcolors.appPriSecColor.appPrimblue
                : themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
            FontWeight.normal,
          ),
          focusNode: focusNode,
          maxLength: maxLength,
          onChanged: onChanged,
          readOnly: isOnlyRead,
          maxLines: maxLines == 1 ? 1 : maxLines,
          keyboardType: isNumber
              ? TextInputType.number
              : TextInputType.emailAddress,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: preffixIcon,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            fillColor: themeContro.isLightMode.value
                ? Appcolors.appBgColor.transparent
                : Appcolors.darkGray,
            filled: true,
            hintText: hintText,
            hintStyle: poppinsFont(12, Appcolors.colorB0B0B0, FontWeight.w400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: focusedBorderColor ?? Appcolors.bluee4,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: themeContro.isLightMode.value
                    ? Appcolors.appStrokColor.cF0F0F0
                    : Appcolors.grey1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Appcolors.appTextColor.textRedColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Appcolors.appTextColor.textRedColor,
              ),
            ),
            errorStyle: poppinsFont(
              12,
              Appcolors.appTextColor.textRedColor,
              FontWeight.normal,
            ),
            labelText: isLabel ? hintText : null,
            counterStyle: poppinsFont(
              0,
              Appcolors.appExtraColor.cB4B4B4,
              FontWeight.normal,
            ),
            labelStyle: poppinsFont(12, Appcolors.colorB0B0B0, FontWeight.w400),
          ),
          validator: validator,
        ),
      ),
    ],
  );
}
