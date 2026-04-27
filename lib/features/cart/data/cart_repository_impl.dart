import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/utils/storage_service.dart';
import 'package:marketplace/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:marketplace/features/cart/data/models/mobile_checkout_body.dart';
import 'package:marketplace/features/cart/domain/entities/cart_item.dart';
import 'package:marketplace/features/cart/domain/entities/checkout_shipping_address.dart';
import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';
import 'package:marketplace/features/restaurant/domain/entities/menu_item.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._storage, this._remote);
  final StorageService _storage;
  final CartRemoteDataSource _remote;

  @override
  String? getCartId() => _storage.getString(AppConstants.cartIdKey);

  @override
  Future<void> ensureCart() async {
    final existing = getCartId();
    if (existing != null && existing.isNotEmpty) return;
    try {
      final res = await _remote.createCart();
      final cart = res['cart'];
      if (cart is Map<String, dynamic>) {
        final id = cart['id'] as String?;
        if (id != null && id.isNotEmpty) {
          await _storage.setString(AppConstants.cartIdKey, id);
        }
      }
    } catch (_) {
      // Retry on first getItems if needed
    }
  }

  @override
  Future<List<CartItem>> getItems() async {
    await ensureCart();
    final cartId = getCartId();
    if (cartId == null || cartId.isEmpty) return [];

    try {
      final res = await _remote.getCart(cartId);
      final cart = res['cart'];
      if (cart is! Map<String, dynamic>) return [];

      final raw = cart['items'];
      if (raw is! List) return [];

      final list = <CartItem>[];
      for (final e in raw) {
        if (e is! Map<String, dynamic>) continue;
        final lineItemId = e['id'] as String?;
        final variantId = e['variant_id'] as String?;
        final quantity =
            (e['quantity'] is int)
                ? e['quantity'] as int
                : (e['quantity'] is num)
                ? (e['quantity'] as num).toInt()
                : 1;
        final unitPrice =
            (e['unit_price'] is num)
                ? (e['unit_price'] as num).toDouble()
                : 0.0;
        final item = MenuItem(
          id: lineItemId ?? '',
          name: e['product_title'] as String? ?? e['title'] as String? ?? '',
          subtitle:
              e['variant_title'] as String? ??
              e['product_subtitle'] as String? ??
              '',
          price: unitPrice > 0 ? unitPrice.toStringAsFixed(0) : '',
          imageUrl: e['thumbnail'] as String? ?? '',
        );
        list.add(
          CartItem(
            item: item,
            quantity: quantity,
            lineItemId: lineItemId,
            variantId: variantId,
          ),
        );
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addItem(CartItem item) async {
    final variantId = item.variantId;
    if (variantId != null && variantId.isNotEmpty) {
      await addLineItem(variantId, item.quantity);
      return;
    }
    // No variant: cannot add via API; ignore or no-op
  }

  @override
  Future<void> addLineItem(String variantId, int quantity) async {
    await ensureCart();
    final cartId = getCartId();
    if (cartId == null || cartId.isEmpty) return;

    await _remote.addLineItem(cartId, variantId, quantity);
  }

  @override
  Future<void> removeItem(String itemIdOrLineItemId) async {
    final cartId = getCartId();
    if (cartId == null || cartId.isEmpty) return;

    await _remote.removeLineItem(cartId, itemIdOrLineItemId);
  }

  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    await ensureCart();
    final cartId = getCartId();
    if (cartId == null || cartId.isEmpty) return;

    if (quantity <= 0) {
      await removeItem(itemId);
      return;
    }

    await _remote.updateLineItem(cartId, itemId, quantity);
  }

  @override
  Future<void> clear() async {
    final items = await getItems();
    for (final c in items) {
      final lid = c.lineItemId;
      if (lid != null && lid.isNotEmpty) await removeItem(lid);
    }
  }

  @override
  Future<void> submitMobileCheckout({
    required String cartId,
    required String email,
    required CheckoutShippingAddress shippingAddress,
    required String shippingOptionId,
    required String paymentProviderId,
  }) async {
    final body = MobileCheckoutBody(
      cartId: cartId,
      email: email,
      shippingAddress: shippingAddress,
      shippingOptionId: shippingOptionId,
      paymentProviderId: paymentProviderId,
    );
    await _remote.mobileCheckout(body.toJson());
    await _storage.remove(AppConstants.cartIdKey);
  }
}
