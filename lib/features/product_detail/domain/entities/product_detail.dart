import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String id;
  final String name;
  final String icon;
  final bool isAllergy;

  const Ingredient({
    required this.id,
    required this.name,
    required this.icon,
    this.isAllergy = false,
  });

  @override
  List<Object?> get props => [id, name, icon, isAllergy];
}

class ProductDetail extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final String imageUrl;
  final double price;
  final String currencyCode;
  final double rating;
  final int reviewCount;
  final String location;
  final String zipCode;
  final String description;
  final List<String> badges;
  final List<Ingredient> ingredients;
  /// First variant id from API when [ProductDetailPage] has no explicit variant.
  final String? defaultVariantId;

  const ProductDetail({
    required this.id,
    required this.name,
    this.subtitle = '',
    required this.category,
    required this.imageUrl,
    required this.price,
    this.currencyCode = '',
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.zipCode,
    required this.description,
    required this.badges,
    required this.ingredients,
    this.defaultVariantId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        subtitle,
        category,
        imageUrl,
        price,
        currencyCode,
        rating,
        reviewCount,
        location,
        zipCode,
        description,
        badges,
        ingredients,
        defaultVariantId,
      ];
}
