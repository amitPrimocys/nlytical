import 'dart:ui';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/forgot_contro.dart';
import 'package:nlytical/auth/register.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/global_text_form_field.dart';
import 'package:nlytical/utils/size_config.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({super.key});

  @override
  State<Forgotpass> createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  TextEditingController emailcontroller = TextEditingController();
  ForgotContro forgotcontro = Get.find();

  FocusNode signUpPasswordFocusNode = FocusNode();
  FocusNode signUpEmailIDFocusNode = FocusNode();
  final emailFieldKey = GlobalKey<FormFieldState>();
  bool isselected = false;

  void fieldcheck() {
    setState(() {
      isselected = emailcontroller.text.isEmail;
    });
  }

  @override
  void initState() {
    emailcontroller.addListener(fieldcheck);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          color: themeContro.isLightMode.value
              ? Appcolors.white
              : Appcolors.darkMainBlack,
          image: const DecorationImage(
            image: AssetImage(AppAsstes.appbackground),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Scaffold(
          backgroundColor: Appcolors.appBgColor.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                sizeBoxHeight(45),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Image.asset(
                          'assets/images/arrow-left1.png',
                          height: 24,
                        ).paddingAll(5),
                      ),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(65),
                CachedNetworkImage(
                  imageUrl: appLogo,
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
                ).paddingSymmetric(horizontal: 100),
                sizeBoxHeight(15),
                Center(
                  child: Text(
                    "Discover more about our app by registering or logging in",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: AppTypography.text12Ragular(
                      context,
                    ).copyWith(color: Appcolors.appTextColor.textDarkGrey),
                  ),
                ).paddingSymmetric(horizontal: 40),

                sizeBoxHeight(15),
                sizeBoxHeight(17),
                globalTextField(
                  key: emailFieldKey,
                  lable: "Email Address",
                  lable2: ' *',
                  controller: emailcontroller,
                  onEditingComplete: () {
                    FocusScope.of(
                      context,
                    ).requestFocus(signUpPasswordFocusNode);
                  },
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      (emailFieldKey.currentState)?.validate();
                    }
                  },
                  focusNode: signUpEmailIDFocusNode,
                  hintText: 'Email Address',
                  context: context,
                  imagePath: 'assets/images/sms.png',
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Appcolors.appExtraColor.cB4B4B4,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/sms.png',
                          color: Appcolors.grey500,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
                sizeBoxHeight(25),
                Obx(() {
                  return forgotcontro.isLoading.value
                      ? commonLoading()
                      : GestureDetector(
                          onTap: () {
                            final isEmailValid =
                                emailFieldKey.currentState?.validate() ?? false;

                            if (isEmailValid) {
                              forgotcontro.forgotApi(
                                email: emailcontroller.text,
                              );
                            } else {
                              snackBar("Please fill the mandatory fields");
                            }
                          },
                          child: Container(
                            height: 50,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: isselected
                                  ? Appcolors.logoColork
                                  : Appcolors.logoColorWith60Opacityk,
                            ),
                            child: Center(
                              child: Text(
                                "Get OTP",
                                style: AppTypography.text16(context).copyWith(
                                  color: Appcolors.appTextColor.textWhite,
                                ),
                              ),
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 50);
                }),
                SizedBox(height: Get.height * 0.46),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: AppTypography.text12Ragular(context),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const Register(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: AppTypography.text14Medium(context).copyWith(
                          color: Appcolors.appPriSecColor.appPrimblue,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
