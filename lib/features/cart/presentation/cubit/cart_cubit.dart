import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;

  CartCubit(this.repository) : super(CartInitial());

  Future<void> load() async {
    // Avoid CartLoading when we already have items so UIs (e.g. home badge)
    // keep showing the last count during refresh instead of flashing to 0.
    if (state is CartInitial || state is CartError) {
      emit(CartLoading());
    }
    try {
      final items = await repository.getItems();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> add(CartItem item) async {
    await repository.addItem(item);
    await load();
  }

  /// Add by variant id (store API).
  Future<void> addByVariant(String variantId, {int quantity = 1}) async {
    await repository.addLineItem(variantId, quantity);
    await load();
  }

  /// Remove by line item id or item id.
  Future<void> remove(String lineItemIdOrItemId) async {
    await repository.removeItem(lineItemIdOrItemId);
    await load();
  }

  Future<void> updateQuantity(String id, int qty) async {
    final snapshot = state is CartLoaded ? (state as CartLoaded).items : null;
    try {
      await repository.updateQuantity(id, qty);
      await load();
    } catch (e) {
      if (snapshot != null) {
        emit(CartLoaded(snapshot));
      } else {
        emit(CartError(e.toString()));
      }
    }
  }

  Future<void> clear() async {
    await repository.clear();
    await load();
  }
}
