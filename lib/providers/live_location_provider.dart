import 'package:flutter/material.dart';
import 'package:location/location.dart'
    as loc; // Alias the location package as loc
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LiveLocationProvider with ChangeNotifier {
  LatLng? _currentLocation;
  String? _currentAddress;
  String? _errorMessage;
  bool _isFetching = false;

  loc.Location locationController = loc.Location(); // Use loc.Location

  LatLng? get currentLocation => _currentLocation;
  String? get currentAddress => _currentAddress;
  String? get errorMessage => _errorMessage;
  bool get isFetching => _isFetching;

  // Fetch current location quickly using getLocation, followed by continuous updates
  Future<void> fetchLiveLocation() async {
    _isFetching = true;
    notifyListeners();

    try {
      // Check if location services and permissions are enabled
      bool serviceEnabled = await locationController.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationController.requestService();
        if (!serviceEnabled) {
          _errorMessage = 'Location services are disabled.';
          _isFetching = false;
          notifyListeners();
          return;
        }
      }

      loc.PermissionStatus permissionGranted =
          await locationController.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await locationController.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          _errorMessage = 'Location permission denied.';
          _isFetching = false;
          notifyListeners();
          return;
        }
      }

      // Get initial location quickly
      loc.LocationData locationData = await locationController.getLocation();
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      await _getAddressFromCoordinates(_currentLocation!); // Get the address

      _isFetching = false;
      notifyListeners();

      // Listen for continuous updates in the background
      locationController.onLocationChanged
          .listen((loc.LocationData newLocationData) async {
        _currentLocation =
            LatLng(newLocationData.latitude!, newLocationData.longitude!);
        await _getAddressFromCoordinates(_currentLocation!);
        notifyListeners();
      });
    } catch (e) {
      _errorMessage = 'Error fetching live location: $e';
      _isFetching = false;
      notifyListeners();
    }
  }

  // Reverse geocoding to get the address
  Future<void> _getAddressFromCoordinates(LatLng coordinates) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        _currentAddress = "${placemark.locality}, ${placemark.country}";
      } else {
        _currentAddress = "No address found for live location.";
      }
    } catch (e) {
      _errorMessage = "Error retrieving address: ${e.toString()}";
    }
  }
}
