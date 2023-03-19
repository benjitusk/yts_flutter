import 'package:flutter/material.dart';

ThemeData generateTheme(BuildContext ctx) {
  ThemeData theme = ThemeData();
  theme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
    primary: const Color(0xFF526B98),
    secondary: const Color(0xFFFCC730),
  ));
  theme = theme.copyWith(indicatorColor: theme.colorScheme.secondary);
  return theme;
}
