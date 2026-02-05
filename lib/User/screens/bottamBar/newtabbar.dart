// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:nlytical/User/screens/explore/explore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/home_screen.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/theme_contro.dart';
import 'package:nlytical/controllers/user_controllers/categories_contro.dart';
import 'package:nlytical/controllers/user_controllers/chat_contro.dart';
import 'package:nlytical/controllers/user_controllers/delete_contro.dart';
import 'package:nlytical/controllers/user_controllers/favourite_contro.dart';
import 'package:nlytical/controllers/user_controllers/filter_contro.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/controllers/user_controllers/home_contro.dart';
import 'package:nlytical/controllers/user_controllers/privacy_contro.dart';
import 'package:nlytical/controllers/user_controllers/review_contro.dart';
import 'package:nlytical/User/screens/categories/categories.dart';
import 'package:nlytical/User/screens/chat/user_message_screen.dart';
import 'package:nlytical/User/screens/controller/user_tab_controller.dart';
import 'package:nlytical/User/screens/homeScreen/home.dart';
import 'package:nlytical/User/screens/settings/setting.dart';
import 'package:nlytical/controllers/user_controllers/terms_contro.dart';
import 'package:nlytical/controllers/vendor_controllers/lang_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/login_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/profile_cotroller.dart';
import 'package:nlytical/controllers/vendor_controllers/service_controller.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global_fonts.dart';
import 'package:nlytical/utils/size_config.dart';
import 'package:nlytical/utils/global.dart';

class TabbarScreen extends StatefulWidget {
  final String? userID;
  int currentIndex = 0;
  TabbarScreen({super.key, this.userID, required this.currentIndex});
  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ExploreState> exploreKey = GlobalKey<ExploreState>();
  ThemeContro themeContro = Get.find();
  FilterContro filtercontro = Get.find();
  HomeContro homecontro = Get.find();
  LanguageController languageController = Get.find();
  LoginContro1 loginContro = Get.put(LoginContro1());
  CategoriesContro catecontro = Get.find();
  FavouriteContro favcontro = Get.find();
  ReviewContro reviewcontro = Get.find();

  ServiceController serviceController = Get.find();
  ProfileCotroller profileCotroller = Get.find();
  int page = 1;
  ChatController messageController = Get.find();

  UserTabController userTabController = Get.find();

  GetprofileContro getprofilecontro = Get.find();
  DeleteController deletecontro = Get.find();
  PrivacyPolicyContro privacycontro = Get.find();
  TermsContro termscontro = Get.find();

  // ignore: unused_field
  List<Widget> get _handlePages => [
    userID.isEmpty
        ? Home()
        : appPayment == true
        ? roleController.isUser.value
              ? Home()
              : HomeScreen()
        : Home(),
    Explore(key: exploreKey),
    Categories(),
    UserMessageScreen(),
    Setting(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userTabController.currentTabIndex.value = widget.currentIndex;
      apis();
      favcontro.favApi();
      catecontro.cateApi();
      messageController.chatApi(issearch: false, userid: userID);
    });
    super.initState();
  }

  void apis() {
    Get.find<GetprofileContro>().getprofileApi();
    Get.find<GetprofileContro>().updateProfileOne();
    homecontro.checkLocationPermission(isRought: false);
  }

  void refreshProfileData() {
    languageController.generalSettingApi();
    getprofilecontro.updateProfileOne();
    getprofilecontro.getprofileApi();
    privacycontro.privacypolicyApi();
    termscontro.termsandcondiApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Obx(
        () => IndexedStack(
          index: userTabController.currentTabIndex.value,
          children: _handlePages,
        ),
      ),
      floatingActionButton: userID.isEmpty
          ? SizedBox.shrink()
          : appPayment == true
          ? Obx(() {
              return userTabController.currentTabIndex.value == 0
                  ? Container(
                      height: getProportionateScreenHeight(40),
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Appcolors.appPriSecColor.appPrimblue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              roleController.isUserSelected();
                            },
                            child: Container(
                              height: 28,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  " ${languageController.textTranslate("User view")}",
                                  textAlign: TextAlign.center,
                                  style: AppTypography.text9Regular(context)
                                      .copyWith(
                                        color: roleController.isUser.value
                                            ? Appcolors.appTextColor.textWhite
                                            : Appcolors
                                                  .appTextColor
                                                  .textLighGray,
                                        fontSize: 12,
                                      ),
                                ).paddingSymmetric(horizontal: 13),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Appcolors.white,
                          ).paddingSymmetric(vertical: 7),
                          InkWell(
                            onTap: () {
                              roleController.isVendorSelected();
                            },
                            child: Container(
                              height: 28,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  languageController.textTranslate(
                                    "My Business",
                                  ),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.text9Regular(context)
                                      .copyWith(
                                        color: !roleController.isUser.value
                                            ? Appcolors.appTextColor.textWhite
                                            : Appcolors
                                                  .appTextColor
                                                  .textLighGray,
                                        fontSize: 12,
                                      ),
                                ).paddingSymmetric(horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 35)
                  : SizedBox.shrink();
            })
          : SizedBox.shrink(),
      // extendBody: true,
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkMainBlack,

            // Background color of bottom navigation bar
            boxShadow: !themeContro.isLightMode.value
                ? [
                    BoxShadow(
                      color: Appcolors.black,
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: Offset(5, 5),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Appcolors.grey.withValues(alpha: 0.3),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: themeContro.isLightMode.value
                ? Appcolors.white10
                : Appcolors.darkMainBlack,
            selectedItemColor: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.darkMainBlack,
            unselectedItemColor: themeContro.isLightMode.value
                ? Appcolors.white
                : Appcolors.black,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            currentIndex: userTabController.currentTabIndex.value,
            selectedLabelStyle: poppinsFont(
              8,
              themeContro.isLightMode.value ? Appcolors.black : Appcolors.white,
              FontWeight.w500,
            ),
            onTap: (index) {
              userTabController.currentTabIndex.value = index;
              if (index == 0) {
                getprofilecontro.getprofileApi();
                getprofilecontro.updateProfileOne();
                filtercontro.clear();
                if (roleController.isUser.value) {
                  homecontro.homeApi(
                    latitudee: userLatitude,
                    longitudee: userLatitude,
                  );
                }
              } else if (index == 1) {
                filtercontro.clear();
                filtercontro.filterApiAll();
              } else if (index == 2) {
                filtercontro.clear();
                catecontro.cateApi();
              } else if (index == 3) {
                filtercontro.clear();
              } else if (index == 4) {
                filtercontro.clear();
                refreshProfileData();
              }
            },
            items: [
              userTabController.currentTabIndex.value == 0
                  ? BottomNavigationBarItem(
                      icon: clippath(
                        label: languageController.textTranslate("Home"),
                        selectedIcon: AppAsstes.footerHome,
                      ),
                      label: '',
                    )
                  : BottomNavigationBarItem(
                      icon: unselected(
                        label: '',
                        selectedIcon: AppAsstes.home_unfill,
                      ),
                      label: '',
                    ),
              userTabController.currentTabIndex.value == 1
                  ? BottomNavigationBarItem(
                      icon: clippath(
                        label: languageController.textTranslate("Explore"),
                        selectedIcon: AppAsstes.footerExplore,
                      ),
                      label: '',
                    )
                  : BottomNavigationBarItem(
                      icon: unselected(
                        selectedIcon: AppAsstes.explore_unfill,
                        label: "",
                      ),
                      label: '',
                    ),
              userTabController.currentTabIndex.value == 2
                  ? BottomNavigationBarItem(
                      icon: clippath(
                        label: languageController.textTranslate("Categories"),
                        selectedIcon: AppAsstes.footerCate,
                      ),
                      label: '',
                    )
                  : BottomNavigationBarItem(
                      icon: unselected(
                        selectedIcon: AppAsstes.cate_unfill,
                        label: "",
                      ),
                      label: 'Categories',
                    ),
              BottomNavigationBarItem(
                icon: userTabController.currentTabIndex.value == 3
                    ? clippath(
                        label: languageController.textTranslate("Message"),
                        selectedIcon: AppAsstes.footerMsg,
                      )
                    : unselected(selectedIcon: AppAsstes.message, label: ""),

                label: '',
              ),
              userTabController.currentTabIndex.value == 4
                  ? BottomNavigationBarItem(
                      icon: clippath(
                        label: languageController.textTranslate("Settings"),
                        selectedIcon: AppAsstes.footerSetting,
                      ),
                      label: '',
                    )
                  : BottomNavigationBarItem(
                      icon: unselected(
                        selectedIcon: AppAsstes.setting_unfill,
                        label: "",
                      ),
                      label: 'Settings',
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ClipPath clippath({required String selectedIcon, required String label}) {
    return ClipPath(
      clipper: BottomNavBarClipper(),
      child: Container(
        height: 53,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Appcolors.appPriSecColor.appPrimblue.withValues(alpha: 0.01),
              Appcolors.appPriSecColor.appPrimblue.withValues(alpha: 0.45),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(selectedIcon, height: 25),
            SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: themeContro.isLightMode.value
                    ? Appcolors.black
                    : Appcolors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column unselected({required String selectedIcon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              selectedIcon,
              height: 25,
              color: themeContro.isLightMode.value
                  ? Appcolors.black
                  : Appcolors.white,
            ),
            selectedIcon == AppAsstes.message
                ? Positioned(
                    right: -5,
                    top: -8,
                    child: Obx(() {
                      return messageController.totalUnreadMessages.value == 0
                          ? const SizedBox.shrink()
                          : Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Appcolors.appPriSecColor.appPrimblue,
                              ),
                              child: Center(
                                child: Text(
                                  messageController.totalUnreadMessages.value >
                                          9
                                      ? "9+"
                                      : "${messageController.totalUnreadMessages.value}",
                                  style: poppinsFont(
                                    8,
                                    Appcolors.white,
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                    }),
                  )
                : SizedBox.shrink(),
          ],
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: themeContro.isLightMode.value
                ? Appcolors.black
                : Appcolors.white,
          ),
        ),
      ],
    );
  }
}

// Custom Clipper for BottomNavigationBar Shape
class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Start at the left edge
    path.moveTo(0, 0);

    // Draw to the left side of the dip
    path.lineTo(size.width, 0);

    // Draw a downward curve for the dip
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.8, // Control point
      size.width * 0.8,
      0.8, // End of the dip
    );

    // Continue to the right edge
    path.lineTo(size.width, 0);

    // Close the path with the bottom line
    path.lineTo(size.width * 0.7, size.height);
    path.lineTo(size.width * 0.3, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
