import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/features/home/domain/entities/offer.dart';
import 'package:marketplace/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:marketplace/features/restaurant/presentation/pages/restaurant_page.dart';

/// Horizontal pager of promotional offers (under search on home).
class HomeOffersSlider extends StatefulWidget {
  const HomeOffersSlider({super.key, required this.offers});

  final List<Offer> offers;

  @override
  State<HomeOffersSlider> createState() => _HomeOffersSliderState();
}

class _HomeOffersSliderState extends State<HomeOffersSlider> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onOfferTap(Offer offer) {
    final handle = offer.linkHandle?.trim();
    if (handle == null || handle.isEmpty) return;

    final lt = (offer.linkType ?? '').toLowerCase().trim();

    if (lt == 'seller' || lt == 'restaurant' || lt == 'store' || lt == 'shop') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder:
              (_) => RestaurantPage(
                restaurantId: handle,
                restaurantName: offer.title,
              ),
        ),
      );
      return;
    }

    // `product` and unknown types default to product detail (handle as product id)
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailPage(productId: handle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offers.isEmpty) return const SizedBox.shrink();

    final accent = AppConstants.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            AppStrings.offers,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _pageController,
            padEnds: true,
            itemCount: widget.offers.length,
            onPageChanged: (i) => setState(() => _pageIndex = i),
            itemBuilder: (context, index) {
              final offer = widget.offers[index];
              final hasTarget = offer.hasLink;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    // onTap: hasTarget ? () => _onOfferTap(offer) : null,
                    
                    borderRadius: BorderRadius.circular(14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (offer.imageUrl.isNotEmpty)
                            Image.network(
                              offer.imageUrl,
                              fit: BoxFit.cover,
                              headers: const <String, String>{
                                'x-publishable-api-key':
                                    AppConstants.publishableApiKey,
                              },
                              errorBuilder:
                                  (_, __, ___) => ColoredBox(
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                            )
                          else
                            ColoredBox(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.local_offer_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                14,
                                28,
                                14,
                                12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.65),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    offer.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                  ),
                                  if (offer.subtitle != null &&
                                      offer.subtitle!.trim().isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      offer.subtitle!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.offers.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.offers.length,
              (i) => Container(
                width: _pageIndex == i ? 18 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _pageIndex == i ? accent : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
