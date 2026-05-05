import 'package:flutter/material.dart' as material show ThemeMode;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tally/features/settings/providers/theme_provider.dart';

void main() {
  group('ThemeModeEnum', () {
    test('toThemeMode converts light correctly', () {
      expect(ThemeModeEnum.light.toThemeMode(), material.ThemeMode.light);
    });

    test('toThemeMode converts dark correctly', () {
      expect(ThemeModeEnum.dark.toThemeMode(), material.ThemeMode.dark);
    });

    test('toThemeMode converts system correctly', () {
      expect(ThemeModeEnum.system.toThemeMode(), material.ThemeMode.system);
    });

    test('displayName returns correct values', () {
      expect(ThemeModeEnum.light.displayName, 'Light');
      expect(ThemeModeEnum.dark.displayName, 'Dark');
      expect(ThemeModeEnum.system.displayName, 'System');
    });

    test('icon returns correct icons', () {
      expect(ThemeModeEnum.light.icon, Icons.light_mode);
      expect(ThemeModeEnum.dark.icon, Icons.dark_mode);
      expect(ThemeModeEnum.system.icon, Icons.brightness_auto);
    });

    test('enum has correct name values', () {
      expect(ThemeModeEnum.light.name, 'light');
      expect(ThemeModeEnum.dark.name, 'dark');
      expect(ThemeModeEnum.system.name, 'system');
    });

    test('all enum values are present', () {
      expect(ThemeModeEnum.values.length, 3);
      expect(ThemeModeEnum.values, contains(ThemeModeEnum.light));
      expect(ThemeModeEnum.values, contains(ThemeModeEnum.dark));
      expect(ThemeModeEnum.values, contains(ThemeModeEnum.system));
    });
  });

  group('ThemeMode Provider', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is system', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeMode = container.read(themeModeProvider);
      expect(themeMode, ThemeModeEnum.system);
    });

    test('setThemeMode updates state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setThemeMode(ThemeModeEnum.dark);

      expect(container.read(themeModeProvider), ThemeModeEnum.dark);
    });

    test('setThemeMode persists to SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setThemeMode(ThemeModeEnum.light);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'light');
    });

    test('toggleTheme switches from light to dark', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setThemeMode(ThemeModeEnum.light);
      await notifier.toggleTheme();

      expect(container.read(themeModeProvider), ThemeModeEnum.dark);
    });

    test('toggleTheme switches from dark to light', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setThemeMode(ThemeModeEnum.dark);
      await notifier.toggleTheme();

      expect(container.read(themeModeProvider), ThemeModeEnum.light);
    });

    test('toggleTheme switches from system to light', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);

      // Initial state is system
      await notifier.toggleTheme();

      expect(container.read(themeModeProvider), ThemeModeEnum.light);
    });

    test('loads saved theme mode from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Create a listener to track state changes
      ThemeModeEnum? finalState;
      container.listen<ThemeModeEnum>(themeModeProvider, (previous, next) {
        finalState = next;
      }, fireImmediately: true);

      // Wait for the async load to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Now it should be loaded
      expect(finalState, ThemeModeEnum.dark);
      expect(container.read(themeModeProvider), ThemeModeEnum.dark);
    });

    test('handles invalid saved theme mode gracefully', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'invalid'});

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Read the provider
      expect(container.read(themeModeProvider), ThemeModeEnum.system);

      // Wait for async load
      await Future.delayed(const Duration(milliseconds: 100));

      // Should remain system when invalid value is found
      expect(container.read(themeModeProvider), ThemeModeEnum.system);
    });

    test('handles missing theme mode in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Read the provider
      expect(container.read(themeModeProvider), ThemeModeEnum.system);

      // Wait for async load
      await Future.delayed(const Duration(milliseconds: 100));

      // Should remain system when no saved value
      expect(container.read(themeModeProvider), ThemeModeEnum.system);
    });

    test('multiple setThemeMode calls update correctly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setThemeMode(ThemeModeEnum.light);
      expect(container.read(themeModeProvider), ThemeModeEnum.light);

      await notifier.setThemeMode(ThemeModeEnum.dark);
      expect(container.read(themeModeProvider), ThemeModeEnum.dark);

      await notifier.setThemeMode(ThemeModeEnum.system);
      expect(container.read(themeModeProvider), ThemeModeEnum.system);
    });

    test('persists each theme mode correctly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);
      final prefs = await SharedPreferences.getInstance();

      await notifier.setThemeMode(ThemeModeEnum.light);
      expect(prefs.getString('theme_mode'), 'light');

      await notifier.setThemeMode(ThemeModeEnum.dark);
      expect(prefs.getString('theme_mode'), 'dark');

      await notifier.setThemeMode(ThemeModeEnum.system);
      expect(prefs.getString('theme_mode'), 'system');
    });
  });
}
