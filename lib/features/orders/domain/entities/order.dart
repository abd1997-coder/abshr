import 'order_line_item.dart';

class Order {
  /// Raw order id from API (for future detail endpoints).
  final String apiId;
  final String category;
  final String title;
  final String price;
  final String items;
  final String orderId;
  final String status;
  final List<OrderLineItem> lineItems;
  /// Human-readable placed-on string when API sends `created_at`.
  final String? placedAt;

  Order({
    required this.apiId,
    required this.category,
    required this.title,
    required this.price,
    required this.items,
    required this.orderId,
    required this.status,
    this.lineItems = const [],
    this.placedAt,
  });
}
