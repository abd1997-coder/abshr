import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marketplace/core/widgets/shimmer_box.dart';

/// Skeleton UI while [RestaurantCubit] loads restaurant detail and menu.
class RestaurantPageShimmer extends StatelessWidget {
  const RestaurantPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: const ShimmerBox(
                width: double.infinity,
                height: 240,
                borderRadius: 0,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerBox(width: 72, height: 72, borderRadius: 36),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ShimmerBox(
                              width: double.infinity,
                              height: 14,
                              borderRadius: 4,
                            ),
                            const SizedBox(height: 8),
                            ShimmerBox(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              height: 14,
                              borderRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const ShimmerBox(width: 220, height: 24, borderRadius: 4),
                  const SizedBox(height: 8),
                  const ShimmerBox(
                    width: double.infinity,
                    height: 12,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 6),
                  ShimmerBox(
                    width: MediaQuery.sizeOf(context).width * 0.75,
                    height: 12,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        5,
                        (i) => Padding(
                          padding: EdgeInsets.only(right: i < 4 ? 8 : 0),
                          child: const ShimmerBox(
                            width: 88,
                            height: 40,
                            borderRadius: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const ShimmerBox(width: 160, height: 18, borderRadius: 4),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.61,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ShimmerBox(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const ShimmerBox(
                      width: double.infinity,
                      height: 12,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 6),
                    ShimmerBox(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                ),
                childCount: 6,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
