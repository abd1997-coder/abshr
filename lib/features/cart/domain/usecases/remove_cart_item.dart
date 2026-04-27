import '../repositories/cart_repository.dart';

class RemoveCartItem {
  final CartRepository repository;
  RemoveCartItem(this.repository);

  Future<void> call(String itemId) async {
    return repository.removeItem(itemId);
  }
}
