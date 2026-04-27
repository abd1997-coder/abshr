import '../repositories/payment_repository.dart';

class ProcessPayment {
  final PaymentRepository repository;
  ProcessPayment(this.repository);

  Future<bool> call(String method, double amount) async {
    return repository.processPayment(method: method, amount: amount);
  }
}
