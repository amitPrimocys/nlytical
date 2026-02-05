// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/comman_widgets.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

Widget globalTextField({
  String? lable,
  String? lable2,
  required TextEditingController controller,
  required void Function()? onEditingComplete,
  void Function(String)? onChanged,
  required String hintText,
  required BuildContext context,
  isBackgroundWhite = false,
  FormFieldValidator? validator,
  isNumber = false,
  isOnlyRead = false,
  isForPhoneNumber = false,
  bool isLabel = false,
  FocusNode? focusNode,
  isEmail = false,
  bool isForProfile = false,
  String imagePath = '',
  int maxLines = 1,
  Widget? suffixIcon,
  Widget? preffixIcon,
  int? maxLength,
  EdgeInsetsGeometry? contentPadding,
  Color? focusedBorderColor,
  void Function()? onTap,
  bool? filled,
  Color? fillColor,
  List<TextInputFormatter>? inputFormatters,
  Key? key,
}) {
  return Column(
    children: [
      twoText(
        text1: lable ?? "",
        text2: lable2 ?? "",
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
      ),
      (lable == null || lable == "")
          ? const SizedBox.shrink()
          : sizeBoxHeight(5),
      Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Appcolors.appPriSecColor.appPrimblue,
            cursorColor: Appcolors.appPriSecColor.appPrimblue,
            selectionColor: Appcolors.appPriSecColor.appPrimblue.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        child: TextFormField(
          autocorrect: true,
          enableSuggestions: true,
          key: key,
          autofocus: false,
          controller: controller,
          inputFormatters: inputFormatters,
          onTap: onTap,
          textCapitalization: isEmail
              ? TextCapitalization.none
              : TextCapitalization.sentences,
          onEditingComplete: onEditingComplete,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTypography.text11Regular(context).copyWith(
            color: themeContro.isLightMode.value
                ? Appcolors.appTextColor.textBlack
                : Appcolors.appTextColor.textWhite,
          ),
          focusNode: focusNode,
          maxLength: maxLength,
          onFieldSubmitted: (value) {},
          onSaved: (newValue) {
            FocusScope.of(context).nextFocus();
          },

          onChanged: onChanged,
          readOnly: isOnlyRead,
          // minLines: 1,
          maxLines: maxLines == 1 ? 1 : maxLines,
          // null
          keyboardType: isNumber
              ? TextInputType.number
              : isEmail
              ? TextInputType.emailAddress
              : TextInputType.text,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: preffixIcon,

            // suffix: suffixIcon,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:
                      (hintText == "Comments" ||
                          hintText == "Address" ||
                          hintText == "Business Description" ||
                          hintText == "Business Address" ||
                          hintText == "Write Message" ||
                          hintText == "Service Description")
                      ? 12
                      : hintText == "Notes"
                      ? 14
                      : 0,
                ),
            fillColor: themeContro.isLightMode.value
                ? Appcolors.appBgColor.transparent
                : Appcolors.darkGray,
            filled: true,
            hintText: hintText,
            hintStyle: AppTypography.text11Regular(
              context,
            ).copyWith(color: Appcolors.appTextColor.textLighGray),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color:
                    focusedBorderColor ?? Appcolors.appPriSecColor.appPrimblue,
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
                color: themeContro.isLightMode.value
                    ? Appcolors.appStrokColor.cF0F0F0
                    : Appcolors.grey1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: themeContro.isLightMode.value
                    ? Appcolors.appStrokColor.cF0F0F0
                    : Appcolors.grey1,
              ),
            ),
            errorStyle: poppinsFont(
              12,
              Appcolors.appTextColor.textRedColor,
              FontWeight.normal,
            ),
            labelText: isLabel ? hintText : null,
            counterText: "",
            counterStyle: poppinsFont(
              0,
              Appcolors.appExtraColor.cB4B4B4,
              FontWeight.normal,
            ),
            labelStyle: poppinsFont(12, Appcolors.colorB0B0B0, FontWeight.w400),
          ),
          // validator: validator
          validator: (value) {
            switch (hintText) {
              case "Email Address":
                if (value == null || value.trim().isEmpty) {
                  return null;
                }
                if (!value.trim().isEmail) {
                  return "Please enter a valid email";
                }
                return null;

              case "Password":
                if (value == null || value.trim().isEmpty) {
                  return null;
                }
                return null;

              case "First Name":
                if (value == null || value.trim().isEmpty) {
                  return null;
                }
                return null;

              case "Last Name":
                if (value == null || value.trim().isEmpty) {
                  return null;
                }
                return null;

              default:
                return null;
            }
          },
        ),
      ),
    ],
  );
}
