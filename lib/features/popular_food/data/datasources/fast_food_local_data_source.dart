import 'package:marketplace/features/popular_food/data/models/fast_food_item_model.dart';
import 'package:marketplace/features/popular_food/data/models/restaurant_model.dart';

abstract class FastFoodLocalDataSource {
  Future<List<FastFoodItemModel>> getCachedPopularItems();
  Future<List<RestaurantModel>> getCachedOpenRestaurants();
  Future<void> cachePopularItems(List<FastFoodItemModel> items);
  Future<void> cacheOpenRestaurants(List<RestaurantModel> restaurants);
}

class FastFoodLocalDataSourceImpl implements FastFoodLocalDataSource {
  // TODO: Inject Hive or SharedPreferences when cache is set up

  @override
  Future<List<FastFoodItemModel>> getCachedPopularItems() async {
    // TODO: Implement caching logic
    return [];
  }

  @override
  Future<List<RestaurantModel>> getCachedOpenRestaurants() async {
    // TODO: Implement caching logic
    return [];
  }

  @override
  Future<void> cachePopularItems(List<FastFoodItemModel> items) async {
    // TODO: Implement caching logic
  }

  @override
  Future<void> cacheOpenRestaurants(List<RestaurantModel> restaurants) async {
    // TODO: Implement caching logic
  }
}
