import 'package:equatable/equatable.dart';
import 'package:marketplace/features/popular_food/domain/entities/fast_food_item.dart';
import 'package:marketplace/features/popular_food/domain/entities/restaurant_entity.dart';

abstract class FastFoodState extends Equatable {
  const FastFoodState();

  @override
  List<Object?> get props => [];
}

class FastFoodInitial extends FastFoodState {
  const FastFoodInitial();
}

class FastFoodLoading extends FastFoodState {
  const FastFoodLoading();
}

class FastFoodLoaded extends FastFoodState {
  final List<FastFoodItemEntity> popularItems;
  final List<RestaurantEntity> openRestaurants;

  const FastFoodLoaded({
    required this.popularItems,
    required this.openRestaurants,
  });

  @override
  List<Object?> get props => [popularItems, openRestaurants];
}

class FastFoodError extends FastFoodState {
  final String message;

  const FastFoodError(this.message);

  @override
  List<Object?> get props => [message];
}
