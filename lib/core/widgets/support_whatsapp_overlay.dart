import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../support/open_support_whatsapp.dart';

/// Global floating support entry: shows the WhatsApp number and opens chat on tap.
class SupportWhatsAppOverlay extends StatelessWidget {
  const SupportWhatsAppOverlay({super.key, required this.child});

  final Widget child;

  static const Color _whatsappGreen = Color(0xFF25D366);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        PositionedDirectional(
          bottom: 0,
          end: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12, bottom: 12),
              child: Material(
                elevation: 8,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => openSupportWhatsApp(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              AppAssets.whatsapp,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => ColoredBox(
                                    color: _whatsappGreen,
                                    child: const Icon(
                                      Icons.chat_bubble_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 10),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Text(
                        //       'Support',
                        //       style: TextStyle(
                        //         fontSize: 13,
                        //         fontWeight: FontWeight.w700,
                        //         color: Colors.grey.shade900,
                        //       ),
                        //     ),
                        //     const SizedBox(height: 2),
                        //     Text(
                        //       AppConstants.supportWhatsAppDisplay,
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         fontWeight: FontWeight.w600,
                        //         color: Colors.grey.shade700,
                        //         letterSpacing: 0.2,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                  
                      ],
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
