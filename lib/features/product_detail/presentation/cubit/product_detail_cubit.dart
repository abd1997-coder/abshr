import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_detail_repository.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailRepository _repository;

  ProductDetailCubit(this._repository) : super(ProductDetailInitial());

  Future<void> loadProductDetail(String productId) async {
    emit(ProductDetailLoading());
    final result = await _repository.getProductDetail(productId);
    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (productDetail) => emit(ProductDetailLoaded(productDetail)),
    );
  }
}
