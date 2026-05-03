import 'package:equatable/equatable.dart';

import '../../domain/entities/favorite_product.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.products = const [],
    this.loading = false,
  });

  final List<FavoriteProduct> products;
  final bool loading;

  bool contains(String productId) {
    return products.any((product) => product.id == productId);
  }

  FavoritesState copyWith({
    List<FavoriteProduct>? products,
    bool? loading,
  }) {
    return FavoritesState(
      products: products ?? this.products,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [products, loading];
}
