import '../../../../core/network/api_client.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/seller.dart';
import '../models/category_model.dart';
import '../models/offer_model.dart';
import '../models/seller_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<Category>> getCategories();
  Future<List<Seller>> getSellers({
    String? q,
    int limit = 20,
    int offset = 0,
  });

  /// `GET /store/mobile/collections/sellers?collection_id=&limit=&offset=&seller_limit=`
  Future<List<Seller>> getSellersForCollection({
    required String collectionId,
    int limit = 10,
    int offset = 0,
    int sellerLimit = 6,
  });

  /// `GET /store/site-promotions?limit=&offset=`
  Future<List<OfferModel>> getOffers({int limit = 20, int offset = 0});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  static const String _collectionsPath = '/store/mobile/collections';
  static const String _collectionSellersPath =
      '/store/mobile/collections/sellers';
  static const String _mobileSellersPath = '/store/mobile/sellers';
  static const String _mobileOffersPath = '/store/site-promotions';
  List<Map<String, dynamic>> _parseOfferList(dynamic data) {
    List<dynamic> raw = const [];
    if (data is List) {
      raw = data;
    } else if (data is Map<String, dynamic>) {
      final nested =
          data['promotions'] ?? data['offers'] ?? data['data'] ?? data['items'];
      if (nested is List) {
        raw = nested;
      }
    }
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await _apiClient.get(_collectionsPath);
    final data = response.data;
    if (data == null || data is! Map<String, dynamic>) return [];

    final raw = data['collections'];
    if (raw == null || raw is! List) return [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map((e) => CategoryModel.fromCollectionJson(e))
        .toList();
  }

  @override
  Future<List<Seller>> getSellers({
    String? q,
    int limit = 20,
    int offset = 0,
  }) async {
    final queryParameters = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    final trimmed = q?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      queryParameters['q'] = trimmed;
    }

    final response = await _apiClient.get(
      _mobileSellersPath,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data == null || data is! Map<String, dynamic>) return [];

    final raw = data['sellers'];
    if (raw == null || raw is! List) return [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(SellerModel.fromMobileSellerJson)
        .toList();
  }

  @override
  Future<List<Seller>> getSellersForCollection({
    required String collectionId,
    int limit = 10,
    int offset = 0,
    int sellerLimit = 6,
  }) async {
    final response = await _apiClient.get(
      _collectionSellersPath,
      queryParameters: <String, dynamic>{
        'collection_id': collectionId,
        'limit': limit,
        'offset': offset,
        'seller_limit': sellerLimit,
      },
    );
    final data = response.data;
    if (data == null || data is! Map<String, dynamic>) return [];

    final fromCollections = _sellersFromCollectionsSellersResponse(
      data,
      collectionId,
    );
    if (fromCollections != null) return fromCollections;

    final raw = data['sellers'];
    if (raw == null || raw is! List) return [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(SellerModel.fromMobileSellerJson)
        .toList();
  }

  /// `GET /store/mobile/collections/sellers` returns `collections[].sellers`, not top-level `sellers`.
  List<Seller>? _sellersFromCollectionsSellersResponse(
    Map<String, dynamic> data,
    String collectionId,
  ) {
    final rawCollections = data['collections'];
    if (rawCollections is! List || rawCollections.isEmpty) return null;

    Map<String, dynamic>? mapFor(dynamic item) {
      if (item is Map<String, dynamic>) return item;
      if (item is Map) return Map<String, dynamic>.from(item);
      return null;
    }

    Map<String, dynamic>? collection;
    for (final item in rawCollections) {
      final m = mapFor(item);
      if (m != null && m['id'] == collectionId) {
        collection = m;
        break;
      }
    }
    collection ??= mapFor(rawCollections.first);

    if (collection == null) return null;

    final sellersRaw = collection['sellers'];
    if (sellersRaw is! List) return [];

    return sellersRaw
        .whereType<Map>()
        .map((e) => SellerModel.fromMobileSellerJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<OfferModel>> getOffers({int limit = 20, int offset = 0}) async {
    final response = await _apiClient.get(
      _mobileOffersPath,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final data = response.data;
    final maps = _parseOfferList(data);
    final list = maps.map(OfferModel.fromMobileJson).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }
}
