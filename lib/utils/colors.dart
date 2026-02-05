// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

class Appcolors {
  static AppPriSecColor appPriSecColor = AppPriSecColor();
  static AppTextColor appTextColor = AppTextColor();
  static AppGradientColor appGradientColor = AppGradientColor();
  static AppStrokColor appStrokColor = AppStrokColor();
  static AppOppacityColor appOppaColor = AppOppacityColor();
  static AppBgColor appBgColor = AppBgColor();
  static AppShadowColor appShadowColor = AppShadowColor();
  static AppExtraColor appExtraColor = AppExtraColor();
  static AppChartColor appChartColor = AppChartColor();

  static const Color color53ABFD = Color(0xff53ABFD);
  static Color colorB0B0B0 = appTextColor.textLighGray;
  static Color bluee4 = appPriSecColor.appPrimblue.withValues(alpha: 0.13);
  static Color grey500 = appTextColor.textLighGray;
  static Color grey = Colors.grey;
  static Color black12 = appPriSecColor.appSecond.withValues(alpha: 0.10);

  static Color black26 = Colors.black26;
  static Color black87 = Colors.black87;
  static Color grey100 = Colors.grey.shade100;
  static Color grey200 = Colors.grey.shade200;
  static Color grey300 = Colors.grey.shade300;
  static Color grey400 = grey.withValues(alpha: 0.74);

  static const Color brown = Color.fromRGBO(113, 113, 113, 1);

  static const Color darkColor = Color.fromRGBO(28, 28, 28, 1);
  static const Color greyColor = Color.fromRGBO(133, 133, 133, 1);
  static const Color coloropcity = Color(0xffEFEFEF);
  static Color colorBABABA = appTextColor.textLighGray;
  static const Color prColor1 = Color(0xff001D48);
  static const Color grey1 = Color(0xff656565);
  static Color white10 = appBgColor.white.withValues(alpha: 0.10);
  static Color white12 = appBgColor.white.withValues(alpha: 0.12);
  static Color white24 = appBgColor.white.withValues(alpha: 0.24);
  static Color white = appBgColor.white;
  static Color black = appPriSecColor.appSecond;

  static LinearGradient logoColorWith60Opacity1 = const LinearGradient(
    colors: <Color>[Color(0xffE25B5B), Color(0xff0046AE)],
  );

  static LinearGradient logoColorWith60Opacityk = LinearGradient(
    colors: <Color>[
      Appcolors.appPriSecColor.appPrimblue.withValues(alpha: 0.6),
      Appcolors.appPriSecColor.appPrimblue.withValues(alpha: 0.6),
    ],
  );

  static LinearGradient logoColork = LinearGradient(
    colors: <Color>[
      Appcolors.appPriSecColor.appPrimblue,
      Appcolors.appPriSecColor.appPrimblue,
    ],
  );

  //===================== DARK MODE COLOR
  static const Color darkMainBlack = Color(0xff181818);
  static const Color darkGray = Color(0xff212121);
  static const Color darkBorder = Color(0xff373737);
  static const Color darkgray1 = Color.fromARGB(255, 41, 41, 41);
  static const Color darkgray2 = Color.fromARGB(255, 68, 67, 67);
  static const Color darkgray3 = Color.fromARGB(255, 152, 152, 152);
  static const Color darkblue = Color.fromRGBO(28, 45, 107, 0.13);
  static const Color darkShadowColor = Color(0xff0000000f);

  static const Color cD9D9D9 = Color(0xffD9D9D9);
}

//============================================================================================================================================================
//======================================================================== TYPOGRAPHY COLOR ==================================================================
//============================================================================================================================================================
class AppPriSecColor {
  Color appPrimblue = Color(0xff226FE4);
  Color appSecond = Colors.black;
  Color appSecondary = Color(0xffD0D0D0);
}

class AppTextColor {
  Color textBlack = Colors.black;
  Color textDarkGrey = Color(0xff212121);
  Color textWhite = Colors.white;
  Color textLighGray = Color(0xffB4B4B4);
  Color textRedColor = Color(0xffFF2525);
  Color textRedAccent = Color.fromRGBO(255, 82, 73, 1);
}

class AppGradientColor {
  final LinearGradient chatOppositeColor = LinearGradient(
    colors: [Color(0xffCCCCCC), Color(0xff939393)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  final LinearGradient chatMyColor = LinearGradient(
    colors: [Color(0xff41348C), Color(0xff0044A9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppStrokColor {
  Color cF0F0F0 = Color(0xffF0F0F0);
  Color darkgray2 = Color.fromARGB(255, 68, 67, 67);
}

class AppOppacityColor {
  Color cB4B4B4Opacity = Appcolors.appTextColor.textLighGray.withValues(
    alpha: 0.8,
  );
  Color appPrimOppacity = Appcolors.appPriSecColor.appPrimblue.withValues(
    alpha: 0.10,
  );
  Color cFFA41c = Appcolors.appExtraColor.yellowColor.withValues(alpha: 0.23);
  Color blackOpasity = Appcolors.appPriSecColor.appSecond;
  Color whiteOppacity01 = Appcolors.white.withValues(alpha: 0.1);
}

class AppExtraColor {
  Color yellowColor = Color(0xffFFA41C);
  Color greenColor = Color(0xff0C9400);
  Color c00F884 = Color(0xff00F884);
  Color grey = Color(0xffA4A4A4);
  Color cFFDCDC = Color(0xffFFDCDC);
  Color cC5FFCD = Color(0xffC5FFCD);
  Color cDCEBFF = Color(0xffDCEBFF);
  Color cE6DCFF = Color(0xffE6DCFF);
  Color cB5E2FF = Color(0xffB5E2FF);
  Color cFFDCFD = Color(0xffFFDCFD);
  Color cFFE1AA = Color(0xffFFE1AA);
  Color cB7FDF7 = Color(0xffB7FDF7);
  Color cB4B4B4 = Color(0xffB4B4B4).withValues(alpha: 0.08);
  Color cB4B4B41 = Color(0xffB4B4B4);
}

class AppBgColor {
  Color white = Colors.white;
  Color transparent = Colors.transparent;
  Color darkGray = Color.fromARGB(255, 34, 33, 33);
  Color darkMainBlack = Color(0xff181818);
}

class AppShadowColor {
  Color transparent = Colors.transparent;
  Color cECECEC = Color(0xffECECEC);
  Color darkShadowColor = Color(0xff0000000f);
  Color darkBorder = Color(0xff373737);
  Color grey200 = Colors.grey.shade200;
}

class AppChartColor {
  Color cADB7F9 = Color(0xffADB7F9);
  Color cB1B9F8 = Color(0xffB1B9F8).withValues(alpha: 0);
}
