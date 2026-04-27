import '../../domain/entities/user.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(User user);
  Future<User?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  @override
  Future<void> cacheUser(User user) async {
    try {
      await _storageService.setString(AppConstants.userIdKey, user.id);
      await _storageService.setString(AppConstants.authTokenKey, user.token ?? '');
      await _storageService.setString(AppConstants.userEmailKey, user.email);
      await _storageService.setString(AppConstants.userNameKey, user.name ?? '');
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      final userId = _storageService.getString(AppConstants.userIdKey);
      final token = _storageService.getString(AppConstants.authTokenKey);

      if (userId == null || token == null || token.isEmpty) {
        return null;
      }

      final email = _storageService.getString(AppConstants.userEmailKey) ?? '';
      final nameStr = _storageService.getString(AppConstants.userNameKey);
      final name = (nameStr != null && nameStr.isNotEmpty) ? nameStr : null;

      return UserModel(
        id: userId,
        email: email,
        name: name,
        token: token,
      );
    } catch (e) {
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storageService.clearSessionDataPreservingLocaleAndOnboarding();
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
