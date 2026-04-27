import 'package:marketplace/features/popular_food/domain/entities/fast_food_item.dart';

class FastFoodItemModel extends FastFoodItemEntity {
  const FastFoodItemModel({
    required super.id,
    required super.name,
    required super.restaurant,
    required super.price,
    required super.imageUrl,
    super.rating,
    super.reviewCount,
  });

  factory FastFoodItemModel.fromJson(Map<String, dynamic> json) {
    return FastFoodItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      restaurant: json['restaurant'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['reviewCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'restaurant': restaurant,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
