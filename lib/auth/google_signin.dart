// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nlytical/controllers/user_controllers/login_contro.dart';
import 'package:nlytical/utils/common_widgets.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? name;
String? email;
String? imageUrl;
String? userId;
String data = "";
Future<String> signInWithGoogle(BuildContext context) async {
  try {
    Get.find<LoginContro>().isSocialLogin(true);
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn
        .signIn();

    if (googleSignInAccount == null) {
      // User cancelled the sign-in
      Get.find<LoginContro>().isSocialLogin(false);
      return 'Google sign-in aborted';
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(
      credential,
    );
    final firebase_auth.User user = authResult.user!;
    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;
    userId = user.uid;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final firebase_auth.User currentUser = authResult.user!;
    assert(user.uid == currentUser.uid);

    // ignore: unnecessary_null_comparison
    if (user.uid != null) {
      FirebaseMessaging.instance.getToken().then((token) {
        Get.find<LoginContro>().socialLoginApi(
          type: "google",
          email: email.toString(),
        );
      });
    }
  } on FirebaseAuthException catch (e) {
    Get.find<LoginContro>().isSocialLogin(false);

    debugPrint("FirebaseAuthException Code: ${e.code}");
    debugPrint("Message: ${e.message}");

    snackBar("Google sign-in failed: ${e.message}");
  } catch (e) {
    Get.find<LoginContro>().isSocialLogin(false);

    snackBar("Google sign-in failed. Try again.");
  }
  return 'signInWithGoogle succeeded';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}
