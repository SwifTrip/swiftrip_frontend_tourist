import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color>? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isEnabled;
  final double? fontSize;
  final double? height;
  final double? borderRadius;
  final bool isLoading;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.height,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 56,
      decoration: BoxDecoration(
        gradient: isEnabled && backgroundColor == null
            ? LinearGradient(
                colors: gradient ?? AppColors.brandGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: !isEnabled 
            ? AppColors.border 
            : (backgroundColor ?? (isEnabled && gradient == null ? null : (isEnabled ? null : AppColors.border))),
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: (backgroundColor ?? AppColors.primaryOrange).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontSize: fontSize ?? 16,
                        fontWeight: FontWeight.bold,
                        color: isEnabled ? (textColor ?? Colors.white) : AppColors.textSecondary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
