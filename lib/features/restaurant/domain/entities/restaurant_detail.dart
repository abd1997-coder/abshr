import 'package:equatable/equatable.dart';

class RestaurantDetail extends Equatable {
  final String id;
  final String name;
  final String description;
  final String rating;
  /// Location line (e.g. city) for the info row.
  final String delivery;
  /// Contact line (e.g. phone) for the info row.
  final String time;
  /// Cover / hero image URL.
  final String imageUrl;
  /// Store logo URL shown on the cover banner.
  final String logoUrl;
  final List<String> categories;

  const RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.delivery,
    required this.time,
    required this.imageUrl,
    this.logoUrl = '',
    required this.categories,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    rating,
    delivery,
    time,
    imageUrl,
    logoUrl,
    categories,
  ];
}
