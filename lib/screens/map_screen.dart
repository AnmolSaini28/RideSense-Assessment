import 'package:flutter/material.dart';
import 'package:map_flutter_app/providers/location_provider.dart';
import 'package:map_flutter_app/providers/map_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final mapTypeProvider = Provider.of<MapTypeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: locationProvider.coordinates != null
          ? Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: mapTypeProvider.currentMapType,
                    initialCameraPosition: CameraPosition(
                      target: locationProvider
                          .coordinates!, // Use the fetched coordinates
                      zoom: 10.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('userLocation'),
                        position: locationProvider.coordinates!,
                      ),
                    },
                  ),
                ),
                if (locationProvider.formattedAddress != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Address: ${locationProvider.formattedAddress}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            )
          : const Center(
              child:
                  Text('Enter a location or coordinates to see it on the map')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton(
                heroTag: 'liveLocationFAB', // Add a unique heroTag
                backgroundColor: Colors.blue,
                onPressed: () {
                  locationProvider.coordinates!;
                },
                child: const Icon(
                  Icons.my_location,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  mapTypeProvider
                      .toggleMapType(); // Toggle map type when pressed
                },
                child: const Icon(
                  Icons.map,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
