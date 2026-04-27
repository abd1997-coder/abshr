import 'package:flutter/material.dart';
import 'package:marketplace/features/restaurant/domain/entities/restaurant_detail.dart';
import 'package:marketplace/core/constants/app_colors.dart';

class RestaurantInfoRow extends StatelessWidget {
  final RestaurantDetail detail;
  final Color orangeColor;
  final Color darkGreyColor;

  const RestaurantInfoRow({
    super.key,
    required this.detail,
    required this.orangeColor,
    required this.darkGreyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Icon(Icons.star, size: 18, color: orangeColor),
            const SizedBox(width: 4),
            Text(
              detail.rating,
              style: TextStyle(
                color: AppColors.grey700,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 18,
              color: AppColors.grey600,
            ),
            const SizedBox(width: 4),
            Text(
              detail.delivery,
              style: TextStyle(color: AppColors.grey600, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Icon(Icons.schedule, size: 18, color: AppColors.grey600),
            const SizedBox(width: 4),
            Text(
              detail.time,
              style: TextStyle(color: AppColors.grey600, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
