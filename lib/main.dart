import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:road_mechanic/screens/login_screen.dart';
import 'package:road_mechanic/screens/home_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String originString = '37.7749,-122.4194'; // San Francisco, CA
    String destinationString = '34.0522,-118.2437'; // Los Angeles, CA

    List<String> originCoords = originString.split(',');
    List<String> destinationCoords = destinationString.split(',');

    double originLat = double.parse(originCoords[0]);
    double originLng = double.parse(originCoords[1]);
    double destinationLat = double.parse(destinationCoords[0]);
    double destinationLng = double.parse(destinationCoords[1]);

    LatLng origin = LatLng(originLat, originLng);
    LatLng destination = LatLng(destinationLat, destinationLng);

    return MaterialApp(
        title: 'Monide?',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen());
  }
}
