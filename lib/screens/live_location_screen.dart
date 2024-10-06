import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:map_flutter_app/providers/live_location_provider.dart';

class LiveLocationScreen extends StatelessWidget {
  const LiveLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final liveLocationProvider = Provider.of<LiveLocationProvider>(context);

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
      body: liveLocationProvider.isFetching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : liveLocationProvider.currentLocation != null
              ? Column(
                  children: [
                    Expanded(
                      child: GoogleMap(
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
                  child: Text('Click to fetch live Location.'),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          liveLocationProvider
              .fetchLiveLocation(); // Fetch live location when pressed
        },
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    );
  }
}
