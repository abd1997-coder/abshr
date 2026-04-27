import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['title'] ?? json['handle'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? json['thumbnail'] ?? '',
    );
  }

  /// From `GET /store/mobile/collections` item: id, title, handle, metadata, image, ...
  /// Display image: prefer [metadata.image], then root [image], then legacy fields.
  factory CategoryModel.fromCollectionJson(Map<String, dynamic> json) {
    final metadata = json['metadata'];
    final metadataImage =
        metadata is Map
            ? _nonEmptyString(metadata['image'])
            : null;

    final imageUrl =
        (metadataImage != null && metadataImage.isNotEmpty)
            ? metadataImage
            : _nonEmptyString(json['image']) ??
                _nonEmptyString(json['thumbnail']) ??
                _nonEmptyString(json['image_url']) ??
                _nonEmptyString(json['imageUrl']) ??
                '';

    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['title'] ?? json['handle'] ?? '',
      price: '',
      imageUrl: imageUrl,
    );
  }

  static String? _nonEmptyString(dynamic value) {
    if (value is! String) return null;
    final s = value.trim();
    return s.isEmpty ? null : s;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
