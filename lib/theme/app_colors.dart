import 'package:flutter/material.dart';

class AppColors {
  // Neutral Colors (Light Theme)
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color surface = Color(0xFFFFFFFF);    // White
  static const Color textPrimary = Color(0xFF0F172A);   // Slate-900
  static const Color textSecondary = Color(0xFF64748B); // Slate-500
  static const Color border = Color(0xFFE2E8F0);    // Slate-200

  // Brand Colors (Agency Specific)
  static const Color primaryOrange = Color(0xFFEA580C); // Orange-600
  static const Color primaryEmerald = Color(0xFF10B981); // Emerald-500
  
  static Color get accent => primaryOrange;
  
  // Gradients
  static const List<Color> brandGradient = [
    Color(0xFFF97316), // Orange-500
    Color(0xFF10B981), // Emerald-500
  ];
}
