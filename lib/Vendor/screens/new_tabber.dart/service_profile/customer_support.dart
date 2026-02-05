import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/controllers/vendor_controllers/support_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({super.key});

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  SupportController supportcontro = Get.find();

  final fnameController = TextEditingController();
  final msgController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();
  FocusNode fnameFocus = FocusNode();
  FocusNode fnameFocus1 = FocusNode();
  FocusNode numberFocus = FocusNode();
  FocusNode numberFocus1 = FocusNode();
  FocusNode msgFocus = FocusNode();
  FocusNode msgFocus1 = FocusNode();

  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();

  @override
  void initState() {
    fnameController.text = "$userFirstName $userLastName";
    emailController.text = userEmail;

    super.initState();
  }

  Future<void> getData() async {
    contrycode = (await SecurePrefs.getString(
      SecureStorageKeys.COUINTRY_CODE,
    ))!;
    phoneController.text = getMobile(
      (await SecurePrefs.getString(SecureStorageKeys.USER_MOBILE))!,
    );
  }

  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate("Customer Support"),
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
        child: SingleChildScrollView(
          child: Form(
            key: _keyform,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sizeBoxHeight(30),
                globalTextField(
                  lable2: " *",
                  lable: languageController.textTranslate("Name"),
                  controller: fnameController,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(fnameFocus);
                  },
                  isEmail: false,
                  isNumber: false,
                  focusNode: fnameFocus1,
                  hintText: languageController.textTranslate("Name"),
                  context: context,
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(20),
                globalTextField(
                  lable2: " *",
                  isOnlyRead: emailController.text.trim().isNotEmpty
                      ? true
                      : false,
                  lable: languageController.textTranslate("Email"),
                  controller: emailController,
                  isEmail: true,
                  onEditingComplete: () {
                    FocusScope.of(
                      context,
                    ).requestFocus(signUpPasswordFocusNode);
                  },
                  focusNode: signUpEmailIDFocusNode,
                  hintText: languageController.textTranslate("Email"),
                  context: context,
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(20),
                twoText(
                  text1: languageController.textTranslate('Phone'),
                  text2: " *",
                  style1: AppTypography.outerMedium(context).copyWith(
                    color: themeContro.isLightMode.value
                        ? Appcolors.appTextColor.textBlack
                        : Appcolors.appTextColor.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                  style2: poppinsFont(
                    11,
                    Appcolors.appTextColor.textRedColor,
                    FontWeight.w600,
                  ),
                  mainAxisAlignment: MainAxisAlignment.start,
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(4),
                IntlPhoneField(
                  textAlign: userTextDirection == "ltr"
                      ? TextAlign.left
                      : TextAlign.right,
                  initialValue: contrycode,
                  readOnly: false,
                  showCountryFlag: true,
                  showDropdownIcon: false,
                  dropdownTextStyle: AppTypography.text11Regular(context)
                      .copyWith(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appTextColor.textBlack
                            : Appcolors.appTextColor.textWhite,
                      ),
                  onCountryChanged: (value) {
                    contrycode = '+${value.dialCode}';
                  },
                  onChanged: (number) {
                    phoneNumber = number.number;
                  },
                  focusNode: numberFocus,
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
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  invalidNumberMessage: languageController.textTranslate(
                    "Invalid Mobile Number",
                  ),
                  flagsButtonPadding: const EdgeInsets.only(left: 5),
                  decoration: InputDecoration(
                    enabled: true,
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
                            : Appcolors.grey1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appStrokColor.cF0F0F0
                            : Appcolors.grey1,
                      ),
                    ),
                    hintText: languageController.textTranslate(
                      "Add Mobile Number",
                    ),
                    hintStyle: AppTypography.text11Regular(
                      context,
                    ).copyWith(color: Appcolors.appTextColor.textLighGray),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appStrokColor.cF0F0F0
                            : Appcolors.grey1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeContro.isLightMode.value
                            ? Appcolors.appStrokColor.cF0F0F0
                            : Appcolors.grey1,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Appcolors.appTextColor.textRedColor,
                      fontSize: 10,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(20),
                globalTextField(
                  lable2: " *",
                  lable: languageController.textTranslate("Message"),
                  controller: msgController,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(msgFocus);
                  },
                  isEmail: false,
                  isNumber: false,
                  focusNode: msgFocus1,
                  maxLines: 5,
                  hintText: languageController.textTranslate("Write Message"),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  context: context,
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(20),
                customtext(),
                sizeBoxHeight(20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return supportcontro.isLoading1.value
            ? SizedBox(
                height: 50,
                width: 50,
                child: Center(child: commonLoading()),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 20,
                right: 20,
              )
            : GestureDetector(
                onTap: () {
                  if (_keyform.currentState!.validate()) {
                    if (phoneController.text.isEmpty) {
                      snackBar("Please enter your mobile number");
                    } else if (isTermsPrivacy == false) {
                      snackBar("Please accept the terms before proceeding.");
                    } else {
                      supportcontro.customersupportApi(
                        name: fnameController.text,
                        email: emailController.text,
                        phone: contrycode + phoneController.text,
                        message: msgController.text,
                      );
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Appcolors.appPriSecColor.appPrimblue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AppAsstes.message3, scale: 4),
                      sizeBoxWidth(7),
                      label(
                        languageController.textTranslate('Send Message'),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        textColor: Appcolors.white,
                      ),
                    ],
                  ),
                ),
              ).paddingOnly(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 60,
                right: 60,
              );
      }),
    );
  }

  bool isTermsPrivacy = false;

  Widget customtext() {
    return InkWell(
      onTap: () {
        setState(() {
          isTermsPrivacy = !isTermsPrivacy;
        });
      },
      splashColor: Appcolors.appBgColor.transparent,
      highlightColor: Appcolors.appBgColor.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: isTermsPrivacy
                  ? Appcolors.appPriSecColor.appPrimblue
                  : Appcolors.appBgColor.transparent,
              borderRadius: BorderRadius.circular(3),
              border: isTermsPrivacy
                  ? null
                  : Border.all(color: Appcolors.greyColor),
            ),
            child: isTermsPrivacy
                ? Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: Appcolors.white,
                      size: 15,
                    ),
                  )
                : Container(),
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              languageController.textTranslate(
                "I Agree that this app will store my submitted information so that they can respond to my request.",
              ),
              style: bostonFont(
                12,
                themeContro.isLightMode.value
                    ? Appcolors.black
                    : Appcolors.white,
                FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 20);
  }
}
