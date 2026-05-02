import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
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
  static const Color _whatsappGreen = Color(0xFF25D366);
  late final AnimationController _controller;
  late final Animation<double> _pulse;
  late final Animation<double> _lift;

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        PositionedDirectional(
          bottom: 0,
          end: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12, bottom: 12),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _lift.value),
                    child: Transform.scale(
                      scale: _pulse.value,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        color: _whatsappGreen.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Material(
                      elevation: 10,
                      shadowColor: _whatsappGreen.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => openSupportWhatsApp(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipOval(
                            child: SizedBox(
                              width: 46,
                              height: 46,
                              child: Image.asset(
                                AppAssets.whatsapp,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => ColoredBox(
                                      color: _whatsappGreen,
                                      child: const Icon(
                                        Icons.chat_bubble_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
