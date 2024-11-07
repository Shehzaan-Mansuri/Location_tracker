import 'package:geolocator/geolocator.dart';

class LocationRange {
  final Position center;
  final double radiusInMeters;

  LocationRange({required this.center, required this.radiusInMeters});

  // Check if a position is within the range
  bool isWithinRange(Position position) {
    double distance = Geolocator.distanceBetween(
      center.latitude,
      center.longitude,
      position.latitude,
      position.longitude,
    );
    return distance <= radiusInMeters;
  }
}
