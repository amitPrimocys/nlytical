// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:convert';
import 'package:nlytical/User/screens/homeScreen/chat_screen2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nlytical/auth/profile_details.dart';
import 'package:nlytical/auth/welcome.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/controllers/role_controller.dart';
import 'package:nlytical/controllers/user_controllers/chat_contro.dart';
import 'package:nlytical/controllers/vendor_controllers/lang_controller.dart';
import 'package:nlytical/main.dart';
import 'package:nlytical/notification_service.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/assets.dart';
import 'package:nlytical/controllers/theme_contro.dart';
import 'package:nlytical/utils/global.dart';

ThemeContro themeContro = Get.find();
LanguageController languageController = Get.find();
RoleController roleController = Get.find();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  var _isLightMode;
  ChatController messageController = Get.find();

  AnimationController? animationController;
  Animation<double>? animation;

  Future<Timer> startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    roleController.isUserSelected();
    Get.offAll(_handleCurrentScreen());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      assignValueForMode();
      animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      );
      animation = CurvedAnimation(
        parent: animationController!,
        curve: Curves.easeOut,
      );

      // ignore: unnecessary_this
      animation!.addListener(() => this.setState(() {}));
      animationController!.forward();

      setState(() {
        _visible = !_visible;
      });
      startTime();

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          final data = message.data;
          if (data['type'] == "review") {
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => TabbarScreen(currentIndex: 0),
              ),
              (route) => false,
            );
          } else if (data['type'] == "subscriber") {
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => TabbarScreen(currentIndex: 0),
              ),
              (route) => false,
            );
          } else {
            messageController.chatApi(issearch: false, userid: userID);
            // Navigate to ChatScreen
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => ChatScreen2(
                  isLead: "0",
                  toUserID: data['from_user'].toString(),
                  fname: data['first_name'].toString(),
                  lname: data['last_name'].toString(),
                  lastSeen: data['last_seen'].toString(),
                  profile: data['profile_image'].toString(),
                  block: int.tryParse(data['block_status'] ?? '0') ?? 0,
                  isRought: false,
                ),
              ),
            );
          }
        }
      });

      FirebaseMessaging.onMessage.listen((message) {
        if (message.notification != null) {
          InitializationSettings initializationSettings =
              const InitializationSettings(
                android: AndroidInitializationSettings("@mipmap/ic_launcher"),
                iOS: DarwinInitializationSettings(),
              );

          LocalNotificationService.notificationsPlugin.initialize(
            settings: initializationSettings,
            onDidReceiveNotificationResponse: (NotificationResponse details) {
              if (details.payload != null) {
                final data = jsonDecode(details.payload!);
                if (data['type'] == "Message") {
                  navigatorKey.currentState?.push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen2(
                        isLead: "0",
                        toUserID: data['from_user'].toString(),
                        fname: data['first_name'].toString(),
                        lname: data['last_name'].toString(),
                        lastSeen: data['last_seen'].toString(),
                        profile: data['profile_image'].toString(),
                        block: int.tryParse(data['block_status'] ?? '0') ?? 0,
                        isRought: false,
                      ),
                    ),
                  );
                } else {
                  navigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => TabbarScreen(currentIndex: 0),
                    ),
                    (route) => false,
                  );
                }
              }
            },
            // background notification received
            onDidReceiveBackgroundNotificationResponse: (details) {
              if (details.payload != null) {
                final data = jsonDecode(details.payload!);

                if (data['type'] == "Message") {
                  navigatorKey.currentState?.push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen2(
                        isLead: "0",
                        toUserID: data['from_user'].toString(),
                        fname: data['first_name'].toString(),
                        lname: data['last_name'].toString(),
                        lastSeen: data['last_seen'].toString(),
                        profile: data['profile_image'].toString(),
                        block: int.tryParse(data['block_status'] ?? '0') ?? 0,
                        isRought: false,
                      ),
                    ),
                  );
                } else {
                  navigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => TabbarScreen(currentIndex: 0),
                    ),
                    (route) => false,
                  );
                }
              }
            },
          );
          messageController.chatApi(issearch: false, userid: userID);
          LocalNotificationService().createanddisplaynotification(message);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        messageController.chatApi(issearch: false, userid: userID);

        final data = message.data; // ✅ Use this instead of details.payload

        if (data['type'] == "Message") {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => ChatScreen2(
                isLead: "0",
                toUserID: data['from_user'].toString(),
                fname: data['first_name'].toString(),
                lname: data['last_name'].toString(),
                lastSeen: data['last_seen'].toString(),
                profile: data['profile_image'].toString(),
                block: int.tryParse(data['block_status'] ?? '0') ?? 0,
                isRought: false,
              ),
            ),
          );
        } else {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => TabbarScreen(currentIndex: 0),
            ),
            (route) => false,
          );
        }
      });
    });
  }

  Future<void> assignValueForMode() async {
    _isLightMode = await SecurePrefs.getBool(SecureStorageKeys.isLightMode);

    if (_isLightMode == null) {
      // First time: set default as true
      _isLightMode = true;
      await SecurePrefs.setBool(SecureStorageKeys.isLightMode, _isLightMode!);
    }

    // Now update the theme
    themeContro.updateLightModeValue(_isLightMode!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAsstes.splashbg1),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          ).paddingSymmetric(horizontal: 100, vertical: 100),
        ],
      ),
    );
  }

  Widget _handleCurrentScreen() {
    // Logic to decide the screen to navigate to
    if (authToken.isEmpty) {
      // Navigate to SplashScreen if both IDs are null
      return Welcome();
    } else {
      String? userfname = userFirstName;
      String? usermobile = userMobileNum;
      String? useremail = userEmail;

      // Get.find<HomeContro>().checkLocationPermission();
      if (userfname.isEmpty) {
        return ProfileDetails(number: usermobile, email: useremail);
      } else {
        roleController.isUserSelected();
        return TabbarScreen(currentIndex: 0);
      }
    }
  }
}
