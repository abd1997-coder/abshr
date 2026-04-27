import 'dart:convert';

import '../../../../core/errors/exceptions.dart';

/// `POST /store/mobile/auth` — at minimum `{ "token": "<jwt>" }`; may include
/// `customer` or name fields used for local display name.
class LoginResponseModel {
  LoginResponseModel({required this.token, this.displayName});

  final String token;

  /// Best-effort full name from response body (not from JWT).
  final String? displayName;

  factory LoginResponseModel.fromJson(dynamic data) {
    if (data is! Map) {
      throw const ServerException('Invalid auth response: expected JSON object');
    }
    final map = Map<String, dynamic>.from(data);
    final raw = map['token'];
    if (raw == null) {
      throw const ServerException('Invalid auth response: no token');
    }
    final token = raw is String ? raw : raw.toString();
    if (token.isEmpty) {
      throw const ServerException('Invalid auth response: empty token');
    }
    return LoginResponseModel(
      token: token,
      displayName: _parseDisplayName(map),
    );
  }

  static String? _stringOf(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    return v.toString();
  }

  static String? _parseDisplayName(Map<String, dynamic> map) {
    String? joinNames(String? a, String? b) {
      final x = (a ?? '').trim();
      final y = (b ?? '').trim();
      if (x.isEmpty && y.isEmpty) return null;
      if (x.isEmpty) return y;
      if (y.isEmpty) return x;
      return '$x $y';
    }

    final customer = map['customer'];
    if (customer is Map) {
      final c = Map<String, dynamic>.from(customer);
      final combined = joinNames(
        _stringOf(c['first_name'] ?? c['firstName']),
        _stringOf(c['last_name'] ?? c['lastName']),
      );
      if (combined != null && combined.isNotEmpty) return combined;
      final full = _stringOf(c['name'] ?? c['full_name'] ?? c['fullName']);
      if (full != null && full.trim().isNotEmpty) return full.trim();
    }

    final rootCombined = joinNames(
      _stringOf(map['first_name'] ?? map['firstName']),
      _stringOf(map['last_name'] ?? map['lastName']),
    );
    if (rootCombined != null && rootCombined.isNotEmpty) return rootCombined;

    final single = _stringOf(map['name'] ?? map['full_name'] ?? map['fullName']);
    if (single != null && single.trim().isNotEmpty) return single.trim();
    return null;
  }

  /// Best-effort id from JWT payload (`actor_id`, then `auth_identity_id`). No signature verify.
  static String? userIdFromJwt(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;
      final normalized = base64Url.normalize(parts[1]);
      final jsonStr = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(jsonStr);
      if (map is! Map) return null;
      final actor = map['actor_id'];
      if (actor is String && actor.isNotEmpty) return actor;
      final authId = map['auth_identity_id'];
      if (authId is String && authId.isNotEmpty) return authId;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Optional `name` / `first_name`+`last_name` claims in JWT payload.
  static String? nameFromJwt(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;
      final normalized = base64Url.normalize(parts[1]);
      final jsonStr = utf8.decode(base64Url.decode(normalized));
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map) return null;
      final map = Map<String, dynamic>.from(decoded);
      final direct = _stringOf(map['name'] ?? map['full_name']);
      if (direct != null && direct.trim().isNotEmpty) return direct.trim();
      final fn = _stringOf(
        map['first_name'] ?? map['given_name'],
      );
      final ln = _stringOf(
        map['last_name'] ?? map['family_name'],
      );
      final combined = '${fn ?? ''} ${ln ?? ''}'.trim();
      if (combined.isNotEmpty) return combined;
      return null;
    } catch (_) {
      return null;
    }
  }
}
