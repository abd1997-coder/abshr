import 'dart:ui';

class AppColors {
  // Primary Colors
  static const Color primary = Color(
    0xFFFF8C42,
  ); // Orange (from AppConstants.primaryColor)
  static const Color primaryDark = Color(0xFF1A4D4D); // Dark teal

  // Neutral Colors - Whites
  static const Color white = Color(0xFFFFFFFF);
  static const Color white90 = Color(0xFFE6E6E6); // 90% opacity equivalent

  // Neutral Colors - Light Background
  static const Color bgLight = Color(0xFFF7F8FA); // Light background
  static const Color bgLightGrey = Color(0xFFFAFAFA);

  // Neutral Colors - Greys
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF3F3F3);
  static const Color grey200 = Color(0xFFE8E8E8);
  static const Color grey300 = Color(0xFFD0D0D0);
  static const Color grey400 = Color(0xFFB0B0B0);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Text Colors
  static const Color textDark = Color(0xFF212121); // Dark grey for text
  static const Color textDarkGrey = Color(
    0xFF424242,
  ); // Dark grey (grey.shade800)
  static const Color textMuted = Color(
    0xFF757575,
  ); // Muted text (grey.shade600)
  static const Color textLight = Color(
    0xFF9E9E9E,
  ); // Light text (grey.shade500)
  static const Color textDarkAccent = Color(0xFF000000); // Black87 equivalent
  static const Color textLightAccent = Color(0xFF1E1E1E); // Black87

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE); // red.shade50
  static const Color warning = Color(0xFFFBC02D);

  // Amber/Star Color
  static const Color amber = Color(
    0xFFFFB74D,
  ); // Colors.amber.shade700 equivalent

  // Transparent Colors (will be applied with opacity modifiers)
  static const Color transparent = Color(0x00000000);

  // Shimmer/Loading colors
  static const Color shimmerBase = Color(0xFFD0D0D0); // grey.shade300
  static const Color shimmerHighlight = Color(0xFFF3F3F3); // grey.shade100

  // Opacity variants (static const colors with pre-calculated opacity)
  static const Color blackOpacity04 = Color(
    0x0A000000,
  ); // black.withOpacity(0.04)
  static const Color blackOpacity06 = Color(
    0x0F000000,
  ); // black.withOpacity(0.06)
  static const Color blackOpacity08 = Color(
    0x14000000,
  ); // black.withOpacity(0.08)
  static const Color blackOpacity1 = Color(
    0x1A000000,
  ); // black.withOpacity(0.1)
  static const Color blackOpacity2 = Color(
    0x33000000,
  ); // black.withOpacity(0.2)
  static const Color blackOpacity3 = Color(
    0x4D000000,
  ); // black.withOpacity(0.3)
  static const Color blackOpacity4 = Color(
    0x66000000,
  ); // black.withOpacity(0.4)
  static const Color blackOpacity5 = Color(
    0x80000000,
  ); // black.withOpacity(0.5)
  static const Color whiteOpacity05 = Color(
    0x0DFFFFFF,
  ); // white.withOpacity(0.05)
  static const Color whiteOpacity06 = Color(
    0x0FFFFFFF,
  ); // white.withOpacity(0.06)
  static const Color whiteOpacity1 = Color(
    0x1AFFFFFF,
  ); // white.withOpacity(0.1)
  static const Color whiteOpacity5 = Color(
    0x80FFFFFF,
  ); // white.withOpacity(0.5)
  static const Color whiteOpacity6 = Color(
    0x99FFFFFF,
  ); // white.withOpacity(0.6)
  static const Color whiteOpacity9 = Color(
    0xE6FFFFFF,
  ); // white.withOpacity(0.9)
  static const Color greyOpacity1 = Color(0x1A808080); // grey.withOpacity(0.1)
  static const Color greyOpacity2 = Color(0x33808080); // grey.withOpacity(0.2)
}
