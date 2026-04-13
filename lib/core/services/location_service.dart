// ignore_for_file: deprecated_member_use

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static Future<Position?> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // هل GPS مفتوح؟
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    // check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // get location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // حفظ الموقع في SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble("latitude", position.latitude);

    await prefs.setDouble("longitude", position.longitude);

    return position;
  }
}
