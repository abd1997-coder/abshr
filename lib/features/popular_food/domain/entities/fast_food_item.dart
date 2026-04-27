import 'package:equatable/equatable.dart';

class FastFoodItemEntity extends Equatable {
  final String id;
  final String name;
  final String restaurant;
  final double price;
  final String imageUrl;
  final double? rating;
  final int? reviewCount;

  const FastFoodItemEntity({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.imageUrl,
    this.rating,
    this.reviewCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    restaurant,
    price,
    imageUrl,
    rating,
    reviewCount,
  ];
}
