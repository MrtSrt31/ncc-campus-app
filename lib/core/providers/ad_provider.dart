import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  bool _adsEnabled = true;
  bool _hasChosenAdPreference = false;

  AdProvider(this._prefs) {
    _loadFromPrefs();
  }

  bool get adsEnabled => _adsEnabled;
  bool get hasChosenAdPreference => _hasChosenAdPreference;

  void _loadFromPrefs() {
    _adsEnabled = _prefs.getBool('adsEnabled') ?? true;
    _hasChosenAdPreference = _prefs.getBool('hasChosenAdPreference') ?? false;
  }

  Future<void> setAdsEnabled(bool enabled) async {
    _adsEnabled = enabled;
    _hasChosenAdPreference = true;
    await _prefs.setBool('adsEnabled', enabled);
    await _prefs.setBool('hasChosenAdPreference', true);
    notifyListeners();
  }

  bool shouldShowBanner() {
    return _adsEnabled;
  }

  bool shouldShowInterstitial() {
    return _adsEnabled;
  }
}
