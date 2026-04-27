/// Single line on an order (from mobile orders API `items[]`).
class OrderLineItem {
  final String title;
  final String? variantTitle;
  final int quantity;
  /// Formatted price for this line (subtotal / line total).
  final String linePrice;
  final String? thumbnailUrl;

  const OrderLineItem({
    required this.title,
    this.variantTitle,
    required this.quantity,
    required this.linePrice,
    this.thumbnailUrl,
  });
}
