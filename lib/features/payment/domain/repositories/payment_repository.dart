import '../entities/payment_method.dart';

abstract class PaymentRepository {
  /// Simulate processing payment. Returns true when succeeded.
  Future<bool> processPayment({required String method, required double amount});

  Future<List<PaymentMethod>> getPaymentMethods({required String regionId});
}
