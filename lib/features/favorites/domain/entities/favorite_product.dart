import 'package:equatable/equatable.dart';

class FavoriteProduct extends Equatable {
  const FavoriteProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.subtitle = '',
    this.priceLabel = '',
    this.variantId,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String subtitle;
  final String priceLabel;
  final String? variantId;

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    subtitle,
    priceLabel,
    variantId,
  ];
}
