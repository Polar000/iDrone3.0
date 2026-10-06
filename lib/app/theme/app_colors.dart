import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color deepForest = Color(0xFF063F35);
  static const Color forest = Color(0xFF087A5F);
  static const Color emerald = Color(0xFF159A6B);
  static const Color freshGreen = Color(0xFF8DDE3F);
  static const Color lime = Color(0xFFC8F45A);
  static const Color cream = Color(0xFFF7F8F2);
  static const Color softGreen = Color(0xFFE8F4EC);
  static const Color earth = Color(0xFF8A7659);
  static const Color dark = Color(0xFF172033);
  static const Color muted = Color(0xFF6B7280);
  static const Color white = Color(0xFFFFFFFF);
  static const Color warningOrange = Color(0xFFE65100);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF2D3748);

  // Bank Specific Colors for Guatemala Integrations
  static const Color banruralGreen = Color(0xFF006837);
  static const Color banruralYellow = Color(0xFFFDB813);
  static const Color biBlue = Color(0xFF003B71);
  static const Color biYellow = Color(0xFFFFB800);

  // High-Tech Modern Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF063F35), Color(0xFF0D5043), Color(0xFF172033)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassCardGradient = LinearGradient(
    colors: [
      Color(0xCCFFFFFF),
      Color(0xEEFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF159A6B), Color(0xFF087A5F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonGreenGradient = LinearGradient(
    colors: [Color(0xFF8DDE3F), Color(0xFFC8F45A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Ultra Smooth Modern Ambient Shadows
  static List<BoxShadow> modernShadow({Color color = const Color(0x11172033), double blur = 20, Offset offset = const Offset(0, 8)}) {
    return [
      BoxShadow(
        color: color,
        blurRadius: blur,
        offset: offset,
      ),
      BoxShadow(
        color: color.withValues(alpha: color.alpha / 255.0 * 0.4),
        blurRadius: blur / 2,
        offset: Offset(offset.dx, offset.dy / 2),
      ),
    ];
  }
}
