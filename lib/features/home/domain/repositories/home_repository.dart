import 'package:dartz/dartz.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../entities/category.dart';
import '../entities/offer.dart';
import '../entities/seller.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Seller>>> getSellers({
    String? q,
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, List<Seller>>> getSellersForCollection({
    required String collectionId,
    int limit = 10,
    int offset = 0,
    int sellerLimit = 6,
  });

  Future<Either<Failure, List<Offer>>> getOffers({
    int limit = 20,
    int offset = 0,
  });
}
