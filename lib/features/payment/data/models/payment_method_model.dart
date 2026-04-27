import '../../domain/entities/payment_method.dart';

/// Maps one item from `GET .../payment-methods` → `payment_providers[]`
/// (or legacy `payment_methods` / `methods` lists).
class PaymentMethodModel extends PaymentMethod {
  const PaymentMethodModel({required super.id, required super.label});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    final id =
        (json['id'] ??
                json['code'] ??
                json['provider_id'] ??
                json['value'] ??
                '')
            .toString();
    final label =
        (json['name'] ??
                json['display_name'] ??
                json['title'] ??
                json['code'] ??
                _labelFromId(id))
            .toString();
    return PaymentMethodModel(id: id, label: label);
  }

  static String _labelFromId(String id) {
    var value = id.trim();
    if (value.isEmpty) return '';
    if (value.startsWith('pp_')) {
      value = value.substring(3);
    }
    if (value.startsWith('offline_')) {
      value = value.substring(8);
    }
    if (value.startsWith('system_')) {
      value = value.substring(7);
    }
    final words =
        value
            .split(RegExp(r'[-_]+'))
            .where((w) => w.trim().isNotEmpty)
            .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
            .toList();
    return words.join(' ');
  }
}
