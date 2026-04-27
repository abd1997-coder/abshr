import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/storage_service.dart';
import '../../domain/entities/user.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> register(
    String email,
    String password,
    String firstName,
    String lastName,
  );

  /// Sends OTP to [phoneNumber]. Returns verificationId to use in verifyOtp.
  Future<String> sendOtp(String phoneNumber);

  /// Verifies OTP and returns signed-in user. [verificationId] from sendOtp.
  /// If [verificationId] is AUTO_VERIFIED (auto-retrieve on device), pass any [smsCode].
  Future<User> verifyOtp(String verificationId, String smsCode);

  /// Returns current Firebase user as [User] if signed in (e.g. after auto-verify).
  Future<User?> getFirebaseCurrentUser();
}

/// Implementation: login/register via API; Firebase Phone Auth for OTP.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final StorageService _storage;

  static const String _mobileAuthPath = '/store/mobile/auth';

  static Map<String, dynamic> _mobileAuthBody({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  static ({String first, String last}) _splitFullName(String name) {
    final t = name.trim();
    if (t.isEmpty) return (first: '', last: '');
    final parts = t.split(RegExp(r'\s+'));
    if (parts.length == 1) return (first: parts[0], last: '');
    return (first: parts.first, last: parts.sublist(1).join(' '));
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final trimmedEmail = email.trim();
      final storedEmail =
          _storage.getString(AppConstants.userEmailKey)?.trim() ?? '';
      final storedName = _storage.getString(AppConstants.userNameKey) ?? '';
      final nameParts =
          (storedEmail.isNotEmpty &&
                  storedEmail.toLowerCase() == trimmedEmail.toLowerCase())
              ? _splitFullName(storedName)
              : (first: 'test', last: 'test');
      final response = await _apiClient.post(
        _mobileAuthPath,
        data: _mobileAuthBody(
          email: trimmedEmail,
          password: password,
          firstName: nameParts.first.isEmpty ? "test" : nameParts.first,
          lastName: nameParts.last.isEmpty ? "test" : nameParts.last,
        ),
      );
      final login = LoginResponseModel.fromJson(response.data);
      final idFromJwt = LoginResponseModel.userIdFromJwt(login.token);
      final id =
          (idFromJwt != null && idFromJwt.isNotEmpty)
              ? idFromJwt
              : trimmedEmail;
      final sameEmailAsStored =
          storedEmail.isNotEmpty &&
          storedEmail.toLowerCase() == trimmedEmail.toLowerCase();
      final fromStored =
          sameEmailAsStored && storedName.trim().isNotEmpty
              ? storedName.trim()
              : null;
      final fromApi = login.displayName?.trim();
      final fromJwt = LoginResponseModel.nameFromJwt(login.token)?.trim();
      final resolvedName =
          fromStored ??
          (fromApi != null && fromApi.isNotEmpty ? fromApi : null) ??
          (fromJwt != null && fromJwt.isNotEmpty ? fromJwt : null);
      return UserModel(
        id: id,
        email: trimmedEmail,
        name: resolvedName,
        token: login.token,
      );
    } on DioException catch (e) {
      if (e.error is ValidationException ||
          e.error is ServerException ||
          e.error is NetworkException) {
        throw e.error as Exception;
      }
      rethrow;
    }
  }

  @override
  Future<User> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final trimmedEmail = email.trim();
      final fn = firstName.trim();
      final ln = lastName.trim();
      final trimmedName = '$fn $ln'.trim();
      final response = await _apiClient.post(
        _mobileAuthPath,
        data: _mobileAuthBody(
          email: trimmedEmail,
          password: password,
          firstName: fn,
          lastName: ln,
        ),
      );
      final login = LoginResponseModel.fromJson(response.data);
      final idFromJwt = LoginResponseModel.userIdFromJwt(login.token);
      final id =
          (idFromJwt != null && idFromJwt.isNotEmpty)
              ? idFromJwt
              : trimmedEmail;
      final fromApi = login.displayName?.trim();
      final fromJwt = LoginResponseModel.nameFromJwt(login.token)?.trim();
      final resolvedName =
          trimmedName.isNotEmpty
              ? trimmedName
              : (fromApi != null && fromApi.isNotEmpty ? fromApi : null) ??
                  (fromJwt != null && fromJwt.isNotEmpty ? fromJwt : null);
      return UserModel(
        id: id,
        email: trimmedEmail,
        name: resolvedName,
        token: login.token,
      );
    } on DioException catch (e) {
      if (e.error is ValidationException ||
          e.error is ServerException ||
          e.error is NetworkException) {
        throw e.error as Exception;
      }
      rethrow;
    }
  }

  @override
  Future<String> sendOtp(String phoneNumber) async {
    final completer = Completer<String>();
    final auth = fa.FirebaseAuth.instance;

    await fa.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _normalizePhone(phoneNumber),
      verificationCompleted: (fa.PhoneAuthCredential credential) async {
        if (!completer.isCompleted) {
          await auth.signInWithCredential(credential);
          completer.complete('AUTO_VERIFIED');
        }
      },
      verificationFailed: (fa.FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
      timeout: const Duration(seconds: 120),
    );

    return completer.future;
  }

  static const String autoVerifiedId = 'AUTO_VERIFIED';

  @override
  Future<User> verifyOtp(String verificationId, String smsCode) async {
    if (verificationId == autoVerifiedId) {
      final user = await getFirebaseCurrentUser();
      if (user != null) return user;
      throw fa.FirebaseAuthException(
        code: 'no-user',
        message: 'Auto-verify: no current user',
      );
    }
    final credential = fa.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
    );
    final userCredential = await fa.FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw fa.FirebaseAuthException(
        code: 'no-user',
        message: 'Sign in failed: no user returned',
      );
    }
    final phone = firebaseUser.phoneNumber ?? '';
    return _firebaseUserToUser(firebaseUser, phone);
  }

  @override
  Future<User?> getFirebaseCurrentUser() async {
    final firebaseUser = fa.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;
    return _firebaseUserToUser(
      firebaseUser,
      firebaseUser.phoneNumber ?? firebaseUser.email ?? '',
    );
  }

  static String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.startsWith('+')) return digits;
    if (digits.length >= 10) return '+1$digits'; // assume US if 10+ digits
    return '+$digits';
  }

  static User _firebaseUserToUser(fa.User firebaseUser, String phoneOrEmail) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.phoneNumber ?? firebaseUser.email ?? phoneOrEmail,
      name: firebaseUser.displayName,
      token: firebaseUser.uid,
    );
  }
}
