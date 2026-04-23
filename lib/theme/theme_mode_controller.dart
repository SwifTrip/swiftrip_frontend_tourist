import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController extends ValueNotifier<ThemeMode> {
  ThemeModeController(super.value);

  static const String _themeModeKey = 'swiftrip_theme_mode';

  static Future<ThemeMode> loadInitialMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModeKey);

    if (stored == ThemeMode.dark.name) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  Future<void> toggleMode() async {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, value.name);
  }
}

class ThemeModeProvider extends InheritedNotifier<ThemeModeController> {
  const ThemeModeProvider({
    super.key,
    required ThemeModeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeModeController of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ThemeModeProvider>();
    if (provider == null || provider.notifier == null) {
      throw FlutterError('ThemeModeProvider not found in widget tree.');
    }
    return provider.notifier!;
  }
}
