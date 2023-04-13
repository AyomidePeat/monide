import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/screens/login_screen.dart';
import 'package:road_mechanic/screens/map_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monide?',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen()
    );
  }
}

