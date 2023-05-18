import 'package:flutter/material.dart';
import 'package:yts_flutter/extensions/BuildContext.dart';

class UI {
  static final lightTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF526B98),
      useMaterial3: true,
      // Default divider color
      dividerColor: null,
      brightness: Brightness.light);
  static final darkTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF526B98),
      useMaterial3: true,
      // Darker divider color
      dividerColor: Colors.grey.shade800,
      brightness: Brightness.dark);
  static final darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 24, 33, 48),
      Color.fromARGB(255, 74, 91, 130),
    ],
  );
  static final lightCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 56, 78, 115),
      Color.fromARGB(255, 82, 126, 200),
    ],
  );
  static getCardGradient({required BuildContext using}) {
    return using.isDarkMode ? darkCardGradient : lightCardGradient;
  }

  static const PAGE_PADDING = 8.0;
}
