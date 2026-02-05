// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/utils/global.dart';

class LocationService {
  LocationService();

  /// Request location permission from the user
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false; // Permission denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false; // Permissions permanently denied
    }

    return true; // Permission granted
  }

  /// Get current location (latitude, longitude)
  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Fetch nearby places (e.g., restaurants)
  Future<List<Map<String, dynamic>>> fetchNearbyPlaces() async {
    Position? position = await getCurrentLocation();
    if (position == null) {
      throw Exception("Location permission denied or unavailable");
    }

    String baseURL =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    String request =
        '$baseURL?location=${position.latitude},${position.longitude}&radius=5000&type=restaurant&key=$googleMapKey';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      List<dynamic> places = jsonDecode(response.body)['results'];

      return places.map((place) {
        double placeLat = place['geometry']['location']['lat'];
        double placeLng = place['geometry']['location']['lng'];

        double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          placeLat,
          placeLng,
        );

        return {
          'name': place['name'],
          'vicinity': place['vicinity'],
          'distance': (distanceInMeters / 1000).toStringAsFixed(2),
        };
      }).toList();
    } else {
      throw Exception("Failed to fetch nearby places.");
    }
  }

  /// Get search suggestions from Google Places API
  Future<List<Map<String, dynamic>>> getSuggestions(
    String input,
    String sessionToken,
  ) async {
    String baseURL =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseURL?input=$input&key=$googleMapKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> predictions = jsonResponse['predictions'];

      List<Map<String, dynamic>> suggestionsWithDetails = [];

      for (var suggestion in predictions) {
        String placeId = suggestion['place_id'];
        Map<String, String?> details = await _getPlaceDetails(placeId);

        suggestionsWithDetails.add({
          'description': suggestion['description'],
          'state': details['state'],
          'country': details['country'],
        });
      }

      return suggestionsWithDetails;
    } else {
      throw Exception("Problem while getting location suggestions.");
    }
  }

  /// Fetch place details (State, Country) from place ID
  Future<Map<String, String?>> _getPlaceDetails(String placeId) async {
    String placeDetailsURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapKey";

    var placeResponse = await http.get(Uri.parse(placeDetailsURL));

    if (placeResponse.statusCode == 200) {
      var placeDetails = jsonDecode(placeResponse.body);
      var addressComponents = placeDetails['result']['address_components'];

      String? state;
      String? country;

      for (var component in addressComponents) {
        List types = component['types'];
        if (types.contains('administrative_area_level_1')) {
          state = component['long_name'];
        }
        if (types.contains('country')) {
          country = component['long_name'];
        }
      }

      return {'state': state, 'country': country};
    } else {
      return {'state': null, 'country': null};
    }
  }
}
