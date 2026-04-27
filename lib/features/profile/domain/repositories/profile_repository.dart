import 'package:dartz/dartz.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, void>> updateProfile(Profile profile);
}
