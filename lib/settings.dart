import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable value object containing all configurable UI settings.
class AppSettings {
  const AppSettings({
    this.mode = ThemeMode.light,
    this.seedColor = Colors.indigo,
    this.textScaleFactor = 1.0,
    this.fontFamily = 'Sans',
  });

  final ThemeMode mode;
  final Color seedColor;
  final double textScaleFactor;
  final String fontFamily;

  AppSettings copyWith({
    ThemeMode? mode,
    Color? seedColor,
    double? textScaleFactor,
    String? fontFamily,
  }) {
    return AppSettings(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}

/// StateNotifier that owns and mutates [AppSettings].
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());

  void toggleMode() {
    final next =
        state.mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(mode: next);

    // No additional actions required – UI rebuild will propagate mode.
  }

  void setSeedColor(Color color) => state = state.copyWith(seedColor: color);

  void setTextScale(double factor) =>
      state = state.copyWith(textScaleFactor: factor.clamp(0.8, 1.3));

  void setFontFamily(String family) {
    // TODO(Interview): Update state with new font family.
  }
}

/// Global provider for [AppSettings].
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  return SettingsNotifier();
});
