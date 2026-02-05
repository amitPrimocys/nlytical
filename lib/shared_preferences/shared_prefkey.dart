import 'dart:convert';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/utils/global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurePrefs {
  static final FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  SecurePrefs(FlutterSecureStorage storage);

  static Future<void> getLoadPrefs() async {
    await SecureStorageKeys().loadUserFromPrefs();
  }

  // Write data
  static Future<void> setString(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<void> setBool(String key, bool value) async {
    await storage.write(key: key, value: value.toString());
  }

  static Future<void> setInt(String key, int value) async {
    await storage.write(key: key, value: value.toString());
  }

  static Future<void> setDouble(String key, double value) async {
    await storage.write(key: key, value: value.toString());
  }

  // Write json model
  static Future<void> setModel<T>(String key, T model) async {
    final String jsonString = jsonEncode(model);
    await storage.write(key: key, value: jsonString);
  }

  // Read model
  static Future<T?> getModel<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final String? jsonString = await storage.read(key: key);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return fromJson(jsonMap);
    }
    return null;
  }

  // Read data
  static Future<String?> getString(String key) async {
    return await storage.read(key: key);
  }

  static Future<bool?> getBool(String key) async {
    final val = await storage.read(key: key);
    if (val == null) return null;
    return val == 'true';
  }

  static Future<int> getInt(String key) async {
    final val = await storage.read(key: key);
    return int.tryParse(val ?? '') ?? 0;
  }

  static Future<double> getDouble(String key) async {
    final val = await storage.read(key: key);
    return double.tryParse(val ?? '') ?? 0.0;
  }

  // Remove
  static Future<void> remove(String key) async {
    await storage.delete(key: key);
  }

  static Future<void> clear() async {
    userRole = "";
    await storage.delete(key: SecureStorageKeys.ROlE);
    contrycode = '';
    await storage.delete(key: SecureStorageKeys.COUINTRY_CODE);
    countryFlagCode = '';
    await storage.delete(key: SecureStorageKeys.COUINTRY_FLAG_CODE);
    authToken = "";
    await storage.delete(key: SecureStorageKeys.AUTH_TOKEN);
    isPhoneVerify = false;
    await storage.delete(key: SecureStorageKeys.isPhoneVerify);
    isEmailVerify = false;
    await storage.delete(key: SecureStorageKeys.isEmailVerify);
    userID = "";
    await storage.delete(key: SecureStorageKeys.USER_ID);
    userEmail = "";
    await storage.delete(key: SecureStorageKeys.USER_EMAIL);
    userIMAGE = "";
    await storage.delete(key: SecureStorageKeys.LOGGED_IN_USERIMAGE);
    userName = "";
    await storage.delete(key: SecureStorageKeys.USER_NAME);
    userFirstName = "";
    await storage.delete(key: SecureStorageKeys.USER_FNAME);
    userLastName = "";
    await storage.delete(key: SecureStorageKeys.USER_LNAME);
    userMobileNum = "";
    await storage.delete(key: SecureStorageKeys.USER_MOBILE);
    country = "";
    await storage.delete(key: SecureStorageKeys.COUNTRY_NAME);
    userLatitude = "";
    await storage.delete(key: SecureStorageKeys.LATTITUDE);
    userLongitude = "";
    await storage.delete(key: SecureStorageKeys.LONGITUDE);
    deviceToken = "";
    await storage.delete(key: SecureStorageKeys.DEVICE_TOKEN);
    userStoreID = "";
    await storage.delete(key: SecureStorageKeys.STORE_ID);
    percentageStore = "";
    await storage.delete(key: SecureStorageKeys.PERCENTAGE);
    userTextDirection = "";
    await storage.delete(key: SecureStorageKeys.textDirection);
  }

  static Future<void> setMultiple(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        await setString(key, value);
      } else if (value is int) {
        await setInt(key, value);
      } else if (value is bool) {
        await setBool(key, value);
      } else if (value is double) {
        await setDouble(key, value);
      } else if (value is List<String>) {
        // Join list into comma-separated string or handle with jsonEncode
        await setString(key, jsonEncode(value));
      } else {
        throw UnsupportedError(
          "Unsupported type for SecurePrefs: ${value.runtimeType}",
        );
      }
    }
  }

  static Future<Map<String, dynamic>> getMultiple(List<String> keys) async {
    final Map<String, dynamic> result = {};

    for (final key in keys) {
      final value = await storage.read(key: key);

      if (value == null) {
        result[key] = null;
        continue;
      }

      try {
        // Try parsing as List<String> (if json encoded)
        final decoded = jsonDecode(value);
        if (decoded is List) {
          result[key] = List<String>.from(decoded);
        } else {
          result[key] = value;
        }
      } catch (_) {
        // If not JSON, return as String
        result[key] = value;
      }
    }

    return result;
  }

  static Future<void> getMultipleAndSetGlobalsWithMap(
    Map<String, void Function(String?)> setters,
  ) async {
    final keys = setters.keys.toList();
    final data = await getMultiple(keys);

    for (final entry in setters.entries) {
      final value = data[entry.key];
      entry.value(value);
    }
  }
}
