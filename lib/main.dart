import 'package:flutter/material.dart';
import 'package:map_flutter_app/screens/location_input%20_screen.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Map App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LocationInputScreen(),
      ),
    );
  }
}
