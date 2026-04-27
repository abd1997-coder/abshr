import '../../domain/entities/product_detail.dart';

class IngredientModel {
  final String id;
  final String name;
  final String icon;
  final bool isAllergy;

  const IngredientModel({
    required this.id,
    required this.name,
    required this.icon,
    this.isAllergy = false,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      isAllergy: json['isAllergy'] as bool? ?? false,
    );
  }

  factory IngredientModel.fromEntity(Ingredient ingredient) {
    return IngredientModel(
      id: ingredient.id,
      name: ingredient.name,
      icon: ingredient.icon,
      isAllergy: ingredient.isAllergy,
    );
  }

  Ingredient toEntity() {
    return Ingredient(id: id, name: name, icon: icon, isAllergy: isAllergy);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'isAllergy': isAllergy};
  }
}

class ProductDetailModel {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final String imageUrl;
  final double price;
  final String currencyCode;
  final double rating;
  final int reviewCount;
  final String location;
  final String zipCode;
  final String description;
  final List<String> badges;
  final List<IngredientModel> ingredients;
  final String? defaultVariantId;

  const ProductDetailModel({
    required this.id,
    required this.name,
    this.subtitle = '',
    required this.category,
    required this.imageUrl,
    required this.price,
    this.currencyCode = '',
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.zipCode,
    required this.description,
    required this.badges,
    required this.ingredients,
    this.defaultVariantId,
  });

  /// `GET /store/mobile/products/{id}` → root map with `product` key.
  factory ProductDetailModel.fromMobileApiResponse(Map<String, dynamic> json) {
    final product = json['product'];
    if (product is! Map<String, dynamic>) {
      throw FormatException('Missing product object');
    }

    final id = product['id']?.toString() ?? '';
    final title = product['title'] as String? ?? '';
    final subtitle = product['subtitle'] as String? ?? '';
    final description = product['description'] as String? ?? '';

    String imageUrl = product['thumbnail'] as String? ?? '';
    final images = product['images'];
    if (imageUrl.isEmpty && images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is Map && first['url'] != null) {
        imageUrl = first['url'] as String;
      }
    }

    String category = '';
    final collection = product['collection'];
    if (collection is Map && collection['title'] != null) {
      category = collection['title'] as String;
    }
    final categories = product['categories'];
    if (categories is List && categories.isNotEmpty) {
      final first = categories.first;
      if (first is Map && first['name'] != null) {
        category = first['name'] as String;
      }
    }

    final badges = <String>{};
    if (collection is Map && (collection['title'] as String?)?.isNotEmpty == true) {
      badges.add(collection['title'] as String);
    }
    if (categories is List) {
      for (final c in categories) {
        if (c is Map && c['name'] != null) {
          badges.add(c['name'] as String);
        }
      }
    }
    final tags = product['tags'];
    if (tags is List) {
      for (final t in tags) {
        if (t is Map && t['value'] != null) {
          badges.add(t['value'] as String);
        } else if (t is String) {
          badges.add(t);
        }
      }
    }

    double price = 0;
    String currencyCode = '';
    String? defaultVariantId;
    final variants = product['variants'];
    if (variants is List && variants.isNotEmpty && variants.first is Map) {
      final v = variants.first as Map<String, dynamic>;
      defaultVariantId = v['id'] as String?;
      final prices = v['prices'];
      if (prices is List && prices.isNotEmpty && prices.first is Map) {
        final p = prices.first as Map<String, dynamic>;
        price = _parsePriceAmount(p);
        currencyCode = (p['currency_code'] as String?)?.trim() ?? '';
      }
    }

    final ingredients = <IngredientModel>[];
    final attrs = product['attribute_values'];
    if (attrs is List) {
      for (final a in attrs) {
        if (a is! Map<String, dynamic>) continue;
        final name =
            a['value']?.toString() ??
            a['name']?.toString() ??
            '';
        if (name.isEmpty) continue;
        ingredients.add(
          IngredientModel(
            id: a['id']?.toString() ?? name,
            name: name,
            icon: 'label',
          ),
        );
      }
    }

    String location = '';
    String zipCode = '';
    double rating = 0;
    int reviewCount = 0;
    final seller = product['seller'];
    if (seller is Map<String, dynamic>) {
      final sellerName = seller['name'] as String? ?? '';
      final city = seller['city'] as String? ?? '';
      final line = seller['address_line'] as String? ?? '';
      if (sellerName.isNotEmpty) {
        location = sellerName;
        if (city.isNotEmpty) {
          location = '$location · $city';
        } else if (line.isNotEmpty) {
          location = '$location · $line';
        }
      } else if (line.isNotEmpty) {
        location = line;
      }
      zipCode = seller['postal_code'] as String? ?? '';

      final reviews = seller['reviews'];
      if (reviews is List) {
        reviewCount = reviews.length;
        var sum = 0.0;
        var n = 0;
        for (final r in reviews) {
          if (r is Map && r['rating'] != null) {
            final rv = r['rating'];
            if (rv is num) {
              sum += rv.toDouble();
              n++;
            }
          }
        }
        if (n > 0) rating = sum / n;
      }
    }

    return ProductDetailModel(
      id: id,
      name: title,
      subtitle: subtitle,
      category: category,
      imageUrl: imageUrl,
      price: price,
      currencyCode: currencyCode,
      rating: rating,
      reviewCount: reviewCount,
      location: location,
      zipCode: zipCode,
      description: description,
      badges: badges.toList(),
      ingredients: ingredients,
      defaultVariantId: defaultVariantId,
    );
  }

  static double _parsePriceAmount(Map<String, dynamic> priceMap) {
    final amount = priceMap['amount'];
    if (amount is num) return amount.toDouble();
    final raw = priceMap['raw_amount'];
    if (raw is Map) {
      final v = raw['value'];
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
    }
    return 0;
  }

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String? ?? '',
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      location: json['location'] as String,
      zipCode: json['zipCode'] as String,
      description: json['description'] as String,
      badges: List<String>.from(json['badges'] as List? ?? []),
      ingredients:
          (json['ingredients'] as List?)
              ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      defaultVariantId: json['defaultVariantId'] as String?,
    );
  }

  factory ProductDetailModel.fromEntity(ProductDetail productDetail) {
    return ProductDetailModel(
      id: productDetail.id,
      name: productDetail.name,
      subtitle: productDetail.subtitle,
      category: productDetail.category,
      imageUrl: productDetail.imageUrl,
      price: productDetail.price,
      currencyCode: productDetail.currencyCode,
      rating: productDetail.rating,
      reviewCount: productDetail.reviewCount,
      location: productDetail.location,
      zipCode: productDetail.zipCode,
      description: productDetail.description,
      badges: productDetail.badges,
      ingredients:
          productDetail.ingredients
              .map((e) => IngredientModel.fromEntity(e))
              .toList(),
      defaultVariantId: productDetail.defaultVariantId,
    );
  }

  ProductDetail toEntity() {
    return ProductDetail(
      id: id,
      name: name,
      subtitle: subtitle,
      category: category,
      imageUrl: imageUrl,
      price: price,
      currencyCode: currencyCode,
      rating: rating,
      reviewCount: reviewCount,
      location: location,
      zipCode: zipCode,
      description: description,
      badges: badges,
      ingredients: ingredients.map((e) => e.toEntity()).toList(),
      defaultVariantId: defaultVariantId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'currencyCode': currencyCode,
      'rating': rating,
      'reviewCount': reviewCount,
      'location': location,
      'zipCode': zipCode,
      'description': description,
      'badges': badges,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'defaultVariantId': defaultVariantId,
    };
  }
}
