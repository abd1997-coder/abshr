import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;
  GetCartItems(this.repository);

  Future<List<CartItem>> call() async {
    return repository.getItems();
  }
}
