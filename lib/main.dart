import 'package:flutter/material.dart';
import 'package:map_flutter_app/providers/live_location_provider.dart';
import 'package:map_flutter_app/providers/location_provider.dart';
import 'package:map_flutter_app/providers/map_provider.dart';
import 'package:map_flutter_app/screens/location_input%20_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => LiveLocationProvider()),
        ChangeNotifierProvider(create: (_) => MapTypeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map App',
      home: LocationInputScreen(),
    );
  }
}
