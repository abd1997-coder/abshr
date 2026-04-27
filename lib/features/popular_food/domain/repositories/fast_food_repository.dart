import 'package:dartz/dartz.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../entities/fast_food_item.dart';
import '../entities/restaurant_entity.dart';

abstract class FastFoodRepository {
  Future<Either<Failure, List<FastFoodItemEntity>>> getPopularItems();
  Future<Either<Failure, List<RestaurantEntity>>> getOpenRestaurants();
  Future<Either<Failure, List<FastFoodItemEntity>>> searchFastFood(
    String query,
  );
}
