import 'package:dartz/dartz.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/offer.dart';
import '../../domain/entities/seller.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(AppStrings.failedToLoadCategories));
    }
  }

  @override
  Future<Either<Failure, List<Seller>>> getSellers({
    String? q,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final sellers = await _remoteDataSource.getSellers(
        q: q,
        limit: limit,
        offset: offset,
      );
      return Right(sellers);
    } catch (e) {
      return Left(ServerFailure(AppStrings.failedToLoadSellers));
    }
  }

  @override
  Future<Either<Failure, List<Seller>>> getSellersForCollection({
    required String collectionId,
    int limit = 10,
    int offset = 0,
    int sellerLimit = 6,
  }) async {
    try {
      final sellers = await _remoteDataSource.getSellersForCollection(
        collectionId: collectionId,
        limit: limit,
        offset: offset,
        sellerLimit: sellerLimit,
      );
      return Right(sellers);
    } catch (e) {
      return Left(ServerFailure(AppStrings.failedToLoadSellers));
    }
  }

  @override
  Future<Either<Failure, List<Offer>>> getOffers({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final models = await _remoteDataSource.getOffers(
        limit: limit,
        offset: offset,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(AppStrings.failedToLoadOffers));
    }
  }
}
