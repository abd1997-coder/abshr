import 'package:flutter/material.dart';
import 'package:marketplace/features/restaurant/domain/entities/restaurant_detail.dart';
import 'package:marketplace/core/constants/app_colors.dart';

class RestaurantBanner extends StatelessWidget {
  final RestaurantDetail detail;
  final Color darkGreyColor;

  const RestaurantBanner({
    super.key,
    required this.detail,
    required this.darkGreyColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Image.network(
              detail.imageUrl,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      size: 64,
                      color: AppColors.whiteOpacity5,
                    ),
                  ),
            ),
          ),
          if (detail.logoUrl.trim().isNotEmpty)
            Positioned(
              left: 20,
              bottom: 36,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.blackOpacity1, blurRadius: 10),
                  ],
                ),
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.grey600.withValues(alpha: 0.2),
                  backgroundImage: NetworkImage(detail.logoUrl.trim()),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.blackOpacity3, AppColors.transparent],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: Directionality.of(context) == TextDirection.ltr ? 16 : null,
            right: Directionality.of(context) == TextDirection.rtl ? 16 : null,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.blackOpacity1, blurRadius: 8),
                  ],
                ),
                child: Icon(Icons.arrow_back, size: 18, color: darkGreyColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
