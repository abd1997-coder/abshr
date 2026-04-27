import '../../domain/entities/seller.dart';

class SellerModel extends Seller {
  const SellerModel({
    required super.id,
    required super.name,
    required super.handle,
    required super.description,
    required super.imageUrl,
    required super.coverPhotoUrl,
    required super.city,
    required super.addressLine,
    required super.countryCode,
    required super.phone,
    required super.email,
    required super.reviewCount,
    required super.rating,
  });

  /// Parses one item from `GET /store/mobile/sellers` → `sellers[]`.
  factory SellerModel.fromMobileSellerJson(Map<String, dynamic> json) {
    final photo = json['photo'];
    final imageUrl =
        photo is String && photo.trim().isNotEmpty ? photo.trim() : '';

    final cover = json['cover_photo'];
    final coverPhotoUrl =
        cover is String && cover.trim().isNotEmpty ? cover.trim() : '';

    final rc = json['review_count'];
    int reviewCount = 0;
    if (rc is int) {
      reviewCount = rc;
    } else if (rc is num) {
      reviewCount = rc.toInt();
    }

    final avg = json['avg_rating'];
    double? avgRating;
    if (avg is num) {
      avgRating = avg.toDouble();
    }

    String rating;
    if (avgRating != null) {
      rating =
          avgRating == avgRating.roundToDouble()
              ? '${avgRating.round()}'
              : avgRating.toStringAsFixed(1);
    } else {
      rating = '—';
    }

    return SellerModel(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as String? ?? '').trim(),
      handle: (json['handle'] as String? ?? '').trim(),
      description: (json['description'] as String? ?? '').trim(),
      imageUrl: imageUrl,
      coverPhotoUrl: coverPhotoUrl,
      city: (json['city'] as String? ?? '').trim(),
      addressLine: (json['address_line'] as String? ?? '').trim(),
      countryCode: (json['country_code'] as String? ?? '').trim(),
      phone: (json['phone'] as String? ?? '').trim(),
      email: (json['email'] as String? ?? '').trim(),
      reviewCount: reviewCount,
      rating: rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'description': description,
      'imageUrl': imageUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'city': city,
      'addressLine': addressLine,
      'countryCode': countryCode,
      'phone': phone,
      'email': email,
      'reviewCount': reviewCount,
      'rating': rating,
    };
  }
}
