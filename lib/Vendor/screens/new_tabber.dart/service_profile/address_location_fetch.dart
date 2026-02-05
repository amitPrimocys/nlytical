// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:http/http.dart' as http;

class GeocodingResult {
  final double latitude;
  final double longitude;
  final String? area;
  final String? city;
  final String? state;
  final String? country;

  GeocodingResult({
    required this.latitude,
    required this.longitude,
    this.area,
    this.city,
    this.state,
    this.country,
  });

  @override
  String toString() {
    return 'Lat: $latitude, Lng: $longitude, Area: $area, City: $city, State: $state, Country: $country';
  }
}

class GeocodingService {
  static Future<GeocodingResult?> fetchLocationDetails(String address) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleMapKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          final components = data['results'][0]['address_components'];

          String? area;
          String? city;
          String? state;
          String? country;

          for (var component in components) {
            List types = component['types'];

            if (types.contains('sublocality') ||
                types.contains('sublocality_level_1')) {
              area = component['long_name'];
            } else if (types.contains('locality')) {
              city = component['long_name'];
            } else if (types.contains('administrative_area_level_1')) {
              state = component['long_name'];
            } else if (types.contains('country')) {
              country = component['long_name'];
            }
          }

          return GeocodingResult(
            latitude: location['lat'],
            longitude: location['lng'],
            area: area,
            city: city,
            state: state,
            country: country,
          );
        } else {
          ("No results found for address: $address");
          return null;
        }
      } else {
        ("Geocoding failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      ("Error in Geocoding: $e");
      return null;
    }
  }
}
