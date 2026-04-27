import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final String price;
  final String imageUrl;
  /// First variant id for add-to-cart (store API).
  final String? variantId;

  const MenuItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    this.variantId,
  });

  @override
  List<Object?> get props => [id, name, subtitle, price, imageUrl, variantId];
}
