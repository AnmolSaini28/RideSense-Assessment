// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:map_flutter_app/core/providers/live_location_provider.dart';
import 'package:map_flutter_app/core/providers/location_provider.dart';
import 'package:map_flutter_app/presentation/screens/live_location_screen.dart';
import 'package:map_flutter_app/presentation/screens/map_screen.dart';
import 'package:provider/provider.dart';

class LocationInputScreen extends StatelessWidget {
  final _locationController = TextEditingController();

  LocationInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final livelocationProvider = Provider.of<LiveLocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter location',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset:
                        const Offset(0, 3), // changes position of the shadow
                  ),
                ],
              ),
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location (city name, address, or coordinates)',
                  labelStyle: const TextStyle(fontSize: 14),
                  errorText: locationProvider.errorMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none, // Remove default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                String location = _locationController.text.trim();
                if (location.isEmpty) {
                  locationProvider.setErrorMessage('Please enter a location.');
                } else {
                  locationProvider.setLocation(location);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Live Location',
        child: FloatingActionButton(
          heroTag: 'locationInputFAB', // Add a unique heroTag
          onPressed: () async {
            await livelocationProvider.fetchLiveLocation();
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const LiveLocationScreen()),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}
