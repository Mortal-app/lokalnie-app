import 'package:flutter/material.dart';

enum AppThemePreference { light, dark, system }

extension AppThemePreferenceX on AppThemePreference {
  ThemeMode get themeMode => switch (this) {
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
    AppThemePreference.system => ThemeMode.system,
  };

  bool get isDarkMode => this == AppThemePreference.dark;

  String get storageName => name;

  static AppThemePreference fromStorage(String? value, {required bool isDarkMode}) {
    return switch (value) {
      'dark' => AppThemePreference.dark,
      'system' => AppThemePreference.system,
      'light' => AppThemePreference.light,
      _ => isDarkMode ? AppThemePreference.dark : AppThemePreference.light,
    };
  }
}
