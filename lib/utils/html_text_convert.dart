// ignore_for_file: depend_on_referenced_packages

import 'package:nlytical/auth/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:nlytical/utils/colors.dart';

class HtmlReadMoreView extends StatefulWidget {
  final String htmlData;
  final int trimLines;
  final Color textColor;

  const HtmlReadMoreView({
    super.key,
    required this.htmlData,
    this.trimLines = 5,
    required this.textColor,
  });

  @override
  State<HtmlReadMoreView> createState() => _HtmlReadMoreViewState();
}

class _HtmlReadMoreViewState extends State<HtmlReadMoreView> {
  bool _isExpanded = false;

  String _parseHtmlToPlainText(String html) {
    final document = html_parser.parse(html);
    return document.body?.text ?? '';
  }

  bool _shouldTrim(String text) {
    const int approxCharsPerLine = 80;
    int estimatedLines = (text.length / approxCharsPerLine).ceil();
    return estimatedLines > widget.trimLines;
  }

  @override
  Widget build(BuildContext context) {
    final cleanedHtml = cleanHtmlText(widget.htmlData);
    final plainText = _parseHtmlToPlainText(cleanedHtml);
    final shouldTrim = _shouldTrim(plainText);

    // Create separate Html widgets for trimmed and full views
    final trimmedHtmlWidget = Html(
      shrinkWrap: true,
      data: cleanedHtml,
      style: {
        "body": Style(
          color: themeContro.isLightMode.value
              ? Appcolors.appTextColor.textBlack
              : Appcolors.appTextColor.textWhite,
          fontSize: FontSize(14),
        ),
      },
    );

    final fullHtmlWidget = Html(
      shrinkWrap: true,
      data: cleanedHtml,
      style: {
        "body": Style(
          color: themeContro.isLightMode.value
              ? Appcolors.appTextColor.textBlack
              : Appcolors.appTextColor.textWhite,
          fontSize: FontSize(14),
        ),
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: shouldTrim
              ? ClipRect(
                  child: SizedBox(
                    height: 3 * 20.0,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: trimmedHtmlWidget,
                    ),
                  ),
                )
              : fullHtmlWidget,
          secondChild: fullHtmlWidget,
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        if (shouldTrim)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                _isExpanded ? 'Show less' : 'Read more',
                style: TextStyle(
                  color: Appcolors.appPriSecColor.appPrimblue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String cleanHtmlText(String html) {
  return html
      // Remove empty paragraph tags like <p><br></p>
      .replaceAll(RegExp(r'<p>\s*(<br\s*/>)?\s*</p>', caseSensitive: false), '')
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
