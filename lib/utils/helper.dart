import 'dart:math';
import 'package:geolocator/geolocator.dart';

class Helper{
  static Position? currentLocation;
  static Future<double> calculateDistance(double houseLatitude, double houseLongitude) async {
    if (currentLocation == null) {
      // Get current location if location permission allowed
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
    }
    //current location not found
    if (currentLocation == null) return 0;

    double lat1 = currentLocation!.latitude;
    double lon1 = currentLocation!.longitude;
    double lat2 = houseLatitude;
    double lon2 = houseLongitude;

    // Radius of the earth in kilometers
    const double earthRadius = 6371;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    // Distance in km
    double distance = earthRadius * c;

    return distance;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

}