import 'package:dartz/dartz.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../entities/restaurant_detail.dart';
import '../entities/seller_products_page.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, RestaurantDetail?>> getRestaurantDetail(
    String id,
    String name,
  );
  Future<Either<Failure, SellerProductsPageResult>> getSellerProducts(
    String sellerId, {
    int limit = 20,
    int offset = 0,
  });
}
