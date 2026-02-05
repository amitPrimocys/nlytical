import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/flexible_space.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class PrivacyWebView extends StatefulWidget {
  final String htmlContent; // Accept HTML content
  final String title;

  const PrivacyWebView({
    super.key,
    required this.htmlContent,
    required this.title,
  });

  @override
  State<PrivacyWebView> createState() => _PrivacyWebViewState();
}

class _PrivacyWebViewState extends State<PrivacyWebView> {
  String cleanHtmlText(String html) {
    return html
        // Remove empty paragraph tags like <p><br></p>
        .replaceAll(
          RegExp(r'<p>\s*(<br\s*/>)?\s*</p>', caseSensitive: false),
          '',
        )
        // Remove <br> tags, including Apple-specific ones
        .replaceAll(
          RegExp(r'<br\s*(class="[^"]*")?\s*/>', caseSensitive: false),
          '',
        )
        // Remove inline style attributes like style="color: red;"
        .replaceAll(RegExp(r'style="[^"]*"', caseSensitive: false), '')
        // Remove multiple spaces, tabs, and newlines
        .replaceAll(RegExp(r'\s+'), ' ')
        // Remove common HTML entities like &nbsp;
        .replaceAll(RegExp(r'&nbsp;| '), ' ')
        // Remove leading/trailing whitespace
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContro.isLightMode.value
          ? Appcolors.appBgColor.white
          : Appcolors.darkMainBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: customeBackArrow().paddingAll(15),
          centerTitle: true,
          title: Text(
            languageController.textTranslate(widget.title),
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
                    Html(
                      data: cleanHtmlText(widget.htmlContent),
                      onLinkTap: (url, attributes, element) {},
                      shrinkWrap: true,
                      style: {
                        "body": Style(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                          fontFamily: "Poppins",
                        ),
                        "div": Style(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                          fontFamily: "Poppins",
                        ),
                        "p": Style(
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                          fontFamily: "Poppins",
                        ),
                        "h1": Style(
                          fontWeight: FontWeight.bold,
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                          fontFamily: "Poppins",
                        ),
                        "sup": Style(
                          fontSize: FontSize.small,
                          color: themeContro.isLightMode.value
                              ? Appcolors.appTextColor.textBlack
                              : Appcolors.appTextColor.textWhite,
                          fontFamily: "Poppins",
                        ),
                      },
                    ),
                    sizeBoxHeight(20),
                  ],
                ).paddingSymmetric(horizontal: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
