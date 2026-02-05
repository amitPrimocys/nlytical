// ignore_for_file: constant_identifier_names

import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/global.dart';

class SecureStorageKeys {
  static const String AUTH_TOKEN = "AUTH_TOKEN";
  static const String IS_USER_LOGGED_IN = "IS_USER_LOGGED_IN";
  static const String LOGGED_IN_USERRDATA = "LOGGED_IN_USERRDATA";
  static const String USER_EMAIL = "USER_EMAIL";
  static const String USER_NAME = "USER_NAME";
  static const String USER_ID = "USER_ID";
  // static const String LOGGED_IN_USERID = "LOGGED_IN_USERID";
  static const String LOGGED_IN_USERTOKEN = "LOGGED_IN_USERTOKEN";
  static const String ROlE = "ROlE";
  static const String LATTITUDE = "LATTITUDE";
  static const String LONGITUDE = "LONGITUDE";
  static const String STATUS = "STATUS";
  static const String SUBSCRIBE = "SUBSCRIBE";
  static const String lnId = "lnId";
  static const String textDirection = "textDirection";
  static const String USER_FNAME = "USER_FNAME";
  static const String USER_LNAME = "USER_LNAME";
  static const String USER_MOBILE = "USER_MOBILE";
  static const String COUNTRY_NAME = "COUNTRY_NAME";
  static const String COUINTRY_CODE = "COUINTRY_CODE";
  static const String COUINTRY_FLAG_CODE = "COUINTRY_FLAG_CODE";
  static const String LOGGED_IN_USERIMAGE = "LOGGED_IN_USERIMAGE";
  static const String STORE_ID = "STORE_ID";
  static const String PERCENTAGE = 'PERCENTAGE';
  static const String ISGUEST = 'ISGUEST';
  static const isLightMode = 'isLightMode';
  static const String DEVICE_TOKEN = "DEVICE_TOKEN";
  static const String STORE_COUNTRY_CODE = "STORE_COUNTRY_CODE";
  static const String STORE_MOBILE = "STORE_MOBILE";
  static const String STORE_EMAIL = "STORE_EMAIL";
  static const String IMAGE_STATUS = "IMAGE_STATUS";
  static const String isEmailVerify = 'isEmailVerify';
  static const String isPhoneVerify = 'isPhoneVerify';

  Map<String, void Function(String)> prefSetters = {
    AUTH_TOKEN: (val) => authToken = val,
    USER_ID: (val) => userID = val,
    USER_NAME: (val) => userName = val,
    USER_FNAME: (val) => userFirstName = val,
    USER_LNAME: (val) => userLastName = val,
    COUINTRY_CODE: (val) => contrycode = val,
    USER_MOBILE: (val) => userMobileNum = val,
    COUNTRY_NAME: (val) => country = val,
    USER_EMAIL: (val) => userEmail = val,
    LOGGED_IN_USERIMAGE: (val) => userIMAGE = val,
    ROlE: (val) => userRole = val,
    lnId: (val) => userLangID = val,
    STORE_ID: (val) => userStoreID = val,
    COUINTRY_FLAG_CODE: (val) => countryFlagCode = val,
    LATTITUDE: (val) => userLatitude = val,
    LONGITUDE: (val) => userLongitude = val,
  };

  Future<void> loadUserFromPrefs() async {
    for (final entry in prefSetters.entries) {
      final value = await SecurePrefs.getString(entry.key) ?? "";
      entry.value(value);
      // print('Loaded ${entry.key}: $value');
    }
  }
}

class SharedPrefHelper {
  /// Async getter for `isGuest`
  static Future<int> getIsGuest() async {
    final value = await SecurePrefs.getString(SecureStorageKeys.ISGUEST);
    return value == "1" ? 1 : 0;
  }

  /// Method to set `isGuest` value
  static Future<void> setGuestStatus(int status) async {
    await SecurePrefs.setString(SecureStorageKeys.ISGUEST, status.toString());
  }
}

class Role {
  static const String user = "user";
  static const String vendor = "vendor";

  /// Async getter for `role`
  static Future<String> getRole() async {
    final value = await SecurePrefs.getString(SecureStorageKeys.ROlE);
    return value == user ? user : vendor;
  }

  /// Setter for `role`
  static Future<void> setRole(String value) async {
    await SecurePrefs.setString(SecureStorageKeys.ROlE, value);
  }
}
