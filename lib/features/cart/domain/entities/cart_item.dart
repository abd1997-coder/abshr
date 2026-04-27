import 'package:equatable/equatable.dart';
import 'package:marketplace/features/restaurant/domain/entities/menu_item.dart';

class CartItem extends Equatable {
  final MenuItem item;
  final int quantity;
  /// Line item id from store API; required for remove line item.
  final String? lineItemId;
  /// Variant id from store API; required for add line item.
  final String? variantId;

  const CartItem({
    required this.item,
    required this.quantity,
    this.lineItemId,
    this.variantId,
  });

  CartItem copyWith({
    MenuItem? item,
    int? quantity,
    String? lineItemId,
    String? variantId,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      lineItemId: lineItemId ?? this.lineItemId,
      variantId: variantId ?? this.variantId,
    );
  }

  @override
  List<Object?> get props => [item, quantity, lineItemId, variantId];
}
