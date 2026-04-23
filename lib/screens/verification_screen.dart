import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_mode_controller.dart';
import 'signin.dart';
import '../widgets/common_button.dart';

class VerificationScreen extends StatefulWidget {
  final String? token;

  const VerificationScreen({super.key, this.token});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  String _message = 'Verifying your email...';
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _handleVerification();
  }

  void _handleVerification() async {
    if (widget.token == null || widget.token!.isEmpty) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _message = 'Invalid or missing verification token.';
      });
      return;
    }

    try {
      // Small delay for better UX/realism
      await Future.delayed(const Duration(seconds: 2));

      final result = await _authService.verifyEmail(widget.token!);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isSuccess = result['success'];
        _message = result['message'];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _message = 'An error occurred during verification.';
      });
    }
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
    final cardColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.white;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.35)
        : const Color(0xFFE2E8F0);
    final cardShadow = isDark
        ? Colors.black.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.11);

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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: cardBorderColor),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadow,
                        blurRadius: isDark ? 24 : 22,
                        offset: Offset(0, isDark ? 12 : 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isLoading
                              ? const Color(0xFFFFEDD5)
                              : (_isSuccess
                                    ? const Color(0xFFDCFCE7)
                                    : const Color(0xFFFEE2E2)),
                        ),
                        child: _isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(25.0),
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryOrange,
                                  strokeWidth: 3,
                                ),
                              )
                            : Icon(
                                _isSuccess
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.error_outline_rounded,
                                size: 60,
                                color: _isSuccess
                                    ? AppColors.primaryEmerald
                                    : Colors.red,
                              ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _isLoading
                            ? 'Processing...'
                            : (_isSuccess
                                  ? 'Verified!'
                                  : 'Verification Failed'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: headingColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: subtitleColor,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (!_isLoading)
                        CommonButton(
                          text: 'Return to Login',
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const Signin(),
                              ),
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
