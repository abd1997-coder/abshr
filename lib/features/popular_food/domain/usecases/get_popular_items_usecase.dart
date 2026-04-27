import 'package:dartz/dartz.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../entities/fast_food_item.dart';
import '../repositories/fast_food_repository.dart';

class GetPopularItemsUsecase {
  final FastFoodRepository repository;

  GetPopularItemsUsecase(this.repository);

  Future<Either<Failure, List<FastFoodItemEntity>>> call() {
    return repository.getPopularItems();
  }
}
