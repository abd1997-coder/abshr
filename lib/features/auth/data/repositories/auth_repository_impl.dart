import 'package:dartz/dartz.dart';
import '../../../cart/domain/repositories/cart_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final CartRepository _cartRepository;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._cartRepository,
  );

  @override
  Future<Either<Failure, void>> registerWithPhone({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      await _remoteDataSource.registerWithPhone(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> loginWithPhone(
    String phone,
  ) async {
    try {
      final response = await _remoteDataSource.sendOtp(phone);
      return Right(response);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to send OTP: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String phone,
    required String otp,
    required bool isLogin,
  }) async {
    try {
      final user = await _remoteDataSource.verifyOtp(
        phone: phone,
        otp: otp,
        isLogin: isLogin,
      );
      await _localDataSource.cacheUser(user);
      return Right(user);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Verification failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearCache();
      await _cartRepository.ensureCart();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to logout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getCachedUser();
      if (user != null) {
        return Right(user);
      }
      return Left(CacheFailure('No cached user found'));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final user = await _localDataSource.getCachedUser();
      final isAuth =
          user != null && user.token != null && user.token!.isNotEmpty;
      return Right(isAuth);
    } catch (e) {
      return const Right(false);
    }
  }
}
