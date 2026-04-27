import 'package:marketplace/core/constants/app_constants.dart';
import '../../domain/entities/offer.dart';

class OfferModel {
  final String id;
  final String type;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final String? ctaText;
  final String? linkType;
  final String? linkHandle;
  final int sortOrder;

  const OfferModel({
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.ctaText,
    this.linkType,
    this.linkHandle,
    this.sortOrder = 0,
  });

  /// Resolves relative paths like `/store/site-offers-assets/...` against [AppConstants.baseUrl].
  static String resolveAbsoluteUrl(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return '';
    if (t.startsWith('http://') || t.startsWith('https://')) {
      return t;
    }
    final base =
        AppConstants.baseUrl.endsWith('/')
            ? AppConstants.baseUrl.substring(0, AppConstants.baseUrl.length - 1)
            : AppConstants.baseUrl;
    final path = t.startsWith('/') ? t : '/$t';
    return '$base$path';
  }

  factory OfferModel.fromMobileJson(Map<String, dynamic> json) {
    final rawImage =
        json['background_image_url'] ??
        json['image_url'] ??
        json['image'] ??
        json['banner_url'] ??
        json['thumbnail'] ??
        json['cover'] ??
        '';
    final imageUrl = resolveAbsoluteUrl(rawImage.toString());

    final titleRaw = (json['title'] ?? '').toString().trim();
    final cta = _optionalString(json['cta_text'] ?? json['cta']);
    final title = titleRaw.isNotEmpty ? titleRaw : (cta ?? 'Offer');
    final subtitle =
        (titleRaw.isNotEmpty && cta != null && cta != title) ? cta : null;

    final linkType = _optionalString(json['link_type']);
    final linkHandle = _optionalString(json['link_handle']);

    // Legacy keys when API used different names
    final legacyProduct = _optionalString(
      json['product_id'] ?? json['productId'] ?? json['product_handle'],
    );
    final legacySeller = _optionalString(
      json['seller_id'] ?? json['sellerId'] ?? json['seller_handle'],
    );

    String? effectiveLinkType = linkType;
    String? effectiveHandle = linkHandle;
    if (effectiveHandle == null || effectiveHandle.isEmpty) {
      if (legacyProduct != null && legacyProduct.isNotEmpty) {
        effectiveLinkType = effectiveLinkType ?? 'product';
        effectiveHandle = legacyProduct;
      } else if (legacySeller != null && legacySeller.isNotEmpty) {
        effectiveLinkType = effectiveLinkType ?? 'seller';
        effectiveHandle = legacySeller;
      }
    }

    final sortRaw = json['sort_order'];
    final sortOrder =
        sortRaw is int ? sortRaw : int.tryParse(sortRaw?.toString() ?? '') ?? 0;

    return OfferModel(
      id: json['id']?.toString() ?? '',
      type: (json['type'] ?? 'image').toString().trim(),
      title: title,
      imageUrl: imageUrl,
      subtitle:
          subtitle ?? _optionalString(json['subtitle'] ?? json['description']),
      ctaText: cta,
      linkType: effectiveLinkType,
      linkHandle: effectiveHandle,
      sortOrder: sortOrder,
    );
  }

  static String? _optionalString(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  Offer toEntity() {
    return Offer(
      id: id,
      type: type,
      title: title,
      imageUrl: imageUrl,
      subtitle: subtitle,
      ctaText: ctaText,
      linkType: linkType,
      linkHandle: linkHandle,
      sortOrder: sortOrder,
    );
  }
}
