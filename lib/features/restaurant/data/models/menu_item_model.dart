import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.subtitle,
    required super.price,
    required super.imageUrl,
    super.variantId,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      variantId: json['variantId'] as String?,
    );
  }

  /// From store / mobile seller products API: id, title, thumbnail, collection, variants, ...
  factory MenuItemModel.fromProductJson(Map<String, dynamic> json) {
    final collection = json['collection'];
    final collectionTitle = collection is Map
        ? (collection['title'] as String? ?? '')
        : '';
    final variants = json['variants'];
    String? firstVariantId;
    String priceLabel = '';
    if (variants is List && variants.isNotEmpty && variants.first is Map) {
      final v = variants.first as Map<String, dynamic>;
      firstVariantId = v['id'] as String?;
      final cp = v['calculated_price'];
      if (cp is num) {
        priceLabel = (cp / 100).toStringAsFixed(2);
      } else if (v['prices'] is List && (v['prices'] as List).isNotEmpty) {
        final p0 = (v['prices'] as List).first;
        if (p0 is Map && p0['amount'] is num) {
          priceLabel = (((p0['amount'] as num).toDouble()) / 100).toStringAsFixed(2);
        }
      }
    }
    var imageUrl = json['thumbnail'] as String? ?? json['image_url'] as String? ?? '';
    if (imageUrl.isEmpty && json['images'] is List) {
      final imgs = json['images'] as List;
      if (imgs.isNotEmpty && imgs.first is Map) {
        imageUrl = ((imgs.first as Map)['url'] as String?) ?? '';
      }
    }

    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      name: json['title'] as String? ?? json['name'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? collectionTitle,
      price: priceLabel,
      imageUrl: imageUrl,
      variantId: firstVariantId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'price': price,
      'imageUrl': imageUrl,
      'variantId': variantId,
    };
  }
}
