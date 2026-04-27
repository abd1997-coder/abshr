import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddCartItem {
  final CartRepository repository;
  AddCartItem(this.repository);

  Future<void> call(CartItem item) async {
    return repository.addItem(item);
  }
}
