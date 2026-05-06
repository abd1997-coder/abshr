part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Category> categories;
  final List<Seller> sellers;
  final List<Offer> offers;
  final List<MenuItem> latestProducts;
  final List<MenuItem> bestSellerProducts;

  /// `null` = show all sellers; otherwise filter by collection id (`pcol_…`).
  final String? sellersCollectionId;

  final bool sellersLoading;

  const HomeLoaded({
    required this.categories,
    required this.sellers,
    this.offers = const [],
    this.latestProducts = const [],
    this.bestSellerProducts = const [],
    this.sellersCollectionId,
    this.sellersLoading = false,
  });

  HomeLoaded copyWith({
    List<Category>? categories,
    List<Seller>? sellers,
    List<Offer>? offers,
    List<MenuItem>? latestProducts,
    List<MenuItem>? bestSellerProducts,
    String? sellersCollectionId,
    bool? sellersLoading,
    bool updateSellersCollectionId = false,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      sellers: sellers ?? this.sellers,
      offers: offers ?? this.offers,
      latestProducts: latestProducts ?? this.latestProducts,
      bestSellerProducts: bestSellerProducts ?? this.bestSellerProducts,
      sellersCollectionId:
          updateSellersCollectionId
              ? sellersCollectionId
              : this.sellersCollectionId,
      sellersLoading: sellersLoading ?? this.sellersLoading,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    sellers,
    offers,
    latestProducts,
    bestSellerProducts,
    sellersCollectionId,
    sellersLoading,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
