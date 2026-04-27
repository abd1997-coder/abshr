import 'package:dartz/dartz.dart';
import 'package:marketplace/core/errors/failures.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_detail_repository.dart';
import '../datasources/product_detail_remote_datasource.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailRemoteDataSource remoteDataSource;

  ProductDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProductDetail>> getProductDetail(
    String productId,
  ) async {
    try {
      final model = await remoteDataSource.getProductDetail(productId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(
        ServerFailure(
          e is FormatException ? e.message : 'Failed to load product',
        ),
      );
    }
  }
}
