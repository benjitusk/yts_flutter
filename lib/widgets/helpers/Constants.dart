import 'package:flutter/material.dart';

class UI {
  static final lightTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF526B98),
      useMaterial3: true,
      brightness: Brightness.light);
  static final darkTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF526B98),
      useMaterial3: true,
      brightness: Brightness.dark);
  static final cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 24, 33, 48),
      Color.fromARGB(255, 74, 91, 130),
    ],
  );
  static const PAGE_PADDING = 8.0;
}
