import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/features/favorites/domain/entities/favorite_product.dart';
import 'package:marketplace/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:marketplace/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:marketplace/features/restaurant/domain/entities/menu_item.dart';
import 'package:marketplace/core/constants/app_colors.dart';
import 'package:marketplace/l10n/app_localizations.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final Color orangeColor;
  final Color darkGreyColor;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.orangeColor,
    required this.darkGreyColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackOpacity08,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.hide_image_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        ),
                  ),
                  PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      bloc: getIt.get<FavoritesCubit>(),
                      builder: (context, state) {
                        final isFavorite = state.contains(item.id);
                        return Material(
                          color: Colors.white.withValues(alpha: 0.94),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () async {
                              await getIt.get<FavoritesCubit>().toggle(
                                FavoriteProduct(
                                  id: item.id,
                                  name: item.name,
                                  imageUrl: item.imageUrl,
                                  subtitle: item.subtitle,
                                  priceLabel:
                                      item.price.isNotEmpty
                                          ? '${l10n.currencySymbol}${item.price}'
                                          : '',
                                  variantId: item.variantId,
                                ),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFavorite
                                        ? AppStrings.removedFromFavorites
                                        : AppStrings.addedToFavorites,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(milliseconds: 1200),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color:
                                    isFavorite
                                        ? orangeColor
                                        : Colors.grey.shade800,
                                size: 19,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: darkGreyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (item.price.isNotEmpty)
                    Text(
                      '${l10n.currencySymbol}${item.price}',
                      style: TextStyle(
                        color: orangeColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 12,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
