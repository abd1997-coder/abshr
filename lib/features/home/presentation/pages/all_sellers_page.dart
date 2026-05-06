import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/home/domain/entities/category.dart';
import 'package:marketplace/features/home/domain/entities/seller.dart';
import 'package:marketplace/features/home/domain/repositories/home_repository.dart';
import 'package:marketplace/features/home/presentation/widgets/home_widgets.dart';
import 'package:marketplace/features/restaurant/presentation/pages/restaurant_page.dart';

class AllSellersPage extends StatefulWidget {
  const AllSellersPage({super.key, this.initialCategory});

  final Category? initialCategory;

  @override
  State<AllSellersPage> createState() => _AllSellersPageState();
}

class _AllSellersPageState extends State<AllSellersPage> {
  final HomeRepository _repository = getIt.get<HomeRepository>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<Seller> _sellers = [];
  bool _loading = true;
  String? _error;

  bool get _isFiltered => widget.initialCategory != null;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSellers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _loadSellers);
    setState(() {});
  }

  Future<void> _loadSellers() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final query = _searchController.text.trim();
    final result =
        _isFiltered
            ? await _repository.getSellersForCollection(
              collectionId: widget.initialCategory!.id,
              limit: 50,
              sellerLimit: 50,
            )
            : await _repository.getSellers(
              q: query.isEmpty ? null : query,
              limit: 50,
              offset: 0,
            );

    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() {
          _loading = false;
          _error = failure.message;
          _sellers = [];
        });
      },
      (sellers) {
        final filtered =
            _isFiltered && query.isNotEmpty
                ? sellers
                    .where(
                      (seller) =>
                          seller.name.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          seller.locationLine.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          seller.handle.toLowerCase().contains(
                            query.toLowerCase(),
                          ),
                    )
                    .toList()
                : sellers;
        setState(() {
          _loading = false;
          _error = null;
          _sellers = filtered;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orangeColor = AppConstants.primaryColor;
    final darkGreyColor = Colors.grey.shade800;
    final title =
        _isFiltered ? widget.initialCategory!.name : AppStrings.sellers;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkGreyColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: darkGreyColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: orangeColor,
        onRefresh: _loadSellers,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            SizedBox(
              height: 48,
              child: AppTextField(
                controller: _searchController,
                hintText: AppStrings.searchSellersHint,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 22,
                ),
                suffixIcon:
                    _searchController.text.trim().isNotEmpty
                        ? GestureDetector(
                          onTap: _searchController.clear,
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.grey.shade600,
                          ),
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 18),
            if (_loading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: CircularProgressIndicator(color: orangeColor),
                ),
              )
            else if (_error != null)
              _MessageState(
                icon: Icons.error_outline_rounded,
                message: _error!,
                color: Colors.red.shade700,
              )
            else if (_sellers.isEmpty)
              _MessageState(
                icon: Icons.store_outlined,
                message: AppStrings.noSellersFound,
                color: Colors.grey.shade600,
              )
            else
              ..._sellers.map(
                (seller) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
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
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Column(
        children: [
          Icon(icon, size: 56, color: color),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
