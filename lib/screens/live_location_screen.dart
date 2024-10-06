import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_flutter_app/providers/map_provider.dart';
import 'package:provider/provider.dart';
import 'package:map_flutter_app/providers/live_location_provider.dart';

class LiveLocationScreen extends StatelessWidget {
  const LiveLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final liveLocationProvider = Provider.of<LiveLocationProvider>(context);
    final mapTypeProvider = Provider.of<MapTypeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Location',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: liveLocationProvider.currentLocation != null
          ? Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: mapTypeProvider.currentMapType,
                    initialCameraPosition: CameraPosition(
                      target: liveLocationProvider.currentLocation!,
                      zoom: 14.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('liveLocation'),
                        position: liveLocationProvider.currentLocation!,
                        infoWindow: InfoWindow(
                          title: 'You are here',
                          snippet: liveLocationProvider.currentAddress,
                        ),
                      ),
                    },
                  ),
                ),
                if (liveLocationProvider.currentAddress != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Address: ${liveLocationProvider.currentAddress}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            )
          : const Center(
              child: Text('Fetching live location...'),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton(
                heroTag: 'liveLocationFAB',
                backgroundColor: Colors.blue,
                onPressed: () {
                  liveLocationProvider.fetchLiveLocation();
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
                  mapTypeProvider.toggleMapType();
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
