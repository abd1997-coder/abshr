import '../repositories/cart_repository.dart';

class UpdateCartQuantity {
  final CartRepository repository;
  UpdateCartQuantity(this.repository);

  Future<void> call(String itemId, int quantity) async {
    return repository.updateQuantity(itemId, quantity);
  }
}
