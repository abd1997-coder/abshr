import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String price;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, price, imageUrl];
}
