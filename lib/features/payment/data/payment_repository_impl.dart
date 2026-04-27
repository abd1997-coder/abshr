import '../domain/repositories/payment_repository.dart';
import '../domain/entities/payment_method.dart';
import 'datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._remoteDataSource);

  final PaymentRemoteDataSource _remoteDataSource;

  @override
  Future<bool> processPayment({
    required String method,
    required double amount,
  }) async {
    // TODO: connect real payment processing endpoint when available.
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods({required String regionId}) {
    return _remoteDataSource.getPaymentMethods(regionId: regionId);
  }
}
