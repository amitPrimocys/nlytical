// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';

class HtmlListWithIcons extends StatelessWidget {
  final String htmlData;

  const HtmlListWithIcons({super.key, required this.htmlData});

  List<String> extractParagraphs(String html) {
    final document = html_parser.parse(html);
    final paragraphs = document.getElementsByTagName('p');
    return paragraphs.map((e) => e.text.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = extractParagraphs(htmlData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: getProportionateScreenHeight(16),
              width: getProportionateScreenWidth(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Appcolors.appPriSecColor.appPrimblue,
              ),
              child: Center(
                child: Icon(Icons.check, size: 12, color: Appcolors.white),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(item, style: AppTypography.text11Regular(context)),
            ),
          ],
        ).paddingOnly(bottom: 10);
      }).toList(),
    );
  }
}
