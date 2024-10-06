import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  String? _location;
  String? _errorMessage;
  LatLng? _coordinates;
  String? _formattedAddress;

  String get location => _location ?? '';
  String? get errorMessage => _errorMessage;
  LatLng? get coordinates => _coordinates;
  String? get formattedAddress => _formattedAddress;

  void setLocation(String location) async {
    _location = location;
    _errorMessage = null;

    if (_isCoordinateInput(location)) {
      await _getAddressFromCoordinates(location);
    } else {
      await _getCoordinatesFromLocation(location);
    }

    notifyListeners();
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> _getCoordinatesFromLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);

      if (locations.isNotEmpty) {
        Location loc = locations.first;
        _coordinates = LatLng(loc.latitude, loc.longitude);
        _formattedAddress = location;
        notifyListeners();
      } else {
        _errorMessage = "No coordinates found for the provided location.";
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error retrieving coordinates: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<void> _getAddressFromCoordinates(String input) async {
    try {
      final parts = input.split(',');
      final latitude = double.parse(parts[0].trim());
      final longitude = double.parse(parts[1].trim());

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        _coordinates = LatLng(latitude, longitude);
        _formattedAddress = "${placemark.locality}, ${placemark.country}";
      } else {
        _errorMessage = "No address found for the provided coordinates.";
      }
    } catch (e) {
      _errorMessage = "Error retrieving address: ${e.toString()}";
    }
  }

  bool _isCoordinateInput(String input) {
    final coordinatePattern =
        RegExp(r'^\s*-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?\s*$');
    return coordinatePattern.hasMatch(input);
  }
}
