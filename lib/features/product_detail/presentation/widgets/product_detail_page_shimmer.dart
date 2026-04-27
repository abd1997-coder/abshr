import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marketplace/core/widgets/shimmer_box.dart';

/// Skeleton UI while [ProductDetailCubit] loads product.
class ProductDetailPageShimmer extends StatelessWidget {
  const ProductDetailPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;
    final w = MediaQuery.sizeOf(context).width;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                const ShimmerBox(
                  width: double.infinity,
                  height: 300,
                  borderRadius: 0,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: SafeArea(
                    child: ShimmerBox(width: 40, height: 40, borderRadius: 20),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(
                              width: w * 0.65,
                              height: 22,
                              borderRadius: 4,
                            ),
                            const SizedBox(height: 10),
                            const ShimmerBox(
                              width: double.infinity,
                              height: 14,
                              borderRadius: 4,
                            ),
                            const SizedBox(height: 6),
                            ShimmerBox(
                              width: w * 0.45,
                              height: 12,
                              borderRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShimmerBox(width: w * 0.2, height: 22, borderRadius: 4),
                          const SizedBox(height: 8),
                          ShimmerBox(width: w * 0.22, height: 14, borderRadius: 4),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ShimmerBox(width: 100, height: 16, borderRadius: 4),
                  const SizedBox(height: 10),
                  const ShimmerBox(
                    width: double.infinity,
                    height: 12,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 6),
                  const ShimmerBox(
                    width: double.infinity,
                    height: 12,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 6),
                  ShimmerBox(width: w * 0.85, height: 12, borderRadius: 4),
                  const SizedBox(height: 24),
                  const ShimmerBox(
                    width: double.infinity,
                    height: 48,
                    borderRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
