import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(
    String email,
    String password,
    String firstName,
    String lastName,
  );
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, bool>> isAuthenticated();
  /// Sends OTP to [phoneNumber]. Returns verificationId for verifyOtp.
  Future<Either<Failure, String>> sendOtp(String phoneNumber);
  /// Verifies OTP and signs in. Returns authenticated user.
  Future<Either<Failure, User>> verifyOtp(String verificationId, String smsCode);
}
