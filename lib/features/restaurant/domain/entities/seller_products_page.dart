import 'menu_item.dart';

/// One page from `GET /store/mobile/sellers/{id}/products`.
class SellerProductsPageResult {
  final List<MenuItem> products;
  final int limit;
  final int requestedOffset;
  final int? totalCount;

  const SellerProductsPageResult({
    required this.products,
    required this.limit,
    required this.requestedOffset,
    this.totalCount,
  });

  bool get hasMore {
    if (totalCount != null) {
      return requestedOffset + products.length < totalCount!;
    }
    if (products.isEmpty) return false;
    return products.length >= limit;
  }
}
