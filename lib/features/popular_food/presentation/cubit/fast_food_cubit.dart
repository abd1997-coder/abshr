import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/features/popular_food/domain/usecases/get_open_restaurants_usecase.dart';
import 'package:marketplace/features/popular_food/domain/usecases/get_popular_items_usecase.dart';
import 'fast_food_state.dart';

class FastFoodCubit extends Cubit<FastFoodState> {
  final GetPopularItemsUsecase getPopularItemsUsecase;
  final GetOpenRestaurantsUsecase getOpenRestaurantsUsecase;

  FastFoodCubit({
    required this.getPopularItemsUsecase,
    required this.getOpenRestaurantsUsecase,
  }) : super(const FastFoodInitial());

  Future<void> loadFastFoodData() async {
    emit(const FastFoodLoading());

    final itemsResult = await getPopularItemsUsecase();
    final restaurantsResult = await getOpenRestaurantsUsecase();

    itemsResult.fold((failure) => emit(FastFoodError(failure.message)), (
      items,
    ) {
      restaurantsResult.fold(
        (failure) => emit(FastFoodError(failure.message)),
        (restaurants) {
          emit(
            FastFoodLoaded(popularItems: items, openRestaurants: restaurants),
          );
        },
      );
    });
  }
}
