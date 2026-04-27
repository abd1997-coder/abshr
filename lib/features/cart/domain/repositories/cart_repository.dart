import '../entities/cart_item.dart';
import '../entities/checkout_shipping_address.dart';

abstract class CartRepository {
  /// Ensures a cart exists (creates one if needed) and saves cart id. Call on app launch.
  Future<void> ensureCart();

  /// Returns current cart id if any.
  String? getCartId();

  Future<List<CartItem>> getItems();
  Future<void> addItem(CartItem item);

  /// Add line item by variant id (store API). Prefer this when adding from product.
  Future<void> addLineItem(String variantId, int quantity);

  /// Remove by line item id (store API) or by item id for compatibility.
  Future<void> removeItem(String itemIdOrLineItemId);
  Future<void> updateQuantity(String itemId, int quantity);
  Future<void> clear();

  Future<void> submitMobileCheckout({
    required String cartId,
    required String email,
    required CheckoutShippingAddress shippingAddress,
    required String shippingOptionId,
    required String paymentProviderId,
  });
}
