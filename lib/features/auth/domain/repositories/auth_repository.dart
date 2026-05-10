import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../data/models/login_response_model.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  /// Registers user with phone number. Sends OTP to the phone.
  Future<Either<Failure, void>> registerWithPhone({
    required String firstName,
    required String lastName,
    required String phone,
  });

  /// Sends OTP to phone number for login. Returns LoginResponseModel with otp_required flag.
  Future<Either<Failure, LoginResponseModel>> loginWithPhone(String phone);

  /// Verifies OTP and returns authenticated user with token.
  Future<Either<Failure, User>> verifyOtp({
    required String phone,
    required String otp,
    required bool isLogin,
  });

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, bool>> isAuthenticated();
}
