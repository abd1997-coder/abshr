part of 'restaurant_cubit.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final RestaurantDetail detail;
  final List<MenuItem> menuItems;
  final String selectedCategory;
  final int nextOffset;
  final bool hasMore;
  final bool isLoadingMore;

  const RestaurantLoaded({
    required this.detail,
    required this.menuItems,
    required this.selectedCategory,
    required this.nextOffset,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  List<MenuItem> get visibleMenuItems {
    if (selectedCategory == 'All') return menuItems;
    return menuItems
        .where((m) => m.subtitle == selectedCategory)
        .toList();
  }

  RestaurantLoaded copyWith({
    RestaurantDetail? detail,
    List<MenuItem>? menuItems,
    String? selectedCategory,
    int? nextOffset,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return RestaurantLoaded(
      detail: detail ?? this.detail,
      menuItems: menuItems ?? this.menuItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      nextOffset: nextOffset ?? this.nextOffset,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        detail,
        menuItems,
        selectedCategory,
        nextOffset,
        hasMore,
        isLoadingMore,
      ];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object?> get props => [message];
}
