import 'package:marketplace/features/popular_food/data/models/fast_food_item_model.dart';
import 'package:marketplace/features/popular_food/data/models/restaurant_model.dart';

abstract class FastFoodRemoteDataSource {
  Future<List<FastFoodItemModel>> getPopularItems();
  Future<List<RestaurantModel>> getOpenRestaurants();
  Future<List<FastFoodItemModel>> searchFastFood(String query);
}

class FastFoodRemoteDataSourceImpl implements FastFoodRemoteDataSource {
  // TODO: Inject HTTP client when API is ready

  @override
  Future<List<FastFoodItemModel>> getPopularItems() async {
    // TODO: Implement API call
    return [];
  }

  @override
  Future<List<RestaurantModel>> getOpenRestaurants() async {
    // TODO: Implement API call
    return [];
  }

  @override
  Future<List<FastFoodItemModel>> searchFastFood(String query) async {
    // TODO: Implement API call
    return [];
  }
}
