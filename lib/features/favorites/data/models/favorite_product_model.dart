import '../../domain/entities/favorite_product.dart';

class FavoriteProductModel extends FavoriteProduct {
  const FavoriteProductModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    super.subtitle,
    super.priceLabel,
    super.variantId,
  });

  factory FavoriteProductModel.fromEntity(FavoriteProduct product) {
    return FavoriteProductModel(
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      subtitle: product.subtitle,
      priceLabel: product.priceLabel,
      variantId: product.variantId,
    );
  }

  factory FavoriteProductModel.fromJson(Map<String, dynamic> json) {
    return FavoriteProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      priceLabel: json['priceLabel']?.toString() ?? '',
      variantId: json['variantId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'subtitle': subtitle,
      'priceLabel': priceLabel,
      'variantId': variantId,
    };
  }
}
