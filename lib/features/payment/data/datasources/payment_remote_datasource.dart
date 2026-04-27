import '../../../../core/network/api_client.dart';
import '../models/payment_method_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods({
    required String regionId,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  PaymentRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  static const String _paymentMethodsPath =
      '/store/mobile/checkout/payment-methods';

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods({
    required String regionId,
  }) async {
    final response = await _apiClient.get(
      _paymentMethodsPath,
      queryParameters: {'region_id': regionId},
    );

    final data = response.data;
    List<dynamic> list = const [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      final maybeList =
          data['payment_providers'] ??
          data['payment_methods'] ??
          data['paymentMethods'] ??
          data['methods'];
      if (maybeList is List) {
        list = maybeList;
      }
    }

    return list.whereType<Map>().map((e) {
      final map = Map<String, dynamic>.from(e);
      if (map['deleted_at'] != null) return null;
      final isEnabled = map['is_enabled'];
      if (isEnabled == false) return null;
      final model = PaymentMethodModel.fromJson(map);
      return model.id.trim().isNotEmpty ? model : null;
    }).whereType<PaymentMethodModel>().toList();
  }
}
