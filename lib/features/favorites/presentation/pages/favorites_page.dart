import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/features/favorites/domain/entities/favorite_product.dart';
import 'package:marketplace/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:marketplace/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:marketplace/features/product_detail/presentation/pages/product_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final FavoritesCubit _favoritesCubit = getIt.get<FavoritesCubit>();

  @override
  void initState() {
    super.initState();
    _favoritesCubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppConstants.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(AppStrings.favorites),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        bloc: _favoritesCubit,
        builder: (context, state) {
          if (state.loading && state.products.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: accent, strokeWidth: 2.5),
            );
          }

          if (state.products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: accent,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      AppStrings.noFavoritesYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.tapHeartToSaveProducts,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            itemCount: state.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = state.products[index];
              return _FavoriteProductTile(
                product: product,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder:
                          (_) => ProductDetailPage(
                            productId: product.id,
                            variantId: product.variantId,
                          ),
                    ),
                  );
                },
                onRemove: () => _favoritesCubit.remove(product.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteProductTile extends StatelessWidget {
  const _FavoriteProductTile({
    required this.product,
    required this.onTap,
    required this.onRemove,
  });

  final FavoriteProduct product;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final accent = AppConstants.primaryColor;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 82,
                  height: 82,
                  child:
                      product.imageUrl.isNotEmpty
                          ? Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => _FavoriteImageFallback(
                                  accent: accent,
                                ),
                          )
                          : _FavoriteImageFallback(accent: accent),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    if (product.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        product.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (product.priceLabel.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        product.priceLabel,
                        style: TextStyle(
                          color: accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.favorite_rounded, color: accent),
                tooltip: AppStrings.removeFromFavorites,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteImageFallback extends StatelessWidget {
  const _FavoriteImageFallback({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: accent.withValues(alpha: 0.08),
      child: Icon(Icons.shopping_bag_outlined, color: accent, size: 30),
    );
  }
}
