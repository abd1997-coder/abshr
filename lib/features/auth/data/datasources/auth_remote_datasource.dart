import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/storage_service.dart';
import '../../domain/entities/user.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Registers user with phone number. Returns success message or throws.
  Future<void> registerWithPhone({
    required String firstName,
    required String lastName,
    required String phone,
  });

  /// Sends OTP to [phoneNumber] for login.
  /// Returns LoginResponseModel with otp_required flag.
  Future<LoginResponseModel> sendOtp(String phoneNumber);

  /// Verifies OTP and returns authenticated user with token.
  Future<User> verifyOtp({
    required String phone,
    required String otp,
    required bool isLogin,
  });

  /// Returns cached user if available.
  Future<User?> getCachedUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final StorageService _storage;

  static const String _phoneRegisterPath = '/store/mobile/auth/phone/register';
  static const String _phoneLoginPath = '/store/mobile/auth/phone/login';
  static const String _phoneLoginVerifyPath =
      '/store/mobile/auth/phone/login/verify';
  static const String _phoneRegisterVerifyPath =
      '/store/mobile/auth/phone/verify';

  @override
  Future<void> registerWithPhone({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      await _apiClient.post(
        _phoneRegisterPath,
        data: {
          'first_name': firstName.trim(),
          'last_name': lastName.trim(),
          'phone': phone.trim(),
        },
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
  Future<LoginResponseModel> sendOtp(String phoneNumber) async {
    try {
      final response = await _apiClient.post(
        _phoneLoginPath,
        data: {'phone': phoneNumber.trim()},
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);
      return loginResponse;
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
  Future<User> verifyOtp({
    required String phone,
    required String otp,
    required bool isLogin,
  }) async {
    try {
      final response = await _apiClient.post(
        isLogin ? _phoneLoginVerifyPath : _phoneRegisterVerifyPath,
        data: {'phone': phone.trim(), 'otp': otp.trim()},
      );

      final login = LoginResponseModel.fromJson(response.data);

      if (login.token == null || login.token!.isEmpty) {
        throw const ServerException('Invalid auth response: no token');
      }

      final idFromJwt = LoginResponseModel.userIdFromJwt(login.token!);
      final id =
          (idFromJwt != null && idFromJwt.isNotEmpty) ? idFromJwt : phone;

      final fromApi = login.displayName?.trim();
      final fromJwt = LoginResponseModel.nameFromJwt(login.token!)?.trim();
      final resolvedName =
          (fromApi != null && fromApi.isNotEmpty ? fromApi : null) ??
          (fromJwt != null && fromJwt.isNotEmpty ? fromJwt : null);

      final customer = login.customer;
      String email;
      String? name;
      if (customer != null) {
        email = customer.email.isNotEmpty ? customer.email : phone;
        name = customer.name ?? resolvedName;
      } else {
        email = phone;
        name = resolvedName;
      }

      await _cacheUserData(login);

      return UserModel(id: id, email: email, name: name, token: login.token);
    } on DioException catch (e) {
      if (e.error is ValidationException ||
          e.error is ServerException ||
          e.error is NetworkException) {
        throw e.error as Exception;
      }
      rethrow;
    }
  }

  Future<void> _cacheUserData(LoginResponseModel login) async {
    if (login.token != null && login.token!.isNotEmpty) {
      await _storage.setString(AppConstants.authTokenKey, login.token!);
    }

    if (login.customer != null) {
      await _storage.setString(AppConstants.userIdKey, login.customer!.id);
      if (login.customer!.email.isNotEmpty) {
        await _storage.setString(
          AppConstants.userEmailKey,
          login.customer!.email,
        );
      }
      if (login.customer!.name != null) {
        await _storage.setString(
          AppConstants.userNameKey,
          login.customer!.name!,
        );
      }
    }
  }

  @override
  Future<User?> getCachedUser() async {
    final id = _storage.getString(AppConstants.userIdKey);
    final token = _storage.getString(AppConstants.authTokenKey);
    final name = _storage.getString(AppConstants.userNameKey);
    final email = _storage.getString(AppConstants.userEmailKey);

    if (id != null && token != null && token.isNotEmpty) {
      return UserModel(id: id, email: email ?? '', name: name, token: token);
    }
    return null;
  }
}
