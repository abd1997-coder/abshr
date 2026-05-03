import 'dart:convert';

import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/utils/storage_service.dart';
import 'package:marketplace/features/favorites/data/models/favorite_product_model.dart';
import 'package:marketplace/features/favorites/domain/entities/favorite_product.dart';
import 'package:marketplace/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._storage);

  final StorageService _storage;

  @override
  Future<List<FavoriteProduct>> getFavorites() async {
    return _readFavorites();
  }

  @override
  Future<bool> isFavorite(String productId) async {
    final favorites = _readFavorites();
    return favorites.any((product) => product.id == productId);
  }

  @override
  Future<void> removeFavorite(String productId) async {
    final favorites =
        _readFavorites().where((product) => product.id != productId).toList();
    await _writeFavorites(favorites);
  }

  @override
  Future<void> toggleFavorite(FavoriteProduct product) async {
    final favorites = _readFavorites();
    final index = favorites.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.insert(0, product);
    }
    await _writeFavorites(favorites);
  }

  List<FavoriteProduct> _readFavorites() {
    final raw = _storage.getString(AppConstants.favoriteProductsKey);
    if (raw == null || raw.trim().isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map((item) => FavoriteProductModel.fromJson(Map<String, dynamic>.from(item)))
          .where((product) => product.id.trim().isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeFavorites(List<FavoriteProduct> favorites) async {
    final models = favorites.map(FavoriteProductModel.fromEntity).toList();
    await _storage.setString(
      AppConstants.favoriteProductsKey,
      jsonEncode(models.map((item) => item.toJson()).toList()),
    );
  }
}
