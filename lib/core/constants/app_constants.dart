import 'package:flutter/material.dart';

class AppConstants {
  // Theme
  static const Color primaryColor = Color(0xFFFF5000);

  // API
  static const String baseUrl = 'https://api.abshr-store.com';
  // image base url 

  /// Default seller handle for GET /store/seller/{seller_handle}
  static const String defaultSellerHandle = 'default';

  /// Default country for GET /store/products (country_code)
  static const String defaultCountryCode = 'us';

  /// Fixed shipping option for `POST /store/mobile/checkout`.
  static const String defaultMobileShippingOptionId =
      'so_01KM9207RTZZWNZC2E9BHKBEJ7';

  // Storage Keys
  /// App locale (`en` / `ar`); same as [LocalizationProvider] preference.
  static const String languagePreferenceKey = 'language';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String cartIdKey = 'cart_id';

  /// JSON array of strings: recent search queries on the search screen.
  static const String searchRecentKeywordsKey = 'search_recent_keywords';

  /// Local preference: `id` of the address to prefill checkout (mobile API has no default endpoint).
  static const String defaultShippingAddressIdKey =
      'default_shipping_address_id';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // publishableApiKey
  static const String publishableApiKey =
      'pk_2dc8761d3b5fe16f22be066f705cf8ee94f9e28f13df8d5b1963acbeb6d3c700';

  /// Shown in the support chip (local format).
  static const String supportWhatsAppDisplay = '0965695982';

  /// Digits only for `https://wa.me/` (E.164 without +). Syria +963 from local `09…`.
  static const String supportWhatsAppWaMeDigits = '963965695982';
}
