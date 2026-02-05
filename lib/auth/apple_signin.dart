// ignore_for_file: prefer_if_null_operators, avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_new, use_build_context_synchronously, prefer_const_constructors, dangling_library_doc_comments, unreachable_switch_default

///////
///
/// PACKAGE:::::the_apple_sign_in: ^1.1.1
///
///////

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fmsg;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nlytical/controllers/user_controllers/login_contro.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

String? name;
String? email;
String? imageUrl;
String? userId;
String data = "";

class AppleSignInService {
  Future<void> signInWithApple(BuildContext context) async {
    final deviceTokenProvider = Get.find<LoginContro>();
    try {
      // userAuthController.isAppleLoading(true);
      deviceTokenProvider.isApplLogin.value = true;

      final user = await signInWithAppleMain(
        scopes: [Scope.email, Scope.fullName],
        context: context,
      );

      name = user.email == null
          ? ""
          : user.email!.substring(0, user.email!.indexOf('@'));
      email = user.email == null ? "" : user.email;
      imageUrl = user.photoURL == null ? "" : user.photoURL;
      userId = user.uid;
    } catch (e) {
      deviceTokenProvider.isApplLogin.value = false;
    } finally {
      deviceTokenProvider.isApplLogin.value = false;
    }
  }

  Future<User> signInWithAppleMain({
    List<Scope> scopes = const [],
    required BuildContext context,
  }) async {
    final deviceTokenProvider = Get.find<LoginContro>();

    final _firebaseAuth = FirebaseAuth.instance;

    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: scopes),
    ]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken: String.fromCharCodes(
            appleIdCredential.authorizationCode!,
          ),
        );
        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );
        final firebaseUser = userCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;

          final displayName = fullName == null
              ? ''
              : '${fullName.givenName} ${fullName.familyName}';

          await firebaseUser.updateDisplayName(displayName);
          // }
        }

        // ignore: unnecessary_null_comparison
        if (firebaseUser.uid != null) {
          fmsg.FirebaseMessaging.instance.getToken().then((token) async {
            await deviceTokenProvider.socialApplLoginApi(
              type: "apple",
              email: email.toString(),
            );
          });
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }
}
