// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';

class BusinessSocialLink extends StatefulWidget {
  const BusinessSocialLink({super.key});

  @override
  State<BusinessSocialLink> createState() => _BusinessSocialLinkState();
}

class _BusinessSocialLinkState extends State<BusinessSocialLink> {
  StoreController storeController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final whpLinkController = TextEditingController();
  final faceBookLinkController = TextEditingController();
  final instaLinkController = TextEditingController();
  final twitterLinkController = TextEditingController();

  FocusNode whpFocus = FocusNode();
  FocusNode whpFocus1 = FocusNode();

  FocusNode fcFocus = FocusNode();
  FocusNode fcFocus1 = FocusNode();

  FocusNode instaFocus = FocusNode();
  FocusNode instaFocus1 = FocusNode();

  FocusNode twiFocus = FocusNode();
  FocusNode twiFocus1 = FocusNode();

  bool whpvalue = false;
  bool fcvalue = false;
  bool instavalue = false;
  bool twvalue = false;

  @override
  void initState() {
    whpLinkController.text = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].contactDetails!.whatsappLink ?? ''
        : '';
    faceBookLinkController.text = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].contactDetails!.facebookLink ?? ''
        : '';
    instaLinkController.text = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].contactDetails!.instagramLink ?? ''
        : '';
    twitterLinkController.text = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].contactDetails!.twitterLink ?? ''
        : '';

    boolData();
    super.initState();
  }

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
      r'^(https?:\/\/)?(wa\.me|api\.whatsapp\.com)\/[0-9]+\/?(\?.*)?$',
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

  // https://www.instagram.com/elenzadelooksalon?gsh=dzYwdmZ3NXF2Z2h2
  // https://wa.me/919876543210
  //https://wa.me/1234567890?text=hello
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Follow on Social Media"),
            style: poppinsFont(20, Appcolors.white, FontWeight.w500),
          ),
          flexibleSpace: flexibleSpace(),
          backgroundColor: Appcolors.appBgColor.transparent,
          shadowColor: Appcolors.appBgColor.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Form(
          key: _formKey,
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
                      " ${languageController.textTranslate("Please provide the URL of your business website so customers can reach you.")}",
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
              sizeBoxHeight(30),
              label(
                languageController.textTranslate("Follow Us on"),
                style: poppinsFont(
                  11,
                  themeContro.isLightMode.value
                      ? Appcolors.black
                      : Appcolors.white,
                  FontWeight.w600,
                ),
              ),
              sizeBoxHeight(10),
              followeUSOnWidget(),
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
                    if (_formKey.currentState!.validate()) {
                      if (whpLinkController.text.trim().isEmpty &&
                          faceBookLinkController.text.trim().isEmpty &&
                          instaLinkController.text.trim().isEmpty &&
                          twitterLinkController.text.trim().isEmpty) {
                        snackBar(
                          languageController.textTranslate(
                            "Please add your social meadia link",
                          ),
                        );
                      } else {
                        storeController.storeSocialUpdateApi(
                          whp: whpLinkController.text,
                          fc: faceBookLinkController.text,
                          insta: instaLinkController.text,
                          twitter: twitterLinkController.text,
                        );
                      }
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

  Widget followeUSOnWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: themeContro.isLightMode.value
              ? Appcolors.grey200
              : Appcolors.grey1,
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
            isOnlyRead: isDemo == "false" ? false : true,
            onTap: () {
              if (isDemo == "true") {
                snackBar("This is for demo, We can not allow to edit");
              }
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
            isOnlyRead: isDemo == "false" ? false : true,
            onTap: () {
              if (isDemo == "true") {
                snackBar("This is for demo, We can not allow to edit");
              }
            },
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
            isOnlyRead: isDemo == "false" ? false : true,
            onTap: () {
              if (isDemo == "true") {
                snackBar("This is for demo, We can not allow to edit");
              }
            },
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
            isOnlyRead: isDemo == "false" ? false : true,
            onTap: () {
              if (isDemo == "true") {
                snackBar("This is for demo, We can not allow to edit");
              }
            },
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
