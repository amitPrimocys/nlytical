import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/address.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_category.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_images.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_name.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_social_link.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_website.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/business_years.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/contact_detail.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/store_employee.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/service_profile/store_time.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/global_fonts.dart';

class EditServiceProfile extends StatefulWidget {
  const EditServiceProfile({super.key});

  @override
  State<EditServiceProfile> createState() => _EditServiceProfileState();
}

class _EditServiceProfileState extends State<EditServiceProfile> {
  StoreController storeController = Get.find();

  @override
  void initState() {
    if (storeController.storeList.isNotEmpty) {
      storeController.caategoryName.value =
          storeController.categoryData.value.data?.firstWhere((element) {
            return element.id.toString() ==
                storeController.storeList[0].businessDetails!.categoryId!
                    .toString();
          }).categoryName ??
          '';
    }
    super.initState();
  }

  int _getMonthNumber(String month) {
    const Map<String, int> monthMapping = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    return monthMapping[month] ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    String publishedYearString = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].businessTime!.publishedYear ?? ''
        : '';
    String publishedMonthString = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].businessTime!.publishedMonth ?? ''
        : '';

    // Parse the year
    int publishedYear = int.tryParse(publishedYearString) ?? 0;

    // Convert the month name to a DateTime-compatible integer (1-12)
    int publishedMonth = _getMonthNumber(publishedMonthString);

    // Create a DateTime object for the published year and month
    DateTime publishedDate = DateTime(publishedYear, publishedMonth);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference
    int totalMonths =
        (currentDate.year - publishedDate.year) * 12 +
        (currentDate.month - publishedDate.month);
    int years = totalMonths ~/ 12;
    int months = totalMonths % 12;

    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.appBgColor.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Business"),
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
            sizeBoxHeight(10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    sizeBoxHeight(30),
                    businessContainer(
                      onTap: () {
                        Get.to(() => const BusinessNameScreen())!.then((_) {
                          setState(() {
                            storeController.storeDetailModel.refresh();
                            storeController.storeList.refresh();
                          });
                        });
                      },
                      img: AppAsstes.handshake,
                      imgheight: 20,
                      title: languageController.textTranslate("Business Name"),
                      subTitle: storeController.storeList.isNotEmpty
                          ? storeController
                                    .storeList[0]
                                    .businessDetails!
                                    .serviceName ??
                                ""
                          : "No any business added",
                    ).paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    //============= contact detail =====================
                    contacContainer().paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    //============= address detail =====================
                    businessContainer(
                      onTap: () {
                        Get.to(() => const AddressScreen())!.then((_) {
                          setState(() {
                            storeController.storeDetailModel.refresh();
                            storeController.storeList.refresh();
                          });
                        });
                      },
                      img: AppAsstes.contract,
                      imgheight: 20,
                      title: languageController.textTranslate(
                        "Business Address",
                      ),
                      subTitle: storeController.storeList.isNotEmpty
                          ? storeController
                                    .storeList[0]
                                    .contactDetails!
                                    .address ??
                                ''
                          : 'No any business added',
                    ).paddingSymmetric(horizontal: 17),
                    // addressContainer().paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    businessContainer(
                      onTap: () {
                        Get.to(() => const StoreTimeScreen())!.then((_) {
                          setState(() {
                            storeController.storeDetailModel.refresh();
                            storeController.storeList.refresh();
                          });
                        });
                      },
                      img: AppAsstes.time,
                      imgheight: 20,
                      title: languageController.textTranslate(
                        "Business Timings",
                      ),
                      subTitle: languageController.textTranslate("Open Now"),
                    ).paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    businessContainer(
                      onTap: () {
                        Get.to(() => const BusinessYears())!.then((_) {
                          setState(() {
                            storeController.storeDetailModel.refresh();
                            storeController.storeList.refresh();
                          });
                        });
                      },
                      img: AppAsstes.barchart,
                      imgheight: 20,
                      title: languageController.textTranslate(
                        "Year of Establishment",
                      ),
                      subTitle:
                          "$years ${languageController.textTranslate("Year")} $months ${languageController.textTranslate("Month")}",
                    ).paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    businessContainer(
                      onTap: () {
                        Get.to(() => const BusinessCategory())!.then((_) {
                          setState(() {
                            storeController.storeDetailModel.refresh();
                            storeController.storeList.refresh();
                            if (storeController.storeList.isNotEmpty) {
                              storeController.caategoryName.value =
                                  storeController.categoryData.value.data
                                      ?.firstWhere((element) {
                                        return element.id.toString() ==
                                            storeController
                                                .storeList[0]
                                                .businessDetails!
                                                .categoryId!
                                                .toString();
                                      })
                                      .categoryName ??
                                  '';
                            }
                          });
                        });
                      },
                      img: AppAsstes.networking,
                      imgheight: 20,
                      title: languageController.textTranslate(
                        "Business categories",
                      ),
                      subTitle: storeController.caategoryName.value,
                    ).paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    businessContainer(
                      onTap: () {
                        Get.to(() => const StoreEmployee())!.then((_) {
                          setState(() {
                            storeController.storeDetailModel.refresh();
                            storeController.storeList.refresh();
                          });
                        });
                      },
                      img: AppAsstes.emp1,
                      imgheight: 20,
                      title: languageController.textTranslate(
                        "Number of Employees",
                      ),
                      subTitle: storeController.storeList.isNotEmpty
                          ? "${storeController.storeList[0].businessTime!.employeeStrength ?? ''} ${languageController.textTranslate("Employees")}"
                          : "0 Employees",
                    ).paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    // business service images
                    businessImage().paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    businessContainer(
                      onTap: () {
                        Get.to(() => const BusinessWebsite())!.then((_) {
                          setState(() {
                            storeController.storeDetailModel.refresh();
                            storeController.storeList.refresh();
                          });
                        });
                      },
                      img: AppAsstes.worldwide,
                      imgheight: 20,
                      title: languageController.textTranslate(
                        "Business Website",
                      ),
                      subTitle: storeController.storeList.isNotEmpty
                          ? storeController
                                    .storeList[0]
                                    .contactDetails!
                                    .serviceWebsite!
                                    .isNotEmpty
                                ? storeController
                                      .storeList[0]
                                      .contactDetails!
                                      .serviceWebsite
                                      .toString()
                                : 'Add your bussiness website'
                          : '',
                    ).paddingSymmetric(horizontal: 17),
                    sizeBoxHeight(20),
                    businessFollowSocialMedia().paddingSymmetric(
                      horizontal: 17,
                    ),
                    sizeBoxHeight(100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget businessContainer({
    required Function() onTap,
    required String img,
    required double imgheight,
    required String title,
    required String subTitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeContro.isLightMode.value
              ? Appcolors.appBgColor.white
              : Appcolors.appBgColor.darkGray,
          boxShadow: [
            BoxShadow(
              blurRadius: 14.4,
              offset: Offset(2, 4),
              spreadRadius: 0,
              color: Appcolors.black.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(img, height: imgheight),
                sizeBoxWidth(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    sizeBoxHeight(10),
                    SizedBox(
                      width: getProportionateScreenWidth(270),
                      child: Text(
                        subTitle,
                        maxLines: 2,
                        style: AppTypography.text12Medium(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: Appcolors.appTextColor.textLighGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Image.asset(
              userTextDirection == "ltr"
                  ? "assets/images/arrow-left (1).png"
                  : 'assets/images/arrow-left1.png',
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              height: 18,
            ),
          ],
        ).paddingSymmetric(horizontal: 17, vertical: 12),
      ),
    );
  }

  //==================================================== BUSINESS IMAGE ===========================================================================
  //==================================================== BUSINESS IMAGE ===========================================================================
  //==================================================== BUSINESS IMAGE ===========================================================================
  Widget businessFollowSocialMedia() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const BusinessSocialLink());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          boxShadow: const [
            BoxShadow(
              blurRadius: 14.4,
              offset: Offset(2, 4),
              spreadRadius: 0,
              color: Color.fromRGBO(0, 0, 0, 0.06),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(AppAsstes.computer, height: 20),
                sizeBoxWidth(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageController.textTranslate(
                        "Follow on Social Media",
                      ),
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    sizeBoxHeight(10),
                    SizedBox(
                      width: getProportionateScreenWidth(270),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            followContainer(
                              img: AppAsstes.whatsapp,
                              title: 'What’s app',
                              borderColor:
                                  storeController
                                      .storeList[0]
                                      .contactDetails!
                                      .whatsappLink!
                                      .isNotEmpty
                                  ? Appcolors.appPriSecColor.appPrimblue
                                  : Appcolors.appTextColor.textLighGray,
                            ),
                            sizeBoxWidth(5),
                            followContainer(
                              img: AppAsstes.Facebook,
                              title: 'Facebook',
                              borderColor:
                                  storeController
                                      .storeList[0]
                                      .contactDetails!
                                      .facebookLink!
                                      .isNotEmpty
                                  ? Appcolors.appPriSecColor.appPrimblue
                                  : Appcolors.appTextColor.textLighGray,
                            ),
                            sizeBoxWidth(5),
                            followContainer(
                              img: AppAsstes.instagram,
                              title: 'Instagram',
                              borderColor:
                                  storeController
                                      .storeList[0]
                                      .contactDetails!
                                      .instagramLink!
                                      .isNotEmpty
                                  ? Appcolors.appPriSecColor.appPrimblue
                                  : Appcolors.appTextColor.textLighGray,
                            ),
                            sizeBoxWidth(5),
                            followContainer(
                              img: AppAsstes.twitter,
                              title: 'Twitter',
                              borderColor:
                                  storeController
                                      .storeList[0]
                                      .contactDetails!
                                      .twitterLink!
                                      .isNotEmpty
                                  ? Appcolors.appPriSecColor.appPrimblue
                                  : Appcolors.appTextColor.textLighGray,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Image.asset(
              userTextDirection == "ltr"
                  ? "assets/images/arrow-left (1).png"
                  : 'assets/images/arrow-left1.png',
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              height: 18,
            ),
          ],
        ).paddingSymmetric(horizontal: 17, vertical: 12),
      ),
    );
  }

  Widget followContainer({
    required String img,
    required String title,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeContro.isLightMode.value
            ? Appcolors.white
            : Appcolors.appBgColor.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Image.asset(img, height: 16),
          sizeBoxWidth(5),
          Text(
            title,
            style: AppTypography.text8Medium(
              context,
            ).copyWith(color: borderColor),
          ),
        ],
      ).paddingAll(5),
    );
  }

  //======================================================= IMAGES ==============================================================
  Widget businessImage() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const BusinessImages())!.then((_) {
          setState(() {
            storeController.storeDetailModel.refresh();
            storeController.storeList.refresh();
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          boxShadow: const [
            BoxShadow(
              blurRadius: 14.4,
              offset: Offset(2, 4),
              spreadRadius: 0,
              color: Color.fromRGBO(0, 0, 0, 0.06),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(AppAsstes.computer1, height: 20),
                sizeBoxWidth(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageController.textTranslate("Business Images"),
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    sizeBoxHeight(10),
                    SizedBox(
                      height: getProportionateScreenHeight(50),
                      width: getProportionateScreenWidth(270),
                      child: storeController.storeList.isNotEmpty
                          ? ListView.builder(
                              itemCount: storeController
                                  .storeList[0]
                                  .businessDetails!
                                  .serviceImages!
                                  .length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: getProportionateScreenHeight(48),
                                  width: getProportionateScreenWidth(48),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Appcolors.appShadowColor.cECECEC,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      storeController
                                          .storeList[0]
                                          .businessDetails!
                                          .serviceImages![index]
                                          .url
                                          .toString(),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error, size: 20),
                                    ),
                                  ),
                                ).paddingOnly(right: 10);
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
            Image.asset(
              userTextDirection == "ltr"
                  ? "assets/images/arrow-left (1).png"
                  : 'assets/images/arrow-left1.png',
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              height: 18,
            ),
          ],
        ).paddingSymmetric(horizontal: 17, vertical: 12),
      ),
    );
  }

  //================================================ CONTACT DETAILS ====================================================================
  Widget contacContainer() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ContactDetail())!.then((_) {
          setState(() {
            storeController.storeDetailModel.refresh();
            storeController.storeList.refresh();
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkGray,
          boxShadow: const [
            BoxShadow(
              blurRadius: 14.4,
              offset: Offset(2, 4),
              spreadRadius: 0,
              color: Color.fromRGBO(0, 0, 0, 0.06),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(AppAsstes.phonecall, height: 20),
                sizeBoxWidth(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageController.textTranslate("Contact Details"),
                      style: AppTypography.text14Medium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    sizeBoxHeight(10),
                    Text(
                      storeController.storeList.isNotEmpty
                          ? storeController
                                    .storeList[0]
                                    .contactDetails!
                                    .servicePhone ??
                                ''
                          : 'No any business contact added',
                      style: AppTypography.text12Medium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: Appcolors.appTextColor.textLighGray,
                      ),
                    ),
                    sizeBoxHeight(10),
                    SizedBox(
                      width: getProportionateScreenWidth(260),
                      child: Text(
                        storeController.storeList.isNotEmpty
                            ? storeController
                                      .storeList[0]
                                      .contactDetails!
                                      .serviceEmail ??
                                  ''
                            : '',
                        maxLines: 2,
                        style: AppTypography.text12Medium(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: Appcolors.appTextColor.textLighGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Image.asset(
              userTextDirection == "ltr"
                  ? "assets/images/arrow-left (1).png"
                  : 'assets/images/arrow-left1.png',
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
              height: 18,
            ),
          ],
        ).paddingSymmetric(horizontal: 17, vertical: 12),
      ),
    );
  }
}
