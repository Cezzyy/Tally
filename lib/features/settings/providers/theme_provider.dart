import 'package:flutter/material.dart' hide ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart' as material show ThemeMode;

part 'theme_provider.g.dart';

@riverpod
class ThemeMode extends _$ThemeMode {
  static const String _themeModeKey = 'theme_mode';

  @override
  ThemeModeEnum build() {
    _loadThemeMode();
    return ThemeModeEnum.system;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);

    if (themeModeString != null) {
      state = ThemeModeEnum.values.firstWhere(
        (mode) => mode.name == themeModeString,
        orElse: () => ThemeModeEnum.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeModeEnum mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeModeEnum.light
        ? ThemeModeEnum.dark
        : ThemeModeEnum.light;
    await setThemeMode(newMode);
  }
}

enum ThemeModeEnum {
  light,
  dark,
  system;

  material.ThemeMode toThemeMode() {
    switch (this) {
      case ThemeModeEnum.light:
        return material.ThemeMode.light;
      case ThemeModeEnum.dark:
        return material.ThemeMode.dark;
      case ThemeModeEnum.system:
        return material.ThemeMode.system;
    }
  }

  String get displayName {
    switch (this) {
      case ThemeModeEnum.light:
        return 'Light';
      case ThemeModeEnum.dark:
        return 'Dark';
      case ThemeModeEnum.system:
        return 'System';
    }
  }

  IconData get icon {
    switch (this) {
      case ThemeModeEnum.light:
        return Icons.light_mode;
      case ThemeModeEnum.dark:
        return Icons.dark_mode;
      case ThemeModeEnum.system:
        return Icons.brightness_auto;
    }
  }
}
