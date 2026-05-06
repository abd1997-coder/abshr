import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/home/domain/entities/seller.dart';
import 'package:marketplace/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:marketplace/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:marketplace/features/restaurant/presentation/widgets/menu_item_card.dart';
import 'package:marketplace/features/restaurant/presentation/widgets/restaurant_banner.dart';
import 'package:marketplace/features/restaurant/presentation/widgets/restaurant_info_row.dart';
import 'package:marketplace/features/restaurant/presentation/widgets/restaurant_page_shimmer.dart';
import 'package:marketplace/l10n/app_localizations.dart';

class RestaurantPage extends StatelessWidget {
  final String? restaurantId;
  final String? restaurantName;
  final Seller? initialSeller;

  const RestaurantPage({
    super.key,
    this.restaurantId,
    this.restaurantName,
    this.initialSeller,
  });

  @override
  Widget build(BuildContext context) {
    final id = restaurantId ?? restaurantName ?? '1';
    final name = restaurantName ?? AppStrings.defaultRestaurantName;

    return BlocProvider(
      create:
          (_) =>
              getIt.get<RestaurantCubit>()
                ..loadRestaurant(id, name, initialSeller: initialSeller),
      child: _RestaurantPageContent(restaurantId: id),
    );
  }
}

class _RestaurantPageContent extends StatefulWidget {
  final String restaurantId;

  const _RestaurantPageContent({required this.restaurantId});

  @override
  State<_RestaurantPageContent> createState() => _RestaurantPageContentState();
}

class _RestaurantPageContentState extends State<_RestaurantPageContent> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final TextEditingController _productSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _productSearchController.addListener(_onProductSearchChanged);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _productSearchController.removeListener(_onProductSearchChanged);
    _productSearchController.dispose();
    super.dispose();
  }

  void _onProductSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final orangeColor = AppConstants.primaryColor;
    final darkGreyColor = Colors.grey.shade800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RestaurantCubit, RestaurantState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is RestaurantLoading || state is RestaurantInitial) {
            return const RestaurantPageShimmer();
          }
          if (state is RestaurantError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppStrings.back),
                  ),
                ],
              ),
            );
          }
          final loaded = state as RestaurantLoaded;
          final detail = loaded.detail;
          final categoryItems = loaded.visibleMenuItems;
          final productSearchQuery =
              _productSearchController.text.trim().toLowerCase();
          final visibleItems =
              productSearchQuery.isEmpty
                  ? categoryItems
                  : categoryItems
                      .where(
                        (item) =>
                            item.name.toLowerCase().contains(
                              productSearchQuery,
                            ) ||
                            item.subtitle.toLowerCase().contains(
                              productSearchQuery,
                            ),
                      )
                      .toList();

          final detailToShow = detail;
          final categories =
              detailToShow.categories.isNotEmpty
                  ? detailToShow.categories
                  : [l10n.allFilter];

          String displayCategory(String cat) {
            return cat == 'All' ? l10n.allFilter : cat;
          }

          final selectedCategory =
              (loaded.selectedCategory.isNotEmpty)
                  ? loaded.selectedCategory
                  : (categories.isNotEmpty ? categories.first : '');

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              RestaurantBanner(
                detail: detailToShow,
                darkGreyColor: darkGreyColor,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RestaurantInfoRow(
                        detail: detailToShow,
                        orangeColor: orangeColor,
                        darkGreyColor: darkGreyColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        detailToShow.name,
                        style: TextStyle(
                          color: darkGreyColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        detailToShow.description,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: AppTextField(
                          controller: _productSearchController,
                          hintText: AppStrings.searchProductsHint,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 22,
                          ),
                          suffixIcon:
                              _productSearchController.text.trim().isNotEmpty
                                  ? GestureDetector(
                                    onTap: () {
                                      _productSearchController.clear();
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.grey.shade600,
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected =
                                selectedCategory == category ||
                                (category == 'All' &&
                                    selectedCategory == l10n.allFilter);

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<RestaurantCubit>()
                                      .selectCategory(
                                        widget.restaurantId,
                                        category == 'All' ? 'All' : category,
                                      );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? orangeColor
                                            : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      displayCategory(category),
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : darkGreyColor,
                                        fontSize: 13,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '$selectedCategory (${visibleItems.length})',
                        style: TextStyle(
                          color: darkGreyColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (visibleItems.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            loaded.menuItems.isEmpty
                                ? AppStrings.noProductsYet
                                : AppStrings.noProductsInCategory,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.61,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ProductDetailPage(
                                    productId: visibleItems[index].id,
                                    variantId: visibleItems[index].variantId,
                                  ),
                            ),
                          );
                        },
                        child: MenuItemCard(
                          item: visibleItems[index],
                          orangeColor: orangeColor,
                          darkGreyColor: darkGreyColor,
                        ),
                      ),
                      childCount: visibleItems.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}
