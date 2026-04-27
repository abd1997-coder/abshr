import 'package:dartz/dartz.dart' as dartz;
import 'package:marketplace/core/errors/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrderRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<dartz.Either<Failure, List<Order>>> getOrders() async {
    try {
      final models = await _remoteDataSource.getOrders(limit: 10, offset: 0);
      return dartz.Right(List<Order>.from(models));
    } catch (e) {
      return dartz.Left(ServerFailure('Failed to load orders'));
    }
  }
}
