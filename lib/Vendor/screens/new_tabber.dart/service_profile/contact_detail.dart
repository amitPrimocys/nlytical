// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/vendor_controllers/store_controller.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';

class ContactDetail extends StatefulWidget {
  const ContactDetail({super.key});

  @override
  State<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  StoreController storeController = Get.find();
  final businessPhoneController = TextEditingController();
  final businessEmailController = TextEditingController();

  final phone = FocusNode();
  final phone1 = FocusNode();
  final email = FocusNode();
  final email1 = FocusNode();
  String phoneNumber = '';

  @override
  void initState() {
    contrycode = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].contactDetails!.serviceCountryCode ??
              "+91"
        : "+91";
    businessPhoneController.text = getMobile(
      storeController.storeList.isNotEmpty
          ? storeController.storeList[0].contactDetails!.servicePhone ?? ''
          : '',
    );
    businessEmailController.text = storeController.storeList.isNotEmpty
        ? storeController.storeList[0].contactDetails!.serviceEmail ?? ''
        : '';
    (contrycode);
    (storeController.storeList[0].contactDetails!.servicePhone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.appBgColor.darkMainBlack,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: appbarTitle(
            context,
            title: languageController.textTranslate("Contact Details"),
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
              businessTitle(
                context,
                title: languageController.textTranslate("Contact Detail"),
              ),
              sizeBoxHeight(10),
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
                    child: businessSubTitle(
                      context,
                      title:
                          " ${languageController.textTranslate("Update your contact details to stay in touch your customers in real time")}",
                    ),
                  ),
                ],
              ),
              sizeBoxHeight(30),
              twoText(
                fontWeight: FontWeight.w600,
                text1: languageController.textTranslate("Mobile Number"),
                text2: " *",
                mainAxisAlignment: MainAxisAlignment.start,
                style1: AppTypography.outerMedium(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              sizeBoxHeight(7),
              IntlPhoneField(
                textAlign: userTextDirection == "ltr"
                    ? TextAlign.left
                    : TextAlign.right,
                initialValue: contrycode,
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
                  phoneNumber = number.number; // Extract only the phone number
                },
                focusNode: phone1,
                cursorColor: themeContro.isLightMode.value
                    ? Appcolors.bluee4
                    : Appcolors.white,
                autofocus: false,
                enabled: isDemo == "false" ? true : false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: AppTypography.text11Regular(context).copyWith(
                  color: themeContro.isLightMode.value
                      ? Appcolors.appTextColor.textBlack
                      : Appcolors.appTextColor.textWhite,
                ),
                controller: businessPhoneController,
                keyboardType: TextInputType.number,
                invalidNumberMessage: languageController.textTranslate(
                  "Invalid Mobile Number",
                ),
                readOnly: isDemo == "false" ? false : true,
                onTap: () {
                  if (isDemo == "true") {
                    snackBar("This is for demo, We can not allow to edit");
                  }
                },
                flagsButtonPadding: const EdgeInsets.only(left: 5),
                decoration: InputDecoration(
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
                      color: Appcolors.appStrokColor.cF0F0F0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Appcolors.appStrokColor.cF0F0F0,
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
                      color: Appcolors.appStrokColor.cF0F0F0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Appcolors.appStrokColor.cF0F0F0,
                    ),
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
                controller: businessEmailController,
                onEditingComplete: () {
                  Focus.of(context).requestFocus(email);
                },
                isOnlyRead: isDemo == "false" ? false : true,
                onTap: () {
                  if (isDemo == "true") {
                    snackBar("This is for demo, We can not allow to edit");
                  }
                },
                focusNode: email1,
                hintText: languageController.textTranslate("Email Address"),
                context: context,
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
            : Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  left: 60,
                  right: 60,
                ),
                child: customBtn(
                  onTap: () {
                    if (isDemo == "false") {
                      if (businessPhoneController.text.trim().isEmpty) {
                        snackBar(
                          languageController.textTranslate(
                            "Please add your business phone number",
                          ),
                        );
                      } else if (businessEmailController.text.trim().isEmpty) {
                        snackBar(
                          languageController.textTranslate(
                            "Please add your business email",
                          ),
                        );
                      } else {
                        storeController.storeCotactUpdateApi(
                          countryCode: contrycode,
                          storePhone: contrycode + businessPhoneController.text,
                          storeEmail: businessEmailController.text,
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
                ),
              );
      }),
    );
  }
}
