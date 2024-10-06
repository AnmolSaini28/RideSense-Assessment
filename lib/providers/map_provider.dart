import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeProvider with ChangeNotifier {
  MapType _currentMapType = MapType.normal;

  MapType get currentMapType => _currentMapType;

  // Function to switch between map types
  void toggleMapType() {
    if (_currentMapType == MapType.normal) {
      _currentMapType = MapType.satellite;
    } else if (_currentMapType == MapType.satellite) {
      _currentMapType = MapType.terrain;
    } else if (_currentMapType == MapType.terrain) {
      _currentMapType = MapType.hybrid;
    } else {
      _currentMapType = MapType.normal; // Reset to normal if no other map type
    }
    notifyListeners();
  }
}
