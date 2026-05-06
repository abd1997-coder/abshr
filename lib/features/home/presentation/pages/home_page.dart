import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/navigation/app_route_observer.dart';
import 'package:marketplace/core/constants/app_assets.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/core/utils/storage_service.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_state.dart';
import 'package:marketplace/features/cart/presentation/pages/cart_page.dart';
import 'package:marketplace/features/home/presentation/widgets/drawer.dart';
import 'package:marketplace/features/home/domain/entities/seller.dart';
import 'package:marketplace/features/home/presentation/cubit/home_cubit.dart';
import 'package:marketplace/features/home/presentation/pages/all_categories_page.dart';
import 'package:marketplace/features/home/presentation/pages/all_sellers_page.dart';
import 'package:marketplace/features/home/presentation/pages/search_page.dart';
import 'package:marketplace/features/restaurant/presentation/pages/restaurant_page.dart';
import 'package:marketplace/features/home/data/models/offer_model.dart';
import 'package:marketplace/features/home/presentation/widgets/home_offers_slider.dart';
import 'package:marketplace/features/home/presentation/widgets/home_widgets.dart';
import 'package:marketplace/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  DateTime? _lastPressed;
  late final HomeCubit _homeCubit = getIt.get<HomeCubit>();
  late final CartCubit _cartCubit = getIt.get<CartCubit>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _homeCubit.loadHome();
    _cartCubit.load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      appRouteObserver.unsubscribe(this);
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _cartCubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orangeColor = AppConstants.primaryColor;
    final darkGreyColor = Colors.grey.shade800;
    final storedName = getIt.get<StorageService>().getString(
      AppConstants.userNameKey,
    );
    final displayName =
        (storedName != null && storedName.trim().isNotEmpty)
            ? storedName.trim()
            : l10n.guest;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastPressed != null &&
            now.difference(_lastPressed!) < const Duration(seconds: 2)) {
          SystemNavigator.pop();
        }
        _lastPressed = now;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exitConfirm),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        onDrawerChanged: (isOpen) => setState(() => _isDrawerOpen = isOpen),
        drawer: DrawerWidget(),
        backgroundColor: Colors.white,
        body: BlocBuilder<HomeCubit, HomeState>(
          bloc: _homeCubit,
          builder: (context, homeState) {
            if (homeState is HomeLoading || homeState is HomeInitial) {
              return const HomeShimmerLoading();
            }
            if (homeState is HomeError) {
              return SafeArea(
                child: RefreshIndicator(
                  color: orangeColor,
                  onRefresh: () async {
                    await Future.wait([
                      _homeCubit.loadHome(silent: true),
                      _cartCubit.load(),
                    ]);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            MediaQuery.paddingOf(context).vertical,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(homeState.message),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => _homeCubit.loadHome(),
                              child: Text(AppStrings.retry),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            final loadedState = homeState as HomeLoaded;
            final categories = loadedState.categories;
            final sellers = loadedState.sellers;
            final offers = loadedState.offers;
            final latestProducts = loadedState.latestProducts;
            final bestSellerProducts = loadedState.bestSellerProducts;
            final sellersCollectionId = loadedState.sellersCollectionId;
            final sellersLoading = loadedState.sellersLoading;
            final visibleSellers = sellers.take(3).toList();

            return SafeArea(
              child: RefreshIndicator(
                color: orangeColor,
                onRefresh: () async {
                  await Future.wait([
                    _homeCubit.loadHome(silent: true),
                    _cartCubit.load(),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_isDrawerOpen) {
                                  Navigator.of(context).pop();
                                } else {
                                  _scaffoldKey.currentState?.openDrawer();
                                }
                              },
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    _isDrawerOpen
                                        ? orangeColor
                                        : Colors.grey.shade200,
                                child: Icon(
                                  Icons.menu,
                                  color:
                                      _isDrawerOpen
                                          ? Colors.white
                                          : darkGreyColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  AppAssets.logo,
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const Spacer(),
                            BlocBuilder<CartCubit, CartState>(
                              bloc: _cartCubit,
                              builder: (context, cartState) {
                                final count =
                                    cartState is CartLoaded
                                        ? cartState.items.fold<int>(
                                          0,
                                          (sum, e) => sum + e.quantity,
                                        )
                                        : 0;
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.grey.shade700,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.shopping_bag_outlined,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => const CartPage(),
                                            ),
                                          ).then((_) => _cartCubit.load());
                                        },
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                    if (count > 0)
                                      Positioned(
                                        top: -4,
                                        right: -4,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            minWidth: 18,
                                            minHeight: 18,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: orangeColor,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            count > 99 ? '99+' : '$count',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Search
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 48,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
                                ),
                              );
                            },
                            child: AbsorbPointer(
                              child: AppTextField(
                                hintText: AppStrings.searchDishesHint,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade600,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Offers
                      if (offers.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        HomeOffersSlider(offers: offers),
                      ],
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.allCategories,
                              style: TextStyle(
                                color: darkGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => AllCategoriesPage(
                                          categories: categories,
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                AppStrings.seeAll,
                                style: TextStyle(
                                  color: orangeColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: 1 + categories.take(8).length,
                          itemBuilder: (context, index) {
                            final isSelected =
                                index == 0
                                    ? sellersCollectionId == null
                                    : (index - 1 < categories.length &&
                                        categories[index - 1].id ==
                                            sellersCollectionId);
                            final name =
                                index == 0
                                    ? AppStrings.allFilter
                                    : categories[index - 1].name;
                            final rawImage =
                                index == 0
                                    ? ''
                                    : categories[index - 1].imageUrl.trim();
                            final imageUrl =
                                rawImage.isEmpty
                                    ? ''
                                    : OfferModel.resolveAbsoluteUrl(rawImage);
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                index == 0
                                                    ? const AllSellersPage()
                                                    : AllSellersPage(
                                                      initialCategory:
                                                          categories[index - 1],
                                                    ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 72,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? orangeColor
                                                      : Colors.grey.shade300,
                                              width: 2,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(2.5),
                                          child: ClipOval(
                                            child: SizedBox(
                                              width: 52,
                                              height: 52,
                                              child:
                                                  imageUrl.isNotEmpty
                                                      ? Image.network(
                                                        imageUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (
                                                              _,
                                                              __,
                                                              ___,
                                                            ) => ColoredBox(
                                                              color:
                                                                  Colors
                                                                      .grey
                                                                      .shade100,
                                                              child: Icon(
                                                                Icons
                                                                    .category_outlined,
                                                                size: 28,
                                                                color:
                                                                    Colors
                                                                        .grey
                                                                        .shade600,
                                                              ),
                                                            ),
                                                      )
                                                      : ColoredBox(
                                                        color:
                                                            isSelected
                                                                ? orangeColor
                                                                    .withValues(
                                                                      alpha:
                                                                          0.12,
                                                                    )
                                                                : Colors
                                                                    .grey
                                                                    .shade100,
                                                        child: Icon(
                                                          index == 0
                                                              ? Icons
                                                                  .grid_view_rounded
                                                              : Icons
                                                                  .category_outlined,
                                                          size: 28,
                                                          color:
                                                              isSelected
                                                                  ? orangeColor
                                                                  : darkGreyColor,
                                                        ),
                                                      ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? orangeColor
                                                    : darkGreyColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.sellers,
                              style: TextStyle(
                                color: darkGreyColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AllSellersPage(),
                                  ),
                                );
                              },
                              child: Text(
                                AppStrings.seeAll,
                                style: TextStyle(
                                  color: orangeColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (sellersLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 32,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: orangeColor,
                              ),
                            ),
                          ),
                        )
                      else if (sellers.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 32,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.store_outlined,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppStrings.noSellersAtMoment,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () => _homeCubit.loadHome(),
                                  icon: const Icon(Icons.refresh, size: 20),
                                  label: Text(AppStrings.retry),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...visibleSellers.map(
                          (Seller seller) => Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RestaurantPage(
                                          restaurantId: seller.id,
                                          restaurantName: seller.name,
                                          initialSeller: seller,
                                        ),
                                  ),
                                );
                              },
                              child: SellerCard(seller: seller),
                            ),
                          ),
                        ),
                      if (latestProducts.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        HomeProductSection(
                          title: AppStrings.latestProducts,
                          products: latestProducts,
                          orangeColor: orangeColor,
                          darkGreyColor: darkGreyColor,
                        ),
                      ],
                      if (bestSellerProducts.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        HomeProductSection(
                          title: AppStrings.bestProducts,
                          products: bestSellerProducts,
                          orangeColor: orangeColor,
                          darkGreyColor: darkGreyColor,
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
