import '../../domain/entities/order.dart';
import '../../domain/entities/order_line_item.dart';

class OrderModel extends Order {
  OrderModel({
    required super.apiId,
    required super.category,
    required super.title,
    required super.price,
    required super.items,
    required super.orderId,
    required super.status,
    super.lineItems = const [],
    super.placedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      apiId: json['apiId'] as String? ?? '',
      category: json['category'] as String,
      title: json['title'] as String,
      price: json['price'] as String,
      items: json['items'] as String,
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      lineItems: const [],
      placedAt: json['placedAt'] as String?,
    );
  }

  /// One order from `GET /store/mobile/orders` → `orders[]`.
  factory OrderModel.fromMobileOrderJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final displayId = json['display_id'];
    final orderId =
        displayId != null
            ? '#$displayId'
            : (id.isNotEmpty
                ? '#${id.length > 12 ? id.substring(id.length - 8) : id}'
                : '#—');

    final itemsRaw = json['items'];
    var itemCount = 0;
    var title = 'Order';
    if (itemsRaw is List) {
      itemCount = itemsRaw.length;
      if (itemsRaw.isNotEmpty && itemsRaw.first is Map<String, dynamic>) {
        final first = itemsRaw.first as Map<String, dynamic>;
        title =
            first['title'] as String? ??
            first['product_title'] as String? ??
            _stringFromNested(first, ['variant', 'product', 'title']) ??
            _stringFromNested(first, ['detail', 'title']) ??
            title;
      }
    }

    final itemsLabel =
        itemCount == 0
            ? '0 Items'
            : itemCount == 1
            ? '01 Item'
            : '${itemCount.toString().padLeft(2, '0')} Items';

    final currency =
        (json['currency_code'] as String? ?? json['currency'] as String? ?? '')
            .trim();

    dynamic totalField = json['total'];
    if (totalField == null) {
      final summary = json['summary'];
      if (summary is Map<String, dynamic>) {
        totalField =
            summary['current_order_total'] ??
            summary['paid_total'] ??
            summary['accounting_total'];
      }
    }
    totalField ??= json['subtotal'];

    final price = _formatTotal(totalField, currency);

    final statusRaw =
        json['status'] as String? ??
        json['fulfillment_status'] as String? ??
        'pending';
    final status = _humanizeStatus(statusRaw);

    final category =
        _stringFromNested(json, ['region', 'name']) ??
        (json['sales_channel_id'] != null ? 'Order' : 'Order');

    final lineItems = _parseLineItems(itemsRaw, currency);
    final placedAt = _formatPlacedAt(json['created_at']);

    return OrderModel(
      apiId: id,
      category: category,
      title: title,
      price: price,
      items: itemsLabel,
      orderId: orderId,
      status: status,
      lineItems: lineItems,
      placedAt: placedAt,
    );
  }

  static List<OrderLineItem> _parseLineItems(
    dynamic itemsRaw,
    String currency,
  ) {
    if (itemsRaw is! List) return [];
    final out = <OrderLineItem>[];
    for (final e in itemsRaw) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final qtyRaw = m['quantity'];
      final qty =
          qtyRaw is int
              ? qtyRaw
              : int.tryParse(qtyRaw?.toString() ?? '') ?? 1;

      final rawTitle = m['title'] as String?;
      final lineTitle =
          (rawTitle != null && rawTitle.trim().isNotEmpty)
              ? rawTitle.trim()
              : (m['product_title'] as String?) ??
                  _stringFromNested(m, ['variant', 'product', 'title']) ??
                  'Item';

      String? variantTitle = _stringFromNested(m, ['variant', 'title']);
      if (variantTitle != null && variantTitle == lineTitle) {
        variantTitle = null;
      }

      final thumb =
          (m['thumbnail'] as String? ?? m['thumbnail_url'] as String?)
              ?.trim();

      dynamic sub = m['subtotal'] ?? m['total'] ?? m['original_total'];
      if (sub == null && m['detail'] is Map<String, dynamic>) {
        final d = m['detail'] as Map<String, dynamic>;
        sub = d['subtotal'] ?? d['total'];
      }
      if (sub == null) {
        final unit = m['unit_price'];
        if (unit is Map<String, dynamic>) {
          final v = unit['value'];
          final prec = unit['precision'] as int?;
          if (v is num) {
            sub = <String, dynamic>{
              'value': v.toDouble() * qty,
              'precision': prec,
            };
          }
        } else if (unit is num) {
          sub = unit.toDouble() * qty;
        }
      }

      final linePrice = _formatTotal(sub, currency);

      out.add(
        OrderLineItem(
          title: lineTitle,
          variantTitle: variantTitle,
          quantity: qty,
          linePrice: linePrice,
          thumbnailUrl: (thumb != null && thumb.isNotEmpty) ? thumb : null,
        ),
      );
    }
    return out;
  }

  static String? _formatPlacedAt(dynamic created) {
    if (created is! String || created.isEmpty) return null;
    try {
      final dt = DateTime.parse(created).toLocal();
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final m = months[dt.month - 1];
      String two(int n) => n.toString().padLeft(2, '0');
      return '$m ${dt.day}, ${dt.year} · ${two(dt.hour)}:${two(dt.minute)}';
    } catch (_) {
      return created;
    }
  }

  static String? _stringFromNested(Map<String, dynamic> map, List<String> path) {
    dynamic cur = map;
    for (final key in path) {
      if (cur is! Map<String, dynamic>) return null;
      cur = cur[key];
    }
    return cur is String ? cur : null;
  }

  static String _humanizeStatus(String raw) {
    if (raw.isEmpty) return 'Pending';
    return raw
        .split('_')
        .map(
          (w) =>
              w.isEmpty
                  ? ''
                  : '${w[0].toUpperCase()}${w.length > 1 ? w.substring(1).toLowerCase() : ''}',
        )
        .join(' ');
  }

  static String _formatTotal(dynamic total, String currency) {
    if (total == null) return '—';
    if (total is String) {
      final t = total.trim();
      if (t.isEmpty) return '—';
      return t;
    }
    if (total is Map<String, dynamic>) {
      final v = total['value'] ?? total['amount'];
      if (v is num) {
        return _formatAmount(v.toDouble(), currency, total['precision'] as int?);
      }
      if (v is String) {
        final d = double.tryParse(v);
        if (d != null) {
          return _formatAmount(d, currency, total['precision'] as int?);
        }
      }
    }
    if (total is num) {
      return _formatAmount(total.toDouble(), currency, null);
    }
    return '—';
  }

  static String _formatAmount(double value, String currency, int? precision) {
    double display = value;
    if (precision != null &&
        precision >= 2 &&
        value > 1000 &&
        value == value.roundToDouble()) {
      display = value / 100;
    } else if (value > 10000 && value == value.roundToDouble()) {
      display = value / 100;
    }

    final formatted =
        display == display.roundToDouble()
            ? display.toStringAsFixed(0)
            : display.toStringAsFixed(2);

    if (currency.isNotEmpty) {
      return '$formatted ${currency.toUpperCase()}';
    }
    return '\$$formatted';
  }

  Map<String, dynamic> toJson() {
    return {
      'apiId': apiId,
      'category': category,
      'title': title,
      'price': price,
      'items': items,
      'orderId': orderId,
      'status': status,
      'placedAt': placedAt,
    };
  }
}
