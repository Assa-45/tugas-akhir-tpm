import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location not enabled");
    }

    LocationPermission permission = await Geolocator.requestPermission();

    return await Geolocator.getCurrentPosition();
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
}