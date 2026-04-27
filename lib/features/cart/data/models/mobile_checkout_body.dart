import '../../domain/entities/checkout_shipping_address.dart';

class MobileCheckoutBody {
  final String cartId;
  final String email;
  final CheckoutShippingAddress shippingAddress;
  final String shippingOptionId;
  final String paymentProviderId;

  const MobileCheckoutBody({
    required this.cartId,
    required this.email,
    required this.shippingAddress,
    required this.shippingOptionId,
    required this.paymentProviderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'email': email,
      'shipping_address': shippingAddress.toJson(),
      'shipping_option_id': shippingOptionId,
      'payment_provider_id': paymentProviderId,
    };
  }
}
