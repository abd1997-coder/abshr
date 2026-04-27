import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/features/home/domain/entities/seller.dart';

import '../../data/models/restaurant_detail_model.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/restaurant_detail.dart';
import '../../domain/repositories/restaurant_repository.dart';

part 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit(this._repository) : super(RestaurantInitial());

  final RestaurantRepository _repository;

  static const int _pageSize = 20;

  Future<void> loadRestaurant(
    String id,
    String name, {
    Seller? initialSeller,
  }) async {
    emit(RestaurantLoading());

    if (initialSeller != null && initialSeller.id == id) {
      final detail = RestaurantDetailModel.fromSeller(initialSeller);
      await _loadFirstProductPage(id, detail);
      return;
    }

    final detailResult = await _repository.getRestaurantDetail(id, name);

    detailResult.fold((failure) => emit(RestaurantError(failure.message)), (
      detail,
    ) {
      if (detail == null) {
        emit(const RestaurantError('Restaurant not found'));
        return;
      }

      _loadFirstProductPage(id, detail);
    });
  }

  Future<void> _loadFirstProductPage(
    String sellerId,
    RestaurantDetail detail,
  ) async {
    final category =
        detail.categories.isNotEmpty ? detail.categories.first : 'All';
    final result = await _repository.getSellerProducts(
      sellerId,
      limit: _pageSize,
      offset: 0,
    );

    result.fold((failure) => emit(RestaurantError(failure.message)), (page) {
      emit(
        RestaurantLoaded(
          detail: detail,
          menuItems: page.products,
          selectedCategory: category,
          nextOffset: page.requestedOffset + page.products.length,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    });
  }

  /// Pull-to-refresh: reload first page from mobile sellers products API.
  Future<bool> refreshSellerProducts(String sellerId) async {
    final current = state;
    if (current is! RestaurantLoaded) return false;

    final result = await _repository.getSellerProducts(
      sellerId,
      limit: _pageSize,
      offset: 0,
    );

    return result.fold(
      (_) => false,
      (page) {
        emit(
          RestaurantLoaded(
            detail: current.detail,
            menuItems: page.products,
            selectedCategory: current.selectedCategory,
            nextOffset: page.requestedOffset + page.products.length,
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
        return true;
      },
    );
  }

  /// Infinite scroll / footer load: next page.
  Future<bool> loadMoreSellerProducts(String sellerId) async {
    final current = state;
    if (current is! RestaurantLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return false;
    }

    emit(current.copyWith(isLoadingMore: true));
    final forLoad = state as RestaurantLoaded;

    final result = await _repository.getSellerProducts(
      sellerId,
      limit: _pageSize,
      offset: forLoad.nextOffset,
    );

    return result.fold(
      (_) {
        emit(forLoad.copyWith(isLoadingMore: false));
        return false;
      },
      (page) {
        emit(
          RestaurantLoaded(
            detail: forLoad.detail,
            menuItems: [...forLoad.menuItems, ...page.products],
            selectedCategory: forLoad.selectedCategory,
            nextOffset: forLoad.nextOffset + page.products.length,
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
        return true;
      },
    );
  }

  void selectCategory(String restaurantId, String category) {
    final current = state;
    if (current is! RestaurantLoaded) return;
    if (current.selectedCategory == category) return;
    emit(current.copyWith(selectedCategory: category));
  }
}
