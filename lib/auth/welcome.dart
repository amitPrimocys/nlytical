import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/login.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/size_config.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAsstes.splashbg2),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Scaffold(
          backgroundColor: Appcolors.appBgColor.transparent,
          body: Column(
            children: [
              CachedNetworkImage(
                imageUrl: appLogo,
                height: 55,
                width: 180,
                placeholder: (context, url) {
                  return SizedBox.shrink();
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    AppAsstes.logo,
                    height: 55,
                    width: 180,
                    fit: BoxFit.contain,
                  );
                },
              ).paddingSymmetric(horizontal: 100, vertical: 95),
              sizeBoxHeight(310),
              Center(
                child: Image.asset(
                  AppAsstes.welcomehand,
                  height: getProportionateScreenHeight(53),
                  width: getProportionateScreenWidth(181),
                ),
              ),
              Center(
                child: label(
                  "Hello welcome to Nlytical app",
                  maxLines: 2,
                  textColor: Appcolors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              sizeBoxHeight(25),
              GestureDetector(
                onTap: () {
                  Get.to(
                    const Login(isLogin: false),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Container(
                  height: getProportionateScreenHeight(60),
                  width: getProportionateScreenWidth(300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Appcolors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/sms.png',
                        color: Appcolors.appPriSecColor.appPrimblue,
                        height: 20,
                      ),
                      sizeBoxWidth(10),
                      label(
                        "Continue with Login",
                        maxLines: 2,
                        textColor: Appcolors.appPriSecColor.appPrimblue,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
              sizeBoxHeight(25),
              GestureDetector(
                onTap: () async {
                  // Access SharedPreferences instance

                  // Save guest user status (1 for guest, 0 for not a guest)
                  await SecurePrefs.setInt('isGuest', 1);

                  // Navigate to the Home screen
                  roleController.isUserSelected();
                  Get.to(TabbarScreen(currentIndex: 0));
                },
                child: Container(
                  height: getProportionateScreenHeight(60),
                  width: getProportionateScreenWidth(300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Appcolors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/profile1.png',
                        height: 20,
                        color: Appcolors.white,
                      ),
                      sizeBoxWidth(10),
                      label(
                        "Continue As Guest",
                        maxLines: 2,
                        textColor: Appcolors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
