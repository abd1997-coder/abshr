import 'package:equatable/equatable.dart';

/// Promotional offer from `GET /store/mobile/offers` (`offers[]`).
class Offer extends Equatable {
  final String id;
  /// e.g. `image`
  final String type;
  /// Primary headline (falls back to [ctaText] or "Offer" when API sends empty title).
  final String title;
  /// Absolute URL for the banner/background image.
  final String imageUrl;
  /// Secondary line under title (e.g. CTA when title is set).
  final String? subtitle;
  /// Raw `cta_text` from API (e.g. "Shop now").
  final String? ctaText;
  /// `link_type`: `product`, `seller`, etc.
  final String? linkType;
  /// `link_handle` — product id/handle or seller id/handle for navigation.
  final String? linkHandle;
  final int sortOrder;

  const Offer({
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

  bool get hasLink =>
      linkHandle != null && linkHandle!.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    imageUrl,
    subtitle,
    ctaText,
    linkType,
    linkHandle,
    sortOrder,
  ];
}
