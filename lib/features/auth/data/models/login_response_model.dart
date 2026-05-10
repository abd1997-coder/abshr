import 'dart:convert';
import '../../../../core/errors/exceptions.dart';
import 'customer_model.dart';

class LoginResponseModel {
  LoginResponseModel({
    this.token,
    this.displayName,
    this.success,
    this.otpRequired,
    this.customer,
  });

  final String? token;
  final String? displayName;
  final bool? success;
  final bool? otpRequired;
  final CustomerModel? customer;

  factory LoginResponseModel.fromJson(dynamic data) {
    if (data is! Map) {
      throw const ServerException('Invalid auth response: expected JSON object');
    }
    final map = Map<String, dynamic>.from(data);

    final success = map['success'] as bool? ?? false;

    if (!success && map['token'] == null) {
      throw ServerException(
        map['message'] as String? ?? 
        map['error'] as String? ?? 
        'Authentication failed',
      );
    }

    if (map['token'] == null && success && map['otp_required'] == true) {
      return LoginResponseModel(
        success: success,
        otpRequired: map['otp_required'] as bool? ?? true,
        customer: _parseCustomer(map),
      );
    }

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
      success: success,
      otpRequired: map['otp_required'] as bool? ?? false,
      customer: _parseCustomer(map),
      displayName: _parseDisplayName(map),
    );
  }

  static CustomerModel? _parseCustomer(Map<String, dynamic> map) {
    final customer = map['customer'];
    if (customer is Map) {
      return CustomerModel.fromJson(Map<String, dynamic>.from(customer));
    }
    return null;
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