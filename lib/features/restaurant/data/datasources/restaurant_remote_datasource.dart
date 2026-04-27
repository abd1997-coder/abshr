import 'package:marketplace/features/home/data/models/seller_model.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/restaurant_detail.dart';
import '../../domain/entities/seller_products_page.dart';
import '../models/menu_item_model.dart';
import '../models/restaurant_detail_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<RestaurantDetail?> getRestaurantDetail(String id, String name);
  Future<SellerProductsPageResult> getSellerProducts(
    String sellerId, {
    int limit = 20,
    int offset = 0,
  });
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  RestaurantRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  String _sellerProductsPath(String sellerId) =>
      '/store/mobile/sellers/$sellerId/products';

  @override
  Future<RestaurantDetail?> getRestaurantDetail(String id, String name) async {
    final map = await _fetchSellerMap(id);
    if (map != null) {
      final seller = SellerModel.fromMobileSellerJson(map);
      if (seller.id.isNotEmpty || seller.name.isNotEmpty) {
        return RestaurantDetailModel.fromSeller(seller);
      }
    }
    return RestaurantDetailModel(
      id: id,
      name: name,
      description: '',
      rating: '—',
      delivery: '—',
      time: '—',
      imageUrl: '',
      logoUrl: '',
      categories: const ['All'],
    );
  }

  Future<Map<String, dynamic>?> _fetchSellerMap(String id) async {
    try {
      final response = await _apiClient.get('/store/mobile/sellers/$id');
      final data = response.data;
      if (data is! Map<String, dynamic>) return null;
      final nested = data['seller'];
      if (nested is Map<String, dynamic>) {
        return Map<String, dynamic>.from(nested);
      }
      if (data['id'] != null) {
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SellerProductsPageResult> getSellerProducts(
    String sellerId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _apiClient.get(
      _sellerProductsPath(sellerId),
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final data = response.data;
    if (data == null || data is! Map<String, dynamic>) {
      return SellerProductsPageResult(
        products: const [],
        limit: limit,
        requestedOffset: offset,
        totalCount: null,
      );
    }

    final raw = data['products'];
    final list = raw is List ? raw.whereType<Map<String, dynamic>>().toList() : <Map<String, dynamic>>[];

    final products = list.map(MenuItemModel.fromProductJson).toList();

    int? totalCount;
    final c = data['count'];
    if (c is int) {
      totalCount = c;
    } else if (c is num) {
      totalCount = c.toInt();
    }

    return SellerProductsPageResult(
      products: products,
      limit: limit,
      requestedOffset: offset,
      totalCount: totalCount,
    );
  }
}
