import 'package:flutter/material.dart';
import 'package:yts_flutter/extensions/BuildContext.dart';
import 'package:yts_flutter/widgets/helpers/slider_padding.dart';

class UI {
  static final lightTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF526B98),
      useMaterial3: true,
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),

      // Default divider color
      dividerColor: null,
      brightness: Brightness.light);
  static final darkTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF526B98),
      useMaterial3: true,
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),

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

  static final lightErrorCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(0xFF, 0xBA, 0x0C, 0x0c),
      Color.fromARGB(255, 0xF2, 0xA3, 0x11),
    ],
  );

  static final darkErrorCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(0xFF, 0x64, 0x04, 0x04),
      Color.fromARGB(255, 0x87, 0x5B, 0x08),
    ],
  );
  static getCardGradient({required BuildContext using}) {
    return using.isDarkMode ? darkCardGradient : lightCardGradient;
  }

  static const PAGE_PADDING = 8.0;
}
