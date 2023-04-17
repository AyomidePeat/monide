import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:road_mechanic/screens/login_screen.dart';
import 'package:road_mechanic/screens/home_screen.dart';
import 'package:road_mechanic/screens/money_trend__list_screen.dart';

Future  main() async {
   await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
        title: 'Monide?',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:   LoginScreen());
  }
}
