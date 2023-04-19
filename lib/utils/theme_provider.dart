import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/constants/colors.dart';


final themeProvider = StateNotifierProvider<ThemeProvider, ThemeData>((ref) {
  return ThemeProvider();
});

class ThemeProvider extends StateNotifier<ThemeData> {
  ThemeProvider() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
   
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    
    scaffoldBackgroundColor: deepBlue,
  );

  void toggleTheme() {
    state = state.brightness == Brightness.light ? _darkTheme : _lightTheme;
  }
}
