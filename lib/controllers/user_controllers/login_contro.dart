import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/Vendor/screens/add_store.dart';
import 'package:nlytical/auth/profile_details.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/controllers/user_controllers/get_profile_contro.dart';
import 'package:nlytical/models/social_login_model.dart';
import 'package:nlytical/models/user_models/login_model.dart';
import 'package:nlytical/User/screens/bottamBar/newtabbar.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:nlytical/utils/global.dart';

GetprofileContro getprofileContro = Get.find();

class LoginContro extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  RxBool isSocial = false.obs;
  RxBool isApple = false.obs;
  RxBool isLoading = false.obs;
  var isObscureForSignUp = true.obs;
  Rx<LoginModel?> loginModel = LoginModel().obs;

  RxBool isAppleLoad = false.obs;

  Future<void> loginApi({String? email, String? password}) async {
    await SecurePrefs.getMultipleAndSetGlobalsWithMap({
      SecureStorageKeys.DEVICE_TOKEN: (v) => deviceToken = v!,
    });
    try {
      isLoading.value = true;

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.login,
        headers: {},
        formData: {
          'email': '$email',
          'password': '$password',
          'device_token': deviceToken,
        },
        files: [],
      );

      loginModel.value = LoginModel.fromJson(response);

      if (loginModel.value!.status == true) {
        if (loginModel.value!.userBlock == 1) {
          await SecurePrefs.clear();
          subscribedUserGlobal = loginModel.value!.subscribedUser!;
          isStoreGlobal = loginModel.value!.isStore!;

          await SecurePrefs.setMultiple({
            SecureStorageKeys.AUTH_TOKEN: loginModel.value!.token,
            SecureStorageKeys.LOGGED_IN_USERIMAGE: loginModel.value!.image
                .toString(),
            SecureStorageKeys.ROlE: loginModel.value!.role.toString(),
            SecureStorageKeys.USER_ID: loginModel.value!.userId.toString(),
            SecureStorageKeys.USER_EMAIL: loginModel.value!.email.toString(),
            SecureStorageKeys.COUINTRY_CODE: loginModel.value!.countryCode
                .toString(),
            SecureStorageKeys.USER_MOBILE: loginModel.value!.mobile,
            SecureStorageKeys.USER_FNAME: loginModel.value!.firstName,
            SecureStorageKeys.USER_LNAME: loginModel.value!.lastName,
            SecureStorageKeys.COUINTRY_FLAG_CODE: loginModel.value!.countryFlag,
          });
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.AUTH_TOKEN: (v) => authToken = v!,
            SecureStorageKeys.LOGGED_IN_USERIMAGE: (v) => userIMAGE = v!,
            SecureStorageKeys.USER_ID: (v) => userID = v!,
            SecureStorageKeys.ROlE: (v) => userRole = v!,
            SecureStorageKeys.USER_EMAIL: (v) => userEmail = v!,
          });
          getprofileContro.updateProfileOne();

          if (loginModel.value!.username!.isNotEmpty) {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_NAME: loginModel.value!.username!,
            });
          }

          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.USER_NAME: (v) => userName = v!,
            SecureStorageKeys.COUINTRY_CODE: (v) => contrycode = v!,
            SecureStorageKeys.USER_MOBILE: (v) => userMobileNum = v!,
          });

          snackBar(loginModel.value!.message!);
          //navigate to cart
          if (loginModel.value!.role == "user") {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_FNAME: loginModel.value!.firstName,
            });

            await SecurePrefs.getMultipleAndSetGlobalsWithMap({
              SecureStorageKeys.USER_FNAME: (v) => userFirstName = v!,
            });
            // Get.find<HomeContro>().checkLocationPermission();
            roleController.isUserSelected();
            await SecurePrefs.getLoadPrefs();
            await Get.offAll(() => TabbarScreen(currentIndex: 0));
          } else {
            await SecurePrefs.remove(SecureStorageKeys.USER_ID);
            userID = "";
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_ID: loginModel.value!.userId.toString(),
              SecureStorageKeys.USER_EMAIL: loginModel.value!.email.toString(),
              SecureStorageKeys.STORE_ID: loginModel.value!.serviceId
                  .toString(),
              SecureStorageKeys.SUBSCRIBE: loginModel.value!.subscribedUser
                  .toString(),
            });
            await SecurePrefs.getMultipleAndSetGlobalsWithMap({
              SecureStorageKeys.USER_ID: (v) => userID = v!,
              SecureStorageKeys.USER_EMAIL: (v) => userEmail = v!,
              SecureStorageKeys.STORE_ID: (v) => userStoreID = v!,
            });

            roleController.isVendorSelected();
            await SecurePrefs.getLoadPrefs();
            await Get.offAll(() => TabbarScreen(currentIndex: 0));
          }
          //================================== when you bloked by admin then show bootmsheet =========================================
        } else {
          userDisableSheet();
        }

        isLoading.value = false;
      } else {
        isLoading.value = false;
        snackBar(loginModel.value!.message!);
      }
    } catch (e) {
      isLoading.value = false;
      snackBar("Something went wrong, try again");
    }
  }

  // ***************************************************** SOCIAL LOGIN **************************************************
  RxBool isSocialLogin = false.obs;
  Rx<SocialLoginModel> socialLoginModel = SocialLoginModel().obs;
  Future<void> socialLoginApi({
    required String type,
    required String email,
  }) async {
    try {
      isSocialLogin(true);

      var uri = Uri.parse(apiHelper.socialLogin);
      var request = http.MultipartRequest("POST", uri);
      request.fields['login_type'] = type;
      request.fields['email'] = email;
      request.fields['device_token'] = deviceToken;

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      socialLoginModel.value = SocialLoginModel.fromJson(data);

      if (socialLoginModel.value.status == true) {
        if (socialLoginModel.value.user!.userBlock == 1) {
          await SecurePrefs.clear();
          subscribedUserGlobal = socialLoginModel.value.user!.isSubscriber ?? 0;
          isStoreGlobal = loginModel.value!.isStore ?? 0;
          await SecurePrefs.setString(
            SecureStorageKeys.AUTH_TOKEN,
            socialLoginModel.value.user!.token!,
          );
          await SecurePrefs.setString(
            SecureStorageKeys.ROlE,
            socialLoginModel.value.user!.role.toString(),
          );
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.ROlE: (v) => userRole = v!,
          });
          if (socialLoginModel.value.user!.username!.isNotEmpty) {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_NAME:
                  socialLoginModel.value.user!.username!,
            });
          }

          if (socialLoginModel.value.user!.loginType == 'mobile') {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.isPhoneVerify: true,
            });
            isPhoneVerify = (await SecurePrefs.getBool(
              SecureStorageKeys.isPhoneVerify,
            ))!;
          } else if (socialLoginModel.value.user!.loginType == 'email') {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.isEmailVerify: true,
            });
            isEmailVerify = (await SecurePrefs.getBool(
              SecureStorageKeys.isEmailVerify,
            ))!;
          } else {
            isEmailVerify = false;
            isPhoneVerify = false;
          }

          if (socialLoginModel.value.user!.countryFlag!.isNotEmpty) {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.COUINTRY_FLAG_CODE: socialLoginModel
                  .value
                  .user!
                  .countryFlag
                  .toString(),
            });
            await SecurePrefs.getMultipleAndSetGlobalsWithMap({
              SecureStorageKeys.COUINTRY_FLAG_CODE: (v) => countryFlagCode = v!,
            });
          }

          if (socialLoginModel.value.user!.countryCode!.isNotEmpty ||
              socialLoginModel.value.user!.mobile!.isNotEmpty) {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.COUINTRY_CODE:
                  socialLoginModel.value.user!.countryCode!,
              SecureStorageKeys.USER_MOBILE:
                  socialLoginModel.value.user!.mobile!,
            });
            await SecurePrefs.getMultipleAndSetGlobalsWithMap({
              SecureStorageKeys.COUINTRY_CODE: (v) => contrycode = v!,
              SecureStorageKeys.USER_MOBILE: (v) => userMobileNum = v!,
            });
          }
          if (socialLoginModel.value.user!.role == "user") {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_ID: socialLoginModel.value.user!.id
                  .toString(),
              SecureStorageKeys.USER_FNAME: socialLoginModel
                  .value
                  .user!
                  .firstName
                  .toString(),
              SecureStorageKeys.USER_EMAIL: email,
            });
            await SecurePrefs.getMultipleAndSetGlobalsWithMap({
              SecureStorageKeys.USER_ID: (v) => userID = v!,
              SecureStorageKeys.USER_FNAME: (v) => userFirstName = v!,
              SecureStorageKeys.USER_EMAIL: (v) => userEmail = v!,
            });
            Get.find<GetprofileContro>().updateProfileOne();
            Get.find<GetprofileContro>().getprofileApi();

            if (socialLoginModel.value.user!.isSubscriber != 0) {
              await SecurePrefs.setMultiple({
                SecureStorageKeys.SUBSCRIBE: socialLoginModel
                    .value
                    .user!
                    .isSubscriber
                    .toString(),
              });
              subscribedUserGlobal = 1;
              if (socialLoginModel.value.user!.serviceId != "0" ||
                  socialLoginModel.value.user!.serviceId != "") {
                await SecurePrefs.setMultiple({
                  SecureStorageKeys.STORE_ID: socialLoginModel
                      .value
                      .user!
                      .serviceId
                      .toString(),
                });
                isStoreGlobal = 1;
              }
            }

            // Check if LOGGED_IN_USERFNAME is empty
            if (socialLoginModel.value.user!.firstName == "") {
              Get.to(() => ProfileDetails(email: email, number: ""));
            } else {
              roleController.isUserSelected();
              Get.offAll(() => TabbarScreen(currentIndex: 0));
            }
            // Get.find<HomeContro>().checkLocationPermission(isRought: false);
            // Get.offAll(() => TabbarScreen(currentIndex: 0));
          } else {
            await SecurePrefs.remove(SecureStorageKeys.USER_ID);
            userID = "";
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_ID: socialLoginModel.value.user!.id
                  .toString(),
            });

            // await profileCotroller.updateProfileApi1();
            Get.find<GetprofileContro>().updateProfileOne();
            Get.find<GetprofileContro>().getprofileApi();

            if (socialLoginModel.value.user!.isSubscriber != 0) {
              await SecurePrefs.setMultiple({
                SecureStorageKeys.SUBSCRIBE: socialLoginModel
                    .value
                    .user!
                    .isSubscriber
                    .toString(),
              });
              if (socialLoginModel.value.user!.serviceId != "0" ||
                  socialLoginModel.value.user!.serviceId != "") {
                await SecurePrefs.setMultiple({
                  SecureStorageKeys.STORE_ID: socialLoginModel
                      .value
                      .user!
                      .serviceId
                      .toString(),
                });
                // Get.offAll(() => VendorNewTabar(currentIndex: 0));
                roleController.isVendorSelected();
                Get.offAll(() => TabbarScreen(currentIndex: 0));
              } else {
                if (isDemo == "false") {
                  Get.offAll(() => AddStore());
                } else {
                  Get.offAll(() => TabbarScreen(currentIndex: 0));
                }
              }
            } else {
              roleController.isVendorSelected();
              Get.offAll(() => TabbarScreen(currentIndex: 0));
            }
          }
        } else {
          userDisableSheet();
        }

        isSocialLogin(false);
      } else {
        isSocialLogin(false);

        snackBar(socialLoginModel.value.message!);
      }
    } catch (e) {
      isSocialLogin(false);
      log(">>>>>>>socialLoginError>>>>>:${e.toString()}");
      snackBar("Something went wrong, try again");
    }
  }

  // ***************************************************** SOCIAL LOGIN **************************************************
  RxBool isApplLogin = false.obs;
  Future<void> socialApplLoginApi({
    required String type,
    required String email,
  }) async {
    try {
      isApplLogin(true);

      var uri = Uri.parse(apiHelper.socialLogin);
      var request = http.MultipartRequest("POST", uri);

      request.fields['login_type'] = type;
      request.fields['email'] = email;
      request.fields['device_token'] = deviceToken;

      var response = await request.send();
      String responseData = await response.stream
          .transform(utf8.decoder)
          .join();
      var data = json.decode(responseData);

      socialLoginModel.value = SocialLoginModel.fromJson(data);

      if (socialLoginModel.value.status == true) {
        if (socialLoginModel.value.user!.userBlock == 1) {
          await SecurePrefs.clear();
          subscribedUserGlobal = socialLoginModel.value.user!.isSubscriber ?? 0;
          isStoreGlobal = loginModel.value!.isStore ?? 0;
          await SecurePrefs.setString(
            SecureStorageKeys.AUTH_TOKEN,
            socialLoginModel.value.user!.token!,
          );
          await SecurePrefs.setMultiple({
            SecureStorageKeys.ROlE: socialLoginModel.value.user!.role
                .toString(),
          });
          await SecurePrefs.getMultipleAndSetGlobalsWithMap({
            SecureStorageKeys.AUTH_TOKEN: (v) => authToken = v!,
            SecureStorageKeys.ROlE: (v) => userRole = v!,
          });
          if (socialLoginModel.value.user!.username!.isNotEmpty) {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_NAME: socialLoginModel.value.user!.username
                  .toString(),
            });
          }

          if (socialLoginModel.value.user!.loginType == 'mobile') {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.isPhoneVerify: true,
            });
            isPhoneVerify = (await SecurePrefs.getBool(
              SecureStorageKeys.isPhoneVerify,
            ))!;
          } else if (socialLoginModel.value.user!.loginType == 'email') {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.isEmailVerify: true,
            });
            isEmailVerify = (await SecurePrefs.getBool(
              SecureStorageKeys.isEmailVerify,
            ))!;
          } else {
            isEmailVerify = false;
            isPhoneVerify = false;
          }

          if (socialLoginModel.value.user!.countryFlag!.isNotEmpty) {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.COUINTRY_FLAG_CODE: socialLoginModel
                  .value
                  .user!
                  .countryFlag
                  .toString(),
            });
            await SecurePrefs.getMultipleAndSetGlobalsWithMap({
              SecureStorageKeys.COUINTRY_FLAG_CODE: (v) => countryFlagCode = v!,
            });
          }

          if (socialLoginModel.value.user!.countryCode!.isNotEmpty ||
              socialLoginModel.value.user!.mobile!.isNotEmpty) {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.COUINTRY_CODE:
                  socialLoginModel.value.user!.countryCode!,
              SecureStorageKeys.USER_MOBILE:
                  socialLoginModel.value.user!.mobile!,
            });
            await SecurePrefs.getMultipleAndSetGlobalsWithMap({
              SecureStorageKeys.COUINTRY_CODE: (v) => contrycode = v!,
              SecureStorageKeys.USER_MOBILE: (v) => userMobileNum = v!,
            });
          }
          if (socialLoginModel.value.user!.role == "user") {
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_ID: socialLoginModel.value.user!.id
                  .toString(),
              SecureStorageKeys.USER_FNAME: socialLoginModel
                  .value
                  .user!
                  .firstName
                  .toString(),
              SecureStorageKeys.USER_EMAIL: email,
            });
            await SecurePrefs.getMultipleAndSetGlobalsWithMap({
              SecureStorageKeys.USER_ID: (v) => userID = v!,
              SecureStorageKeys.USER_FNAME: (v) => userFirstName = v!,
              SecureStorageKeys.USER_EMAIL: (v) => userEmail = v!,
            });

            Get.find<GetprofileContro>().updateProfileOne();
            Get.find<GetprofileContro>().getprofileApi();

            // Check if LOGGED_IN_USERFNAME is empty

            if (socialLoginModel.value.user!.isSubscriber != 0) {
              await SecurePrefs.setMultiple({
                SecureStorageKeys.SUBSCRIBE: socialLoginModel
                    .value
                    .user!
                    .isSubscriber
                    .toString(),
              });
              subscribedUserGlobal = 1;
              if (socialLoginModel.value.user!.serviceId != "0" ||
                  socialLoginModel.value.user!.serviceId != "") {
                await SecurePrefs.setMultiple({
                  SecureStorageKeys.STORE_ID: socialLoginModel
                      .value
                      .user!
                      .serviceId
                      .toString(),
                });
                isStoreGlobal = 1;
              }
            }

            if (socialLoginModel.value.user!.firstName == "") {
              Get.to(() => ProfileDetails(email: email, number: ""));
            } else {
              roleController.isUserSelected();
              Get.offAll(() => TabbarScreen(currentIndex: 0));
            }
            // Get.find<HomeContro>().checkLocationPermission(isRought: false);
            // Get.offAll(() => TabbarScreen(currentIndex: 0));
          } else {
            await SecurePrefs.remove(SecureStorageKeys.USER_ID);
            userID = "";
            await SecurePrefs.setMultiple({
              SecureStorageKeys.USER_ID: socialLoginModel.value.user!.id
                  .toString(),
            });

            // await profileCotroller.updateProfileApi1();
            Get.find<GetprofileContro>().updateProfileOne();
            Get.find<GetprofileContro>().getprofileApi();

            if (socialLoginModel.value.user!.isSubscriber != 0) {
              await SecurePrefs.setString(
                SecureStorageKeys.SUBSCRIBE,
                socialLoginModel.value.user!.isSubscriber.toString(),
              );
              if (socialLoginModel.value.user!.serviceId != "0" ||
                  socialLoginModel.value.user!.serviceId != "") {
                await SecurePrefs.setString(
                  SecureStorageKeys.STORE_ID,
                  socialLoginModel.value.user!.serviceId.toString(),
                );
                // Get.offAll(() => VendorNewTabar(currentIndex: 0));
                roleController.isVendorSelected();
                Get.offAll(() => TabbarScreen(currentIndex: 0));
              } else {
                if (isDemo == "false") {
                  Get.offAll(() => AddStore());
                } else {
                  Get.offAll(() => TabbarScreen(currentIndex: 0));
                }
              }
            } else {
              roleController.isVendorSelected();
              Get.offAll(() => TabbarScreen(currentIndex: 0));
            }
          }
        } else {
          userDisableSheet();
        }

        isApplLogin(false);
      } else {
        isApplLogin(false);
        snackBar(socialLoginModel.value.message!);
      }
    } catch (e) {
      isApplLogin(false);

      snackBar("Something went wrong, try again");
    }
  }
}
