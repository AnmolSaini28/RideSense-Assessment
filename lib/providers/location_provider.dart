import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart'; // For geocoding functionality

class LocationProvider with ChangeNotifier {
  String? _location;
  String? _errorMessage;
  LatLng? _coordinates; // Store the coordinates
  String?
      _formattedAddress; // For reverse geocoded address (if coordinates are input)

  String get location => _location ?? '';
  String? get errorMessage => _errorMessage;
  LatLng? get coordinates => _coordinates; // Expose the coordinates to the UI
  String? get formattedAddress =>
      _formattedAddress; // For reverse geocoded address

  // Function to set location or coordinates
  void setLocation(String location) async {
    _location = location;
    _errorMessage = null;

    // Check if input is coordinates or an address
    if (_isCoordinateInput(location)) {
      // If coordinates, parse them and use reverse geocoding
      await _getAddressFromCoordinates(location);
    } else {
      // Otherwise, treat input as a city name or address and geocode it
      await _getCoordinatesFromLocation(location);
    }

    notifyListeners();
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Function to convert location input to LatLng using Geocoding API
  Future<void> _getCoordinatesFromLocation(String location) async {
    try {
      // Use the geocoding package to get coordinates from the location input
      List<Location> locations = await locationFromAddress(location);

      if (locations.isNotEmpty) {
        // Extract the first result (usually the most relevant)
        Location loc = locations.first;
        _coordinates = LatLng(loc.latitude, loc.longitude);
        _formattedAddress = location; // Store the input as the address
      } else {
        // Handle case where no results were found
        _errorMessage = "No coordinates found for the provided location.";
      }
    } catch (e) {
      _errorMessage = "Error retrieving coordinates: ${e.toString()}";
    }
  }

  // Function to get address from LatLng using Reverse Geocoding API
  Future<void> _getAddressFromCoordinates(String input) async {
    try {
      // Split the input coordinates
      final parts = input.split(',');
      final latitude = double.parse(parts[0].trim());
      final longitude = double.parse(parts[1].trim());

      // Use the geocoding package to get the address from the coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        _coordinates = LatLng(latitude, longitude);
        _formattedAddress =
            "${placemark.locality}, ${placemark.country}"; // Create a readable address
      } else {
        _errorMessage = "No address found for the provided coordinates.";
      }
    } catch (e) {
      _errorMessage = "Error retrieving address: ${e.toString()}";
    }
  }

  // Helper function to check if the input is coordinates or address
  bool _isCoordinateInput(String input) {
    final coordinatePattern =
        RegExp(r'^\s*-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?\s*$');
    return coordinatePattern.hasMatch(input);
  }
}
