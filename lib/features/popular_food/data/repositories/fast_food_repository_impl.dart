import 'package:dartz/dartz.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/errors/failures.dart';
import 'package:marketplace/features/popular_food/data/datasources/fast_food_local_data_source.dart';
import 'package:marketplace/features/popular_food/data/datasources/fast_food_remote_data_source.dart';
import 'package:marketplace/features/popular_food/domain/entities/fast_food_item.dart';
import 'package:marketplace/features/popular_food/domain/entities/restaurant_entity.dart';
import 'package:marketplace/features/popular_food/domain/repositories/fast_food_repository.dart';

class FastFoodRepositoryImpl implements FastFoodRepository {
  final FastFoodRemoteDataSource remoteDataSource;
  final FastFoodLocalDataSource localDataSource;

  FastFoodRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<FastFoodItemEntity>>> getPopularItems() async {
    try {
      final remoteItems = await remoteDataSource.getPopularItems();
      await localDataSource.cachePopularItems(remoteItems);
      return Right(remoteItems);
    } catch (e) {
      try {
        final localItems = await localDataSource.getCachedPopularItems();
        return Right(localItems);
      } catch (_) {
        return Left(CacheFailure(AppStrings.failedToLoadSellers));
      }
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getOpenRestaurants() async {
    try {
      final remoteRestaurants = await remoteDataSource.getOpenRestaurants();
      await localDataSource.cacheOpenRestaurants(remoteRestaurants);
      return Right(remoteRestaurants);
    } catch (e) {
      try {
        final localRestaurants =
            await localDataSource.getCachedOpenRestaurants();
        return Right(localRestaurants);
      } catch (_) {
        return Left(CacheFailure(AppStrings.failedToLoadSellers));
      }
    }
  }

  @override
  Future<Either<Failure, List<FastFoodItemEntity>>> searchFastFood(
    String query,
  ) async {
    try {
      final results = await remoteDataSource.searchFastFood(query);
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(AppStrings.failedToLoadSellers));
    }
  }
}
