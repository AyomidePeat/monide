import 'package:flutter/material.dart';
import 'package:road_mechanic/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
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
      home: const LoginScreen()
    );
  }
}

