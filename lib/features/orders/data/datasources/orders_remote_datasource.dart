import '../../../../core/network/api_client.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders({int limit = 10, int offset = 0});
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  static const String _mobileOrdersPath = '/store/mobile/orders';

  @override
  Future<List<OrderModel>> getOrders({int limit = 10, int offset = 0}) async {
    final response = await _apiClient.get(
      _mobileOrdersPath,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final data = response.data;
    if (data == null || data is! Map<String, dynamic>) return [];

    final raw = data['orders'];
    if (raw == null || raw is! List) return [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(OrderModel.fromMobileOrderJson)
        .toList();
  }
}
