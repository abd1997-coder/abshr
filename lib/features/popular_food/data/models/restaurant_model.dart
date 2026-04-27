import 'package:marketplace/features/popular_food/domain/entities/restaurant_entity.dart';

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.deliveryFee,
    required super.deliveryTime,
    required super.imageUrl,
    required super.isOpen,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      deliveryFee: json['deliveryFee'] as String,
      deliveryTime: json['deliveryTime'] as String,
      imageUrl: json['imageUrl'] as String,
      isOpen: json['isOpen'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'deliveryFee': deliveryFee,
      'deliveryTime': deliveryTime,
      'imageUrl': imageUrl,
      'isOpen': isOpen,
    };
  }
}
