import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/core/utils/storage_service.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_state.dart';
import 'package:marketplace/features/cart/presentation/pages/cart_page.dart';
import 'package:marketplace/features/home/data/models/search_result_model.dart';
import 'package:marketplace/features/home/domain/entities/seller.dart';
import 'package:marketplace/features/home/domain/repositories/home_repository.dart';
import 'package:marketplace/features/restaurant/domain/entities/menu_item.dart';
import 'package:marketplace/features/restaurant/presentation/pages/restaurant_page.dart';

/// Search screen: loads sellers and products from `/store/mobile/search?q=…&limit=10`
/// and persists recent search keywords locally.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const String _defaultSearchQuery = 'restaurant';
  static const int _searchLimit = 10;

  final HomeRepository _homeRepository = getIt.get<HomeRepository>();
  final StorageService _storage = getIt.get<StorageService>();
  final CartCubit _cartCubit = getIt.get<CartCubit>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<SearchResult> _searchResults = [];
  bool _searchLoading = false;
  String? _searchError;
  List<String> _recentKeywords = [];
  static const int _maxRecentKeywords = 15;

  void _onSearchChanged() {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _runDebouncedSearch);
  }

  Future<void> _fetchSearchResults(String q) async {
    setState(() {
      _searchLoading = true;
      _searchError = null;
    });
    final result = await _homeRepository.searchAll(
      q: q,
      limit: _searchLimit,
      offset: 0,
      type: 'all',
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _searchLoading = false;
        _searchError = failure.message;
        _searchResults = [];
      }),
      (SearchResponse searchResponse) {
        setState(() {
          _searchLoading = false;
          _searchError = null;
          _searchResults = searchResponse.results;
        });
        final typed = _searchController.text.trim();
        if (typed.isNotEmpty) {
          unawaited(_addRecentKeyword(typed));
        }
      },
    );
  }

  Future<void> _loadRecentKeywords() async {
    final raw = _storage.getString(AppConstants.searchRecentKeywordsKey);
    if (raw == null || raw.isEmpty) {
      if (mounted) setState(() => _recentKeywords = []);
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;
      final list = decoded
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (mounted) setState(() => _recentKeywords = list);
    } catch (_) {
      if (mounted) setState(() => _recentKeywords = []);
    }
  }

  Future<void> _addRecentKeyword(String keyword) async {
    final k = keyword.trim();
    if (k.isEmpty) return;
    final lower = k.toLowerCase();
    final next = List<String>.from(_recentKeywords);
    next.removeWhere((e) => e.toLowerCase() == lower);
    next.insert(0, k);
    if (next.length > _maxRecentKeywords) {
      next.removeRange(_maxRecentKeywords, next.length);
    }
    await _storage.setString(
      AppConstants.searchRecentKeywordsKey,
      jsonEncode(next),
    );
    if (mounted) setState(() => _recentKeywords = next);
  }

  void _runDebouncedSearch() {
    final raw = _searchController.text.trim();
    _fetchSearchResults(raw.isEmpty ? _defaultSearchQuery : raw);
  }

  @override
  void initState() {
    super.initState();
    _cartCubit.load();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadRecentKeywords();
      if (!mounted) return;
      _fetchSearchResults(_defaultSearchQuery);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orangeColor = AppConstants.primaryColor;
    final darkGreyColor = Colors.grey.shade800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
          color: darkGreyColor,
        ),
        title: Text(
          AppStrings.search,
          style: TextStyle(
            color: darkGreyColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BlocBuilder<CartCubit, CartState>(
              bloc: _cartCubit,
              builder: (context, cartState) {
                final count = cartState is CartLoaded
                    ? cartState.items.fold<int>(
                        0,
                        (sum, e) => sum + e.quantity,
                      )
                    : 0;
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
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
                              builder: (context) => const CartPage(),
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SizedBox(
                height: 48,
                child: AppTextField(
                  controller: _searchController,
                  hintText: AppStrings.searchSellersHint,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 22,
                  ),
                  suffixIcon: _searchController.text.trim().isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            // Recent Keywords
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.recentKeywords,
                style: TextStyle(
                  color: darkGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_recentKeywords.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppStrings.recentSearchesAppearHere,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              )
            else
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _recentKeywords.length,
                  itemBuilder: (context, index) {
                    final keyword = _recentKeywords[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _searchController.value = TextEditingValue(
                              text: keyword,
                              selection: TextSelection.collapsed(
                                offset: keyword.length,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: Text(
                                keyword,
                                style: TextStyle(
                                  color: darkGreyColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
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
            // Search results (sellers and products)
            if (_searchLoading && _searchResults.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_searchError != null && _searchResults.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _searchError!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                ),
              )
            else ...[
              if (_searchLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    color: orangeColor,
                    minHeight: 3,
                  ),
                ),
              if (_searchError != null && _searchResults.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Text(
                    _searchError!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                ),
              // Sellers section
              if (_searchResults.any((r) => r.type == 'seller')) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppStrings.sellers,
                    style: TextStyle(
                      color: darkGreyColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ..._searchResults
                    .where((r) => r.type == 'seller' && r.seller != null)
                    .map(
                      (r) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _SuggestedSellerTile(
                          seller: r.seller!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantPage(
                                  restaurantId: r.seller!.id,
                                  restaurantName: r.seller!.name,
                                  initialSeller: r.seller,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                const SizedBox(height: 24),
              ],
              // Products section
              if (_searchResults.any((r) => r.type == 'product')) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppStrings.products,
                    style: TextStyle(
                      color: darkGreyColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ..._searchResults
                    .where((r) => r.type == 'product' && r.product != null)
                    .map(
                      (r) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _SuggestedProductTile(product: r.product!),
                      ),
                    ),
                const SizedBox(height: 24),
              ],
              if (_searchResults.isEmpty && !_searchLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppStrings.noResultsFound,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SuggestedSellerTile extends StatelessWidget {
  final Seller seller;
  final VoidCallback onTap;

  const _SuggestedSellerTile({
    required this.seller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final darkGreyColor = Colors.grey.shade800;
    final thumb = seller.coverPhotoUrl.trim().isNotEmpty
        ? seller.coverPhotoUrl.trim()
        : seller.imageUrl.trim();
    final sub = seller.locationLine.isNotEmpty
        ? seller.locationLine
        : seller.handleLine;
    final reviews = seller.reviewCount > 0
        ? '${seller.reviewCount} ${AppStrings.reviews}'
        : AppStrings.noReviewsYet;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: Image.network(
                thumb,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.storefront_outlined,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.name,
                      style: TextStyle(
                        color: darkGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (sub.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        sub,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          seller.rating,
                          style: TextStyle(
                            color: darkGreyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            reviews,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestedProductTile extends StatelessWidget {
  final MenuItem product;

  const _SuggestedProductTile({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final darkGreyColor = Colors.grey.shade800;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to product details page
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: Image.network(
                product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        color: darkGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        product.subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 18,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.price} ${AppStrings.currency}',
                          style: TextStyle(
                            color: darkGreyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
