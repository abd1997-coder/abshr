import 'package:flutter/material.dart';
import '../../domain/entities/product_detail.dart';

class IngredientBadge extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientBadge({required this.ingredient, super.key});

  IconData _getIconData() {
    switch (ingredient.icon.toLowerCase()) {
      case 'salt':
        return Icons.grain;
      case 'chicken':
        return Icons.set_meal;
      case 'onion':
        return Icons.apple;
      case 'garlic':
        return Icons.brightness_1;
      case 'peppers':
        return Icons.local_florist;
      case 'ginger':
        return Icons.eco;
      case 'broccoli':
        return Icons.park;
      case 'orange':
        return Icons.circle;
      case 'walnut':
        return Icons.circle;
      default:
        return Icons.fastfood;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color:
                ingredient.isAllergy
                    ? Colors.orange.shade100
                    : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getIconData(),
            color: ingredient.isAllergy ? Colors.orange : Colors.grey,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            ingredient.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
