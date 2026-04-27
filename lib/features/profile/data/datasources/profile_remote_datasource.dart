import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  static const String _mobileProfilePath = '/store/mobile/profile';

  static Map<String, dynamic> _unwrapProfileRoot(Map<String, dynamic> data) {
    final customer = data['customer'];
    if (customer is Map<String, dynamic>) {
      return Map<String, dynamic>.from(customer);
    }
    final profile = data['profile'];
    if (profile is Map<String, dynamic>) {
      return Map<String, dynamic>.from(profile);
    }
    return data;
  }

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _apiClient.get(_mobileProfilePath);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw ServerException('Invalid profile response');
      }
      final map = _unwrapProfileRoot(data);
      return ProfileModel.fromMobileProfileJson(map);
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
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      await _apiClient.put(
        _mobileProfilePath,
        data: profile.toMobileUpdateBody(),
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
}
