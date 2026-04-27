import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';

class FastFoodItem {
  final String name;
  final String restaurant;
  final double price;
  final String imageUrl;

  FastFoodItem({
    required this.name,
    required this.restaurant,
    required this.price,
    required this.imageUrl,
  });
}

class PopularFastFoodPage extends StatefulWidget {
  const PopularFastFoodPage({super.key});

  @override
  State<PopularFastFoodPage> createState() => _PopularFastFoodPageState();
}

class _PopularFastFoodPageState extends State<PopularFastFoodPage> {
  /// Populated from API when a popular-products endpoint is available.
  final List<FastFoodItem> popularItems = const [];

  // Filter state
  String? selectedOffer;
  bool onlinePaymentAvailable = false;
  String? selectedDeliveryTime;
  String? selectedPricing;
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    final orangeColor = AppConstants.primaryColor;
    final darkGreyColor = Colors.grey.shade800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and controls
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Back button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: darkGreyColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Spacer(),
                    // Category tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            AppStrings.categoryBurger,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: orangeColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            color: orangeColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Search button
                    Container(
                      decoration: BoxDecoration(
                        color: darkGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.tune, color: darkGreyColor),
                        onPressed: () {
                          _showFilterDialog(
                            context,
                            orangeColor,
                            darkGreyColor,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppStrings.popularBurgers,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: darkGreyColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Popular items grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:
                    popularItems.isEmpty
                        ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              AppStrings.noPopularItemsYet,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.71,
                              ),
                          itemCount: popularItems.length,
                          itemBuilder: (context, index) {
                            final item = popularItems[index];
                            return _buildFastFoodCard(item, orangeColor);
                          },
                        ),
              ),
              const SizedBox(height: 32),
              // Section Title - Open Shops
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppStrings.openShops,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: darkGreyColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Restaurant cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildRestaurantCard(
                      AppStrings.tastyTreatGallery,
                      '⭐4.2',
                      AppStrings.freeDeliverySymbol,
                      AppStrings.deliveryTime30Min,
                      'assets/images/restaurant_tasty_treat.jpg',
                      orangeColor,
                    ),
                    const SizedBox(height: 12),
                    _buildRestaurantCard(
                      AppStrings.burgerHaven,
                      '⭐4.5',
                      AppStrings.freeDeliverySymbol,
                      AppStrings.deliveryTime25Min,
                      'assets/images/restaurant_burger_haven.jpg',
                      orangeColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(
    BuildContext context,
    Color orangeColor,
    Color darkGreyColor,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.filterYourSearch,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.close,
                                color: darkGreyColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // OFFERS Section
                      Text(
                        AppStrings.offersUpper,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: darkGreyColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children:
                            [
                              AppStrings.filterDelivery,
                              AppStrings.filterPickUp,
                              AppStrings.filterOffer,
                            ].map((offer) {
                              final isSelected = selectedOffer == offer;
                              return FilterChip(
                                label: Text(offer),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setModalState(() {
                                    selectedOffer = selected ? offer : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: orangeColor.withOpacity(0.2),
                                side: BorderSide(
                                  color:
                                      isSelected
                                          ? orangeColor
                                          : Colors.grey.shade300,
                                ),
                                labelStyle: TextStyle(
                                  color:
                                      isSelected
                                          ? orangeColor
                                          : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // DELIVER TIME Section
                      Text(
                        AppStrings.deliverTimeUpper,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: darkGreyColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children:
                            [
                              AppStrings.time10to15,
                              AppStrings.time20,
                              AppStrings.time30,
                            ].map((time) {
                              final isSelected = selectedDeliveryTime == time;
                              return FilterChip(
                                label: Text(time),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setModalState(() {
                                    selectedDeliveryTime =
                                        selected ? time : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: orangeColor,
                                side: BorderSide(
                                  color:
                                      isSelected
                                          ? orangeColor
                                          : Colors.grey.shade300,
                                ),
                                labelStyle: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // PRICING Section
                      Text(
                        AppStrings.pricingUpper,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: darkGreyColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          AppStrings.pricingLow,
                          AppStrings.pricingMedium,
                          AppStrings.pricingHigh,
                        ].map((price) {
                              final isSelected = selectedPricing == price;
                              return FilterChip(
                                label: Text(price),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setModalState(() {
                                    selectedPricing = selected ? price : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: orangeColor,
                                side: BorderSide(
                                  color:
                                      isSelected
                                          ? orangeColor
                                          : Colors.grey.shade300,
                                ),
                                labelStyle: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // RATING Section
                      Text(
                        AppStrings.ratingUpper,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: darkGreyColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RatingBar.builder(
                        initialRating: selectedRating.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                        itemBuilder:
                            (context, _) =>
                                Icon(Icons.star, color: orangeColor),
                        onRatingUpdate: (rating) {
                          setModalState(() {
                            selectedRating = rating.toInt();
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // Filter Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Apply filters
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppStrings.filterButton,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFastFoodCard(FastFoodItem item, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                        ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                      iconSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Card content
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.restaurant,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  // Price and add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.price}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {},
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
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
    );
  }

  Widget _buildRestaurantCard(
    String name,
    String rating,
    String delivery,
    String time,
    String imageUrl,
    Color accentColor,
  ) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Restaurant image
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.restaurant,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          // Restaurant info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          rating,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          delivery,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
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
    );
  }
}
