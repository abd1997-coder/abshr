import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository _repository;

  OrdersCubit(this._repository) : super(OrdersInitial());

  Future<void> loadOrders() async {
    emit(OrdersLoading());
    final result = await _repository.getOrders();
    result.fold((failure) => emit(OrdersError(failure.message)), (orders) {
      emit(OrdersLoaded(orders));
    });
  }
}
