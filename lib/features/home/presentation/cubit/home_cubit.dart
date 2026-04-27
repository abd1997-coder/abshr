import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/offer.dart';
import '../../domain/entities/seller.dart';
import '../../domain/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  /// When [silent] is true, keeps the current UI (e.g. pull-to-refresh) instead of [HomeLoading].
  Future<void> loadHome({bool silent = false}) async {
    if (!silent) emit(HomeLoading());

    final String? filterId =
        state is HomeLoaded ? (state as HomeLoaded).sellersCollectionId : null;

    final categoriesResult = await _repository.getCategories();
    final sellersResult =
        filterId == null
            ? await _repository.getSellers()
            : await _repository.getSellersForCollection(collectionId: filterId);
    final offersResult = await _repository.getOffers(limit: 20, offset: 0);

    categoriesResult.fold((failure) => emit(HomeError(failure.message)), (
      categories,
    ) {
      sellersResult.fold((failure) => emit(HomeError(failure.message)), (
        sellers,
      ) {
        final offers = offersResult.fold((_) => <Offer>[], (o) => o);
        emit(
          HomeLoaded(
            categories: categories,
            sellers: sellers,
            offers: offers,
            sellersCollectionId: filterId,
            sellersLoading: false,
          ),
        );
      });
    });
  }

  /// `collectionId` null = All categories (unfiltered sellers).
  Future<void> selectCategoryFilter(String? collectionId) async {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    if (current.sellersCollectionId == collectionId && !current.sellersLoading) {
      return;
    }

    final snapshot = current;
    emit(
      current.copyWith(
        sellersLoading: true,
        updateSellersCollectionId: true,
        sellersCollectionId: collectionId,
      ),
    );

    final result =
        collectionId == null
            ? await _repository.getSellers()
            : await _repository.getSellersForCollection(collectionId: collectionId);

    if (state is! HomeLoaded) return;
    final after = state as HomeLoaded;

    result.fold(
      (_) => emit(snapshot.copyWith(sellersLoading: false)),
      (List<Seller> sellers) {
        emit(
          after.copyWith(
            sellers: sellers,
            sellersLoading: false,
          ),
        );
      },
    );
  }
}
