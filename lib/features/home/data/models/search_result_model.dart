import '../../domain/entities/seller.dart';
import '../../../restaurant/domain/entities/menu_item.dart';
import 'seller_model.dart';
import '../../../restaurant/data/models/menu_item_model.dart';

class SearchResult {
  final String type;
  final Seller? seller;
  final MenuItem? product;

  const SearchResult({
    required this.type,
    this.seller,
    this.product,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? '';

    if (type == 'seller') {
      return SearchResult(
        type: type,
        seller: SellerModel.fromMobileSellerJson(json),
      );
    } else if (type == 'product') {
      return SearchResult(
        type: type,
        product: MenuItemModel.fromProductJson(json),
      );
    }

    return SearchResult(type: type);
  }
}

class SearchResponse {
  final List<SearchResult> results;
  final int count;
  final int productsCount;
  final int sellersCount;
  final int limit;
  final int offset;
  final String q;
  final String type;

  const SearchResponse({
    required this.results,
    required this.count,
    required this.productsCount,
    required this.sellersCount,
    required this.limit,
    required this.offset,
    required this.q,
    required this.type,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final resultsRaw = json['results'] as List? ?? [];
    final results = resultsRaw
        .whereType<Map<String, dynamic>>()
        .map((e) => SearchResult.fromJson(e))
        .toList();

    return SearchResponse(
      results: results,
      count: json['count'] as int? ?? 0,
      productsCount: json['products_count'] as int? ?? 0,
      sellersCount: json['sellers_count'] as int? ?? 0,
      limit: json['limit'] as int? ?? 20,
      offset: json['offset'] as int? ?? 0,
      q: json['q'] as String? ?? '',
      type: json['type'] as String? ?? 'all',
    );
  }
}
