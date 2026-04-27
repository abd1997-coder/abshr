import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final double rating;
  final String deliveryFee;
  final String deliveryTime;
  final String imageUrl;
  final bool isOpen;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.imageUrl,
    required this.isOpen,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    rating,
    deliveryFee,
    deliveryTime,
    imageUrl,
    isOpen,
  ];
}
