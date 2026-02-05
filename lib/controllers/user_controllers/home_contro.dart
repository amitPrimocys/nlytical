// ignore_for_file: deprecated_member_use
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/global.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nlytical/models/user_models/home_model.dart';
import 'package:nlytical/shared_preferences/prefrences_key.dart';
import 'package:nlytical/shared_preferences/shared_prefkey.dart';
import 'package:nlytical/utils/common_widgets.dart';

final ApiHelper apiHelper = ApiHelper();

class HomeContro extends GetxController {
  RxBool ishome = false.obs;
  Rx<HomeModel?> homemodel = HomeModel().obs;
  RxList<Categories> categories = <Categories>[].obs;
  RxList<LatestService> allcatelist = <LatestService>[].obs;
  RxList<NearbyStores> nearbylist = <NearbyStores>[].obs;
  RxList<NearbyStores> nearbyFiltlist = <NearbyStores>[].obs;
  var currentAddress = "Fetching location...";
  RxList<LatestService> filteredStores = <LatestService>[].obs;

  Future<void> homeApi({String? latitudee, String? longitudee}) async {
    try {
      ishome.value = true;
      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.home,
        headers: authToken.isNotEmpty
            ? {
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
                'Authorization': "Bearer $authToken",
              }
            : {},
        formData: (latitudee!.isNotEmpty && longitudee!.isNotEmpty)
            ? {'lat': latitudee, 'lon': longitudee}
            : {},
        files: [],
      );

      homemodel.value = HomeModel.fromJson(response);

      categories.clear();
      allcatelist.clear();
      nearbylist.clear();
      filteredStores.clear();
      nearbyFiltlist.clear();

      if (homemodel.value!.status == true) {
        categories.addAll(homemodel.value!.categories!);

        allcatelist.addAll(homemodel.value!.latestService!);
        nearbylist.addAll(homemodel.value!.nearbyStores!);

        nearbyFiltlist.assignAll(nearbylist);
        filteredStores.assignAll(allcatelist);
        ishome.value = false;
      } else {
        ishome.value = false;
      }
    } catch (e) {
      ishome.value = false;
    }
  }

  void searchStores(String query) {
    if (query.isEmpty) {
      nearbyFiltlist.assignAll(nearbylist);
      filteredStores.assignAll(allcatelist);
    } else {
      nearbyFiltlist.assignAll(
        nearbylist.where(
          (store) =>
              store.serviceName!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
      filteredStores.assignAll(
        allcatelist.where(
          (store) =>
              store.serviceName!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> checkLocationPermission({required bool isRought}) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      // Open settings to enable permission manually
      // bool opened = await Geolocator.openAppSettings();

      // ✅ Wait for a short delay, then re-check
      await Future.delayed(Duration(seconds: 2));

      // Recheck after returning from settings
      LocationPermission newPermission = await Geolocator.checkPermission();
      if (newPermission == LocationPermission.whileInUse ||
          newPermission == LocationPermission.always) {
        isRought ? await _savePosition() : await _getCurrentLocation();
      } else {
        snackBar("Location permission is still not granted.");
      }
      return;
    }

    if (permission == LocationPermission.denied) {
      LocationPermission newPermission = await Geolocator.requestPermission();

      if (newPermission == LocationPermission.whileInUse ||
          newPermission == LocationPermission.always) {
        isRought ? await _savePosition() : await _getCurrentLocation();
      } else if (newPermission == LocationPermission.deniedForever) {
        // bool opened = await Geolocator.openAppSettings();
        await Future.delayed(Duration(seconds: 2));
        LocationPermission retryPermission = await Geolocator.checkPermission();
        if (retryPermission == LocationPermission.whileInUse ||
            retryPermission == LocationPermission.always) {
          isRought ? await _savePosition() : await _getCurrentLocation();
        } else {
          snackBar("Please enable location manually from settings.");
        }
      } else {
        snackBar("Please allow location access.");
        homeApi();
      }
      return;
    }

    // Already granted
    isRought ? await _savePosition() : await _getCurrentLocation();
  }

  Future<void> _savePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];
    currentAddress =
        "${place.subLocality} ,${place.locality}, ${place.administrativeArea}, ${place.country}";

    await SecurePrefs.setString(
      SecureStorageKeys.LATTITUDE,
      position.latitude.toString(),
    );
    await SecurePrefs.setString(
      SecureStorageKeys.LONGITUDE,
      position.longitude.toString(),
    );
    userLatitude = (await SecurePrefs.getString(SecureStorageKeys.LATTITUDE))!;
    userLongitude = (await SecurePrefs.getString(SecureStorageKeys.LONGITUDE))!;
    homeApi(latitudee: userLatitude, longitudee: userLongitude);
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Fetch the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      await SecurePrefs.setString(
        SecureStorageKeys.LATTITUDE,
        position.latitude.toString(),
      );
      await SecurePrefs.setString(
        SecureStorageKeys.LONGITUDE,
        position.longitude.toString(),
      );
      userLatitude = (await SecurePrefs.getString(
        SecureStorageKeys.LATTITUDE,
      ))!;
      userLongitude = (await SecurePrefs.getString(
        SecureStorageKeys.LONGITUDE,
      ))!;
      Placemark place = placemarks[0];
      currentAddress =
          "${place.subLocality} ,${place.locality}, ${place.administrativeArea}, ${place.country}";

      homeApi(latitudee: userLatitude, longitudee: userLongitude);
    } catch (e) {
      homeApi();
    }
  }
}
