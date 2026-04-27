import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import '../../../cart/domain/repositories/cart_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

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
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await _remoteDataSource.login(email, password);
      await _localDataSource.cacheUser(user);
      return Right(user);
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
  Future<Either<Failure, User>> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final user = await _remoteDataSource.register(
        email,
        password,
        firstName,
        lastName,
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
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      try {
        await fa.FirebaseAuth.instance.signOut();
      } catch (_) {}
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

  @override
  Future<Either<Failure, String>> sendOtp(String phoneNumber) async {
    try {
      final verificationId = await _remoteDataSource.sendOtp(phoneNumber);
      return Right(verificationId);
    } on fa.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        AuthFailure('Failed to send OTP: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final user = await _remoteDataSource.verifyOtp(verificationId, smsCode);
      await _localDataSource.cacheUser(user);
      return Right(user);
    } on fa.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
        AuthFailure('Verification failed: ${e.toString()}'),
      );
    }
  }
}
