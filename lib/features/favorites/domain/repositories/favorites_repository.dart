import '../entities/favorite_product.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteProduct>> getFavorites();
  Future<void> toggleFavorite(FavoriteProduct product);
  Future<void> removeFavorite(String productId);
  Future<bool> isFavorite(String productId);
}
