import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// Clears all stored preferences and in-memory image cache. Restores only
  /// locale and onboarding completion so the app language and first-run flow stay intact.
  Future<void> clearSessionDataPreservingLocaleAndOnboarding() async {
    final lang = _prefs.getString(AppConstants.languagePreferenceKey);
    final onboarding = _prefs.getBool(AppConstants.onboardingCompletedKey);

    await _prefs.clear();

    if (lang != null) {
      await _prefs.setString(AppConstants.languagePreferenceKey, lang);
    }
    if (onboarding != null) {
      await _prefs.setBool(AppConstants.onboardingCompletedKey, onboarding);
    }

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
