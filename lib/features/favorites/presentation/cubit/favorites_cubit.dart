import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/favorite_product.dart';
import '../../domain/repositories/favorites_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._repository) : super(const FavoritesState());

  final FavoritesRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final products = await _repository.getFavorites();
    emit(FavoritesState(products: products));
  }

  Future<void> toggle(FavoriteProduct product) async {
    await _repository.toggleFavorite(product);
    final products = await _repository.getFavorites();
    emit(FavoritesState(products: products));
  }

  Future<void> remove(String productId) async {
    await _repository.removeFavorite(productId);
    final products = await _repository.getFavorites();
    emit(FavoritesState(products: products));
  }
}
