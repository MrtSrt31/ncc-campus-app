import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  Locale _locale;

  LocaleProvider(this._prefs)
      : _locale = Locale(_prefs.getString('locale') ?? 'tr');

  Locale get locale => _locale;
  bool get isTr => _locale.languageCode == 'tr';

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    setLocale(isTr ? const Locale('en') : const Locale('tr'));
  }
}
