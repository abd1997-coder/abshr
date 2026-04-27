import '../../../../core/network/api_client.dart';

/// Cart API responses: { cart: { id, items: [...], ... } }
abstract class CartRemoteDataSource {
  /// POST /store/carts -> returns cart with id. Call once per device/session.
  Future<Map<String, dynamic>> createCart();

  /// GET /store/carts/{cart_id}?fields=...
  Future<Map<String, dynamic>> getCart(String cartId);

  /// POST /store/carts/{cart_id}/line-items body: { variant_id, quantity }
  Future<Map<String, dynamic>> addLineItem(
    String cartId,
    String variantId,
    int quantity,
  );

  /// DELETE /store/carts/{cart_id}/line-items/{line_item_id}
  Future<void> removeLineItem(String cartId, String lineItemId);

  /// POST /store/carts/{cart_id}/line-items/{line_item_id} body: { quantity }
  Future<Map<String, dynamic>> updateLineItem(
    String cartId,
    String lineItemId,
    int quantity,
  );

  /// POST /store/mobile/checkout
  Future<Map<String, dynamic>> mobileCheckout(Map<String, dynamic> body);
}

const String _cartsPath = '/store/carts';
const String _cartFields =
    '*items,*region,*items.product,*items.variant,*promotions';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> createCart() async {
    final response = await _apiClient.post(_cartsPath);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid create cart response');
    }
    return data;
  }

  @override
  Future<Map<String, dynamic>> getCart(String cartId) async {
    final response = await _apiClient.get(
      '$_cartsPath/$cartId',
      queryParameters: {'fields': _cartFields},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid get cart response');
    }
    return data;
  }

  @override
  Future<Map<String, dynamic>> addLineItem(
    String cartId,
    String variantId,
    int quantity,
  ) async {
    final response = await _apiClient.post(
      '$_cartsPath/$cartId/line-items',
      data: {'variant_id': variantId, 'quantity': quantity},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid add line item response');
    }
    return data;
  }

  @override
  Future<void> removeLineItem(String cartId, String lineItemId) async {
    await _apiClient.delete('$_cartsPath/$cartId/line-items/$lineItemId');
  }

  @override
  Future<Map<String, dynamic>> updateLineItem(
    String cartId,
    String lineItemId,
    int quantity,
  ) async {
    final response = await _apiClient.post(
      '$_cartsPath/$cartId/line-items/$lineItemId',
      data: {'quantity': quantity},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid update line item response');
    }
    return data;
  }

  static const String _mobileCheckoutPath = '/store/mobile/checkout';

  @override
  Future<Map<String, dynamic>> mobileCheckout(Map<String, dynamic> body) async {
    final response = await _apiClient.post(_mobileCheckoutPath, data: body);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid checkout response');
    }
    return data;
  }
}
