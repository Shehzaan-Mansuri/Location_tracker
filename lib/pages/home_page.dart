import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracker_app/models/location_range.dart';
import 'package:location_tracker_app/services/location_service.dart';
import 'package:location_tracker_app/services/notification_service.dart';

class HomePage extends StatefulWidget {
  final NotificationService notificationService;

  const HomePage({super.key, required this.notificationService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  Position? _currentPosition;
  LocationRange? _locationRange;
  final Set<Circle> _circles = {};
  Marker? _userMarker;
  bool _isWithinRange = true;

  @override
  void initState() {
    _initializeLocationTracking();
    super.initState();
  }

  // Initialize location tracking and notification setup
  Future<void> _initializeLocationTracking() async {
    if (!await _locationService.checkAndRequestPermissions()) {
      // Handle permission denial (Optional: Show error dialog or toast)
      return;
    }

    Position center = await _locationService.getCurrentLocation();
    double radius = 500; // meters

    setState(() {
      // Set the initial center point and radius only once
      _locationRange = LocationRange(center: center, radiusInMeters: radius);
      _currentPosition = center;
      _updateMarkers(center);
    });

    // Begin listening for location updates
    _locationService.getPositionStream().listen(_locationStreamHandler);
  }

  // Update the user marker and the location range circle
  void _updateMarkers(Position position) {
    // The circle's center should remain the initial position
    _circles.clear(); // Clear any existing circles
    _circles.add(
      Circle(
        circleId: const CircleId('defined_range'),
        center: LatLng(_locationRange!.center.latitude,
            _locationRange!.center.longitude), // Keep the initial center
        radius: _locationRange?.radiusInMeters ?? 500,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );

    _userMarker = Marker(
      markerId: const MarkerId('user_marker'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(title: 'You are here'),
    );
  }

  // Handle location updates and check if within the range
  void _locationStreamHandler(Position position) {
    log('Location update: ${position.latitude}, ${position.longitude}');

    setState(() {
      _currentPosition = position;
      _updateMarkers(position); // Update user marker on new position
    });

    final bool withinRange = _locationRange!.isWithinRange(position);
    if (withinRange != _isWithinRange) {
      _isWithinRange = withinRange;
      _sendRangeNotification();
    }

    // Animate map to the new location but don't change circle's center
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  // Show notification when the location enters or exits the range
  void _sendRangeNotification() {
    if (_isWithinRange) {
      log('User is within the range');
      widget.notificationService.showNotification(
        'Within Range',
        'You have entered the defined area.',
      );
    } else {
      log('User is out of the range');
      widget.notificationService.showNotification(
        'Out of Range',
        'You have exited the defined area.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        centerTitle: true,
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 16,
              ),
              markers: _userMarker != null ? {_userMarker!} : {},
              circles: _circles,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
