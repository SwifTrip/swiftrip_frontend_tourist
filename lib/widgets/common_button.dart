import 'package:swift_trip_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isEnabled;
  final double? fontSize;
  final double? height;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled 
              ? (backgroundColor ?? AppColors.accent) 
              : AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          // Note: The design uses a specific gray for disabled state
          disabledBackgroundColor: AppColors.surface,
          disabledForegroundColor: const Color(0xFF9CA3AF), // Text color when disabled
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.bold,
              color: isEnabled ? (textColor ?? AppColors.background) : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
