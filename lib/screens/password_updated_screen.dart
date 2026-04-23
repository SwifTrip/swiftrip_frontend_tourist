import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_mode_controller.dart';
import '../widgets/common_button.dart';

class PasswordUpdatedScreen extends StatefulWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  State<PasswordUpdatedScreen> createState() => _PasswordUpdatedScreenState();
}

class _PasswordUpdatedScreenState extends State<PasswordUpdatedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = ThemeModeProvider.of(context);
    final headingColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.86)
        : const Color(0xFF475569);
    final pageGradient = isDark
        ? AppColors.loginBackdropGradient
        : const [Color(0xFFF8FBFF), Color(0xFFFFFAF5), Color(0xFFF6FBF8)];
    final topBlob = isDark
        ? AppColors.primaryOrange.withValues(alpha: 0.14)
        : const Color(0xFFFFEDD5);
    final midBlob = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : const Color(0xFFE0F2FE);
    final bottomBlob = isDark
        ? AppColors.primaryEmerald.withValues(alpha: 0.13)
        : const Color(0xFFDCFCE7);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: pageGradient,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -140,
              left: -95,
              child: Container(
                width: size.width * 0.72,
                height: size.width * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: topBlob,
                ),
              ),
            ),
            Positioned(
              top: 130,
              right: -90,
              child: Container(
                width: size.width * 0.62,
                height: size.width * 0.62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: midBlob,
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              left: -70,
              child: Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bottomBlob,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, _) {
                        return Transform.translate(
                          offset: Offset(0, _bounceAnimation.value),
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.14)
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 64,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Password Updated!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: headingColor,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You can now log in with your new password.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: subtitleColor,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CommonButton(
                      text: 'Back to Login',
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/signin',
                          (route) => false,
                        );
                      },
                      gradient: AppColors.premiumActionGradient,
                      borderRadius: 18,
                      height: 56,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 14,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => themeController.toggleMode(),
                  style: IconButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.16)
                        : Colors.white.withValues(alpha: 0.96),
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.24)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: isDark ? Colors.white : const Color(0xFF334155),
                    size: 19,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
