//3.32.7
import 'package:nlytical/utils/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:nlytical/User/screens/controller/user_tab_controller.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/role_controller.dart';
import 'package:nlytical/controllers/user_controllers/add_review_contro.dart';
import 'package:nlytical/controllers/user_controllers/appfeedback_contro.dart';
import 'package:nlytical/controllers/user_controllers/block_contro.dart';
import 'package:nlytical/controllers/user_controllers/categories_contro.dart';
import 'package:nlytical/controllers/user_controllers/chat_contro.dart';
import 'package:nlytical/controllers/user_controllers/delete_contro.dart';
import 'package:nlytical/controllers/user_controllers/edit_review_contro.dart';
import 'package:nlytical/controllers/user_controllers/favourite_contro.dart';
import 'package:nlytical/controllers/user_controllers/feedback_contro.dart';
import 'package:nlytical/controllers/user_controllers/filter_contro.dart';
import 'package:nlytical/controllers/user_controllers/forgot_contro.dart';
import 'package:nlytical/controllers/user_controllers/forgot_otp_controller.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/controllers/user_controllers/home_contro.dart';
import 'package:nlytical/controllers/user_controllers/like_contro.dart';
import 'package:nlytical/controllers/user_controllers/login_contro.dart';
import 'package:nlytical/controllers/user_controllers/mobile_contro.dart';
import 'package:nlytical/controllers/user_controllers/otp_contro.dart';
import 'package:nlytical/controllers/user_controllers/password_contro.dart';
import 'package:nlytical/controllers/user_controllers/privacy_contro.dart';
import 'package:nlytical/controllers/user_controllers/profile_detail_contro.dart';
import 'package:nlytical/controllers/user_controllers/register_contro.dart';
import 'package:nlytical/controllers/user_controllers/report_contro.dart';
import 'package:nlytical/controllers/user_controllers/review_contro.dart';
import 'package:nlytical/controllers/user_controllers/service_contro.dart';
import 'package:nlytical/controllers/user_controllers/subcate_service_contro.dart';
import 'package:nlytical/controllers/user_controllers/terms_contro.dart';
import 'package:nlytical/controllers/user_controllers/vendor_info_contro.dart';
import 'package:nlytical/controllers/vendor_controllers/budget_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/business_review_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/campaign_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/chat_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/insights_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/lang_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/location_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/payment_history_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/profile_cotroller.dart';
import 'package:nlytical/controllers/vendor_controllers/review_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/service_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/support_controller.dart';
import 'package:nlytical/controllers/vendor_controllers/tabbar_controller.dart';
import 'package:nlytical/notification_service.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/controllers/theme_contro.dart';
import 'package:nlytical/controllers/vendor_controllers/payment_controller.dart';

import 'auth/splash.dart';
import 'controllers/vendor_controllers/lang_controller.dart';
import 'notification_service.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  // Initialize secure storage
  final storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked,
      synchronizable: false,
    ),
  );
  SecurePrefs(storage);
  await SecurePrefs.getLoadPrefs();
  Get.put(LanguageController());
  Get.put(RoleController());
  Get.put(PaymentController());
  Get.put(RegisterContro());
  Get.put(OtpController());
  Get.put(PassCheckController());
  Get.put(ThemeContro());
  Get.put(LoginContro());
  Get.put(MobileContro());
  Get.put(UserTabController());
  Get.put(VendorTabbarController());
  Get.put(ForgotContro());
  Get.put(HomeContro());
  Get.put(ServiceContro());
  Get.put(SubcateserviceContro());
  Get.put(LikeContro());
  Get.put(CategoriesContro());
  Get.put(FilterContro());
  Get.put(FavouriteContro());
  Get.put(ReviewContro());
  Get.put(ChatController());
  Get.put(ProfileCotroller());
  Get.put(ProfileDetailContro());
  Get.put(DeleteController());
  Get.put(PrivacyPolicyContro());
  Get.put(TermsContro());
  Get.put(FeedbackContro());
  Get.put(PaymentHistoryController());
  Get.put(InsightsController());
  Get.put(BlockContro());
  Get.put(ReportContro());
  Get.put(AddreviewContro());
  Get.put(VendorInfoContro());
  Get.put(EditReviewContro());
  Get.put(AppfeedbackContro());
  Get.put(ChatControllervendor());
  Get.put(BusinessReviewController());
  Get.put(ReviewControvendor());
  Get.put(LocationController());
  Get.put(CampaignController());
  Get.put(BudgetController());
  Get.put(ServiceController());
  Get.put(ForgotOtpController());
  Get.put(GetprofileContro());
  Get.put(SupportController());
  Get.put(PaymentController());
  final String langId = userLangID.isNotEmpty == true ? userLangID : "1";
  await Get.put(
    LanguageController(),
  ).getLanguageTranslation(lnId: langId.toString());

  runApp(
    Obx(() {
      return GetMaterialApp(
        navigatorKey: navigatorKey,
        textDirection: languageController.currentDirection.value,
        themeMode: ThemeMode.system,
        color: Appcolors.white,
        locale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    }),
  );
}
