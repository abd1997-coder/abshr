import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/di/injection_container.dart';
import 'package:marketplace/features/cart/presentation/cubit/cart_cubit.dart';
import '../cubit/product_detail_cubit.dart';
import '../../domain/entities/product_detail.dart';
import '../widgets/product_detail_page_shimmer.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  /// First (or selected) variant id for add-to-cart. When set, ADD TO CART uses store API.
  final String? variantId;

  const ProductDetailPage({required this.productId, this.variantId, super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductDetailCubit _productDetailCubit =
      getIt.get<ProductDetailCubit>();

  @override
  void initState() {
    super.initState();
    _productDetailCubit.loadProductDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        bloc: _productDetailCubit,
        builder: (context, state) {
          if (state is ProductDetailLoading || state is ProductDetailInitial) {
            return const ProductDetailPageShimmer();
          } else if (state is ProductDetailLoaded) {
            return _ProductDetailBody(
              product: state.productDetail,
              initialVariantId: widget.variantId,
            );
          } else if (state is ProductDetailError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductDetailBody extends StatefulWidget {
  const _ProductDetailBody({required this.product, this.initialVariantId});

  final ProductDetail product;
  final String? initialVariantId;

  @override
  State<_ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<_ProductDetailBody> {
  static const int _maxQuantity = 99;

  int _quantity = 1;

  String get _effectiveVariantId =>
      widget.initialVariantId ?? widget.product.defaultVariantId ?? '';

  ProductDetail get product => widget.product;

  String _formatPrice() {
    if (product.price <= 0) return '—';
    final amount =
        product.price == product.price.roundToDouble()
            ? product.price.toStringAsFixed(0)
            : product.price.toStringAsFixed(2);
    if (product.currencyCode.isNotEmpty) {
      return '$amount ${product.currencyCode.toUpperCase()}';
    }
    return '\$$amount';
  }

  String _formatLineTotal() {
    if (product.price <= 0) return '—';
    final total = product.price * _quantity;
    final amount =
        total == total.roundToDouble()
            ? total.toStringAsFixed(0)
            : total.toStringAsFixed(2);
    if (product.currencyCode.isNotEmpty) {
      return '$amount ${product.currencyCode.toUpperCase()}';
    }
    return '\$$amount';
  }

  void _incrementQuantity() {
    if (_quantity < _maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orange = AppConstants.primaryColor;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image and buttons
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  image:
                      product.imageUrl.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    product.imageUrl.isEmpty
                        ? Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                        )
                        : null,
              ),
              // Back button
              Positioned(
                top: 12,
                left: 12,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              // Badges
              if (product.badges.isNotEmpty)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Row(
                    children:
                        product.badges
                            .map(
                              (badge) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  badge,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name and rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.subtitle.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              product.subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                          if (product.location.isNotEmpty ||
                              product.zipCode.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              '📍 ${product.location}'
                              '${product.zipCode.isNotEmpty ? ' ${product.zipCode}' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatPrice(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (product.rating > 0)
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: product.rating.clamp(0, 5),
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 14,
                                ignoreGestures: true,
                                itemBuilder:
                                    (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                onRatingUpdate: (rating) {},
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            product.reviewCount > 0
                                ? AppStrings.reviewsCount(product.reviewCount)
                                : AppStrings.noReviewsYet,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description section
                Text(
                  AppStrings.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // Quantity
                Row(
                  children: [
                    Text(
                      AppStrings.quantity,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _quantity > 1 ? _decrementQuantity : null,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(9),
                              ),
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.remove,
                                  size: 20,
                                  color:
                                      _quantity > 1
                                          ? orange
                                          : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              '$_quantity',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap:
                                  _quantity < _maxQuantity
                                      ? _incrementQuantity
                                      : null,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(9),
                              ),
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  color:
                                      _quantity < _maxQuantity
                                          ? orange
                                          : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (product.price > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        AppStrings.subtotal,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatLineTotal(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: orange,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),

                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _effectiveVariantId.isNotEmpty
                            ? () async {
                              final cartCubit = getIt.get<CartCubit>();
                              await cartCubit.addByVariant(
                                _effectiveVariantId,
                                quantity: _quantity,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppStrings.addedToCart(_quantity),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _quantity > 1
                          ? AppStrings.addNToCart(_quantity)
                          : AppStrings.addToCart,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
