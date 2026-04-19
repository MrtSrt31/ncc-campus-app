import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  ThemeMode _themeMode;
  bool _onboardingSeen;

  AppSettingsProvider(this._prefs)
      : _themeMode = _parseThemeMode(_prefs.getString('themeMode')),
        _onboardingSeen = _prefs.getBool('onboardingSeen') ?? false;

  ThemeMode get themeMode => _themeMode;
  bool get onboardingSeen => _onboardingSeen;

  bool get isSystemTheme => _themeMode == ThemeMode.system;
  bool get isDarkTheme => _themeMode == ThemeMode.dark;
  bool get isLightTheme => _themeMode == ThemeMode.light;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setString('themeMode', _toStoredValue(mode));
    notifyListeners();
  }

  Future<void> markOnboardingSeen() async {
    if (_onboardingSeen) return;
    _onboardingSeen = true;
    await _prefs.setBool('onboardingSeen', true);
    notifyListeners();
  }

  static ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _toStoredValue(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
