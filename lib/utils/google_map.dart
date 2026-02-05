// ignore_for_file: deprecated_member_use

import 'package:url_launcher/url_launcher.dart';

void openGoogleMaps({
  required String originLat,
  required String originLong,
  required String destLat,
  required String destLong,
}) async {
  final googleMapsUrl =
      'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLong'
      '&destination=$destLat,$destLong&travelmode=driving&dir_action=navigate';

  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
  } else {
    throw 'Could not launch $googleMapsUrl';
  }
}
