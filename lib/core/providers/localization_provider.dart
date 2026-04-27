import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LocalizationProvider extends ChangeNotifier {
  static const String _languageKey = AppConstants.languagePreferenceKey;
  static const String _enLocale = 'en';
  static const String _arLocale = 'ar';

  late SharedPreferences _prefs;
  late String _currentLocale;

  String get currentLocale => _currentLocale;

  bool get isArabic => _currentLocale == _arLocale;

  LocalizationProvider() {
    _currentLocale = _arLocale;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _currentLocale = _prefs.getString(_languageKey) ?? _arLocale;
    Intl.defaultLocale = _currentLocale;
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != _currentLocale) {
      _currentLocale = languageCode;
      Intl.defaultLocale = languageCode;
      await _prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }

  Future<void> toggleLanguage() async {
    final newLanguage = isArabic ? _enLocale : _arLocale;
    await setLanguage(newLanguage);
  }

  Locale getLocale() {
    return Locale(_currentLocale);
  }
}
