import 'package:dartz/dartz.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/fast_food_repository.dart';

class GetOpenRestaurantsUsecase {
  final FastFoodRepository repository;

  GetOpenRestaurantsUsecase(this.repository);

  Future<Either<Failure, List<RestaurantEntity>>> call() {
    return repository.getOpenRestaurants();
  }
}
