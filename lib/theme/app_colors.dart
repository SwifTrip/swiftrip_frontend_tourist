import 'package:flutter/material.dart';

class AppColors {
  // Neutral Colors (Light Theme)
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF64748B); // Slate-500
  static const Color border = Color(0xFFE2E8F0); // Slate-200

  // Brand Colors (Agency Specific)
  static const Color primaryOrange = Color(0xFFEA580C); // Orange-600
  static const Color primaryEmerald = Color(0xFF10B981); // Emerald-500

  // High Contrast Text Colors (WCAG AA Compliant)
  static const Color textEmerald = Color(0xFF065F46); // Emerald-800
  static const Color textOrange = Color(0xFF9A3412); // Orange-800

  static const Color accent = primaryOrange;

  // Tourism mood colors
  static const Color oceanDeep = Color(0xFF0E3559);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color sand = Color(0xFFFDE68A);
  static const Color coral = Color(0xFFFF7A59);
  static const Color mint = Color(0xFF34D399);

  static const List<Color> loginBackdropGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
    Color(0xFFB45309),
  ];

  // Gradients
  static const List<Color> brandGradient = [
    Color(0xFFF97316), // Orange-500
    Color(0xFF10B981), // Emerald-500
  ];

  static const List<Color> premiumActionGradient = [
    Color(0xFFFF7A59),
    Color(0xFFFF9A3D),
  ];
}
