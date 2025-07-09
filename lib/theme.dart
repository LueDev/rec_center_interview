// GENERATED THEME CONFIG USING APP SETTINGS
import 'package:flutter/material.dart';
import 'settings.dart';

/// Creates a ThemeData from the [AppSettings] for the given [brightness].
ThemeData createTheme(AppSettings s, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: s.seedColor,
    brightness: brightness,
  );

  final textTheme = ThemeData(brightness: brightness).textTheme;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: textTheme,
    fontFamily: s.fontFamily == 'System' ? null : s.fontFamily,
    scaffoldBackgroundColor: scheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
