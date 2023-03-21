import 'dart:convert';

import 'package:http/http.dart';

class LocationHelper {
  static String generateLocationPreviewImage(double latitude,
      double longitude,) {
    return 'https://maps.googleapis.com/maps/api/staticmap' +
        '?center=$latitude,$longitude' +
        '&zoom=16' +
        '&size=600x300' +
        '&markers=color:red%7Clabel:%7C$latitude,$longitude' +
        '&key=${getGoogleApiKey()}';
  }

  static Future<String> getPlaceAddress(double latitude,
      double longitude) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json' +
        '?latlng=$latitude,$longitude' +
        '&location_type=ROOFTOP&result_type=street_address' +
        '&key=${getGoogleApiKey()}';
    final response = await get(Uri.parse(url));
    final List addresses = json.decode(response.body)['results'];
    if (addresses == null)
      return null;
    else
      return addresses.first['formatted_address'];
  }

  static String getGoogleApiKey() {
    const apiKey = String.fromEnvironment('GOOGLE_API_KEY');
    if (apiKey.isEmpty) throw AssertionError('GOOGLE_API_KEY is not set, use `flutter run --dart-define GOOGLE_API_KEY=your-key`');
    return apiKey;
  }
}
