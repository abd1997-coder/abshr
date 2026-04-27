import 'package:dartz/dartz.dart' as dartz;
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/errors/exceptions.dart';
import 'package:marketplace/core/errors/failures.dart';
import 'package:marketplace/core/utils/storage_service.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final StorageService _storage;

  ProfileRepositoryImpl(this._remoteDataSource, this._storage);

  Future<void> _persistDisplayName(Profile profile) async {
    final n = profile.fullName.trim();
    if (n.isEmpty) return;
    await _storage.setString(AppConstants.userNameKey, n);
  }

  @override
  Future<dartz.Either<Failure, Profile>> getProfile() async {
    try {
      final model = await _remoteDataSource.getProfile();
      await _persistDisplayName(model);
      return dartz.Right(model);
    } on ValidationException catch (e) {
      return dartz.Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return dartz.Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return dartz.Left(NetworkFailure(e.message));
    } catch (e) {
      return dartz.Left(ServerFailure('Failed to load profile: ${e.toString()}'));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> updateProfile(Profile profile) async {
    try {
      final model = ProfileModel(
        fullName: profile.fullName,
        email: profile.email,
        phoneNumber: profile.phoneNumber,
        bio: profile.bio,
        avatarUrl: profile.avatarUrl,
      );
      await _remoteDataSource.updateProfile(model);
      await _persistDisplayName(profile);
      return dartz.Right(null);
    } on ValidationException catch (e) {
      return dartz.Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return dartz.Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return dartz.Left(NetworkFailure(e.message));
    } catch (e) {
      return dartz.Left(
        ServerFailure('Failed to update profile: ${e.toString()}'),
      );
    }
  }
}
