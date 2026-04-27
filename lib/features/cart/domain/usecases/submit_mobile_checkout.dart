import '../entities/checkout_shipping_address.dart';
import '../repositories/cart_repository.dart';

class SubmitMobileCheckout {
  SubmitMobileCheckout(this._repository);

  final CartRepository _repository;

  Future<void> call({
    required String cartId,
    required String email,
    required CheckoutShippingAddress shippingAddress,
    required String shippingOptionId,
    required String paymentProviderId,
  }) {
    return _repository.submitMobileCheckout(
      cartId: cartId,
      email: email,
      shippingAddress: shippingAddress,
      shippingOptionId: shippingOptionId,
      paymentProviderId: paymentProviderId,
    );
  }
}
