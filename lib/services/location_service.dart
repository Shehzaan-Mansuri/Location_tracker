import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check and request location permissions
  Future<bool> checkAndRequestPermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false; // Location services not enabled
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission != LocationPermission.deniedForever;
  }

  // Get the current location of the device
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: defaultTargetPlatform == TargetPlatform.android
          ? AndroidSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            )
          : AppleSettings(
              accuracy: LocationAccuracy.best,
              distanceFilter: 10,
            ),
    );
  }

  // Stream for receiving position updates
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: defaultTargetPlatform == TargetPlatform.android
          ? _androidLocationSettings()
          : _iosLocationSettings(),
    );
  }

  // Android location settings configuration
  AndroidSettings _androidLocationSettings() {
    return AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      intervalDuration: const Duration(seconds: 2),
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
            "App continues to track your location in the background.",
        notificationTitle: "Location Tracking",
        enableWakeLock: true,
      ),
    );
  }

  // iOS location settings configuration
  AppleSettings _iosLocationSettings() {
    return AppleSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      allowBackgroundLocationUpdates: true,
    );
  }
}
