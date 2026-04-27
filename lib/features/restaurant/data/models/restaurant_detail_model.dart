import 'package:marketplace/features/home/domain/entities/seller.dart';

import '../../domain/entities/restaurant_detail.dart';

class RestaurantDetailModel extends RestaurantDetail {
  const RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.rating,
    required super.delivery,
    required super.time,
    required super.imageUrl,
    super.logoUrl = '',
    required super.categories,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      rating: json['rating'] ?? '',
      delivery: json['delivery'] ?? '',
      time: json['time'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  factory RestaurantDetailModel.fromSeller(Seller seller) {
    final cover =
        seller.coverPhotoUrl.trim().isNotEmpty
            ? seller.coverPhotoUrl.trim()
            : seller.imageUrl;
    final location =
        seller.locationLine.isNotEmpty
            ? seller.locationLine
            : (seller.city.isNotEmpty
                ? seller.city
                : (seller.addressLine.isNotEmpty ? seller.addressLine : '—'));
    final contact =
        seller.phone.isNotEmpty
            ? seller.phone
            : (seller.email.isNotEmpty ? seller.email : '—');
    final ratingLine =
        seller.reviewCount > 0
            ? '${seller.rating} (${seller.reviewCount})'
            : seller.rating;

    return RestaurantDetailModel(
      id: seller.id,
      name: seller.name,
      description: seller.description,
      rating: ratingLine,
      delivery: location,
      time: contact,
      imageUrl: cover,
      logoUrl: seller.imageUrl,
      categories: const ['All'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rating': rating,
      'delivery': delivery,
      'time': time,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
      'categories': categories,
    };
  }
}
