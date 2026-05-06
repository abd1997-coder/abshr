import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../constants/app_strings.dart';
import '../support/open_support_whatsapp.dart';

/// Global floating support entry: shows the WhatsApp number and opens chat on tap.
class SupportWhatsAppOverlay extends StatefulWidget {
  const SupportWhatsAppOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<SupportWhatsAppOverlay> createState() => _SupportWhatsAppOverlayState();
}

class _SupportWhatsAppOverlayState extends State<SupportWhatsAppOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;
  late final Animation<double> _lift;
  double _scrollOffset = 0;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 1,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _lift = Tween<double>(
      begin: 0,
      end: -5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getClampedScrollOffset() {
    return _scrollOffset.clamp(-70.0, 70.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              setState(() {
                _scrollOffset += notification.scrollDelta ?? 0;
              });
            } else if (notification is ScrollStartNotification) {
              setState(() => _isScrolling = true);
            } else if (notification is ScrollEndNotification) {
              setState(() => _isScrolling = false);
            }
            return false;
          },
          child: widget.child,
        ),
        PositionedDirectional(
          bottom: 60,
          end: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12, bottom: 12),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _lift.value + _getClampedScrollOffset()),
                    child: Transform.scale(scale: _pulse.value, child: child),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isScrolling ? 90 : 70,
                  height: _isScrolling ? 90 : 70,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    elevation: _isScrolling ? 18 : 12,
                    shadowColor: AppConstants.primaryColor.withValues(
                      alpha: _isScrolling ? 0.6 : 0.4,
                    ),
                    borderRadius: BorderRadius.circular(45),
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => openSupportWhatsApp(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart_rounded,
                              color: AppConstants.primaryColor,
                              size: _isScrolling ? 28 : 22,
                            ),
                            if (_isScrolling)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  AppStrings.orderDirectly,
                                  style: TextStyle(
                                    color: AppConstants.primaryColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
