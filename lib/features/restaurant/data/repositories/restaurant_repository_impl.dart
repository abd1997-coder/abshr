import 'package:dartz/dartz.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../../domain/entities/restaurant_detail.dart';
import '../../domain/entities/seller_products_page.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource _remoteDataSource;

  RestaurantRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, RestaurantDetail?>> getRestaurantDetail(
    String id,
    String name,
  ) async {
    try {
      final detail = await _remoteDataSource.getRestaurantDetail(id, name);
      return Right(detail);
    } catch (e) {
      return Left(ServerFailure(AppStrings.failedToLoadRestaurant));
    }
  }

  @override
  Future<Either<Failure, SellerProductsPageResult>> getSellerProducts(
    String sellerId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final page = await _remoteDataSource.getSellerProducts(
        sellerId,
        limit: limit,
        offset: offset,
      );
      return Right(page);
    } catch (e) {
      return Left(ServerFailure(AppStrings.failedToLoadSellers));
    }
  }
}
