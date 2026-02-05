// ignore_for_file: avoid_print

import 'package:nlytical/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/enums.dart';

class LanguagePopUp extends StatefulWidget {
  final UserType userType;
  const LanguagePopUp({super.key, required this.userType});

  @override
  State<LanguagePopUp> createState() => _LanguagePopUpState();
}

class _LanguagePopUpState extends State<LanguagePopUp> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: languageController.languagesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    (languageController.languagesList.length);
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        await SecurePrefs.setString(
                          SecureStorageKeys.lnId,
                          languageController.languagesList[index].statusId
                              .toString(),
                        );
                        await SecurePrefs.getMultipleAndSetGlobalsWithMap({
                          SecureStorageKeys.lnId: (v) => userLangID = v!,
                        });

                        await languageController.getLanguageTranslation(
                          lnId: languageController.languagesList[index].statusId
                              .toString(),
                        );
                        languageController.updateTextDirection();
                        languageController.languageTranslationsData.refresh();
                        if (widget.userType == UserType.isUser) {
                          roleController.isUserSelected();
                          Get.offAll(TabbarScreen(currentIndex: 0));
                        } else {
                          roleController.isVendorSelected();
                          Get.offAll(() => TabbarScreen(currentIndex: 0));
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Appcolors.appPriSecColor.appPrimblue,
                                width: 1.5,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(1.5),
                              decoration:
                                  languageController
                                          .languagesList[index]
                                          .language !=
                                      languageController
                                          .languageTranslationsData
                                          .value
                                          .language
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeContro.isLightMode.value
                                          ? Appcolors.white
                                          : Appcolors.darkMainBlack,
                                    )
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Appcolors.appPriSecColor.appPrimblue,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            languageController.languagesList[index].language!,
                            style: TextStyle(
                              fontSize: 16,
                              color: themeContro.isLightMode.value
                                  ? Appcolors.black
                                  : Appcolors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20, vertical: 20),
                    );
                  },
                ),
              ),
            ],
          ),
          if (languageController.isLanguagLoading.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
