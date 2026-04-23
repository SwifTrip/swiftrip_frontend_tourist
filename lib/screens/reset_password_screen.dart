import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_mode_controller.dart';
import 'password_updated_screen.dart';
import '../widgets/common_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  InputDecoration _decoration({
    required bool isDark,
    required String hint,
    required IconData prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFFB8C4D6) : const Color(0xFF94A3B8),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(
        prefix,
        size: 20,
        color: isDark ? const Color(0xFF5E7FA3) : const Color(0xFF64748B),
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark
          ? Colors.white.withValues(alpha: 0.96)
          : const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.92)
              : const Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primaryOrange,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.3),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    final cardColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.white;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.35)
        : const Color(0xFFE2E8F0);
    final cardShadow = isDark
        ? Colors.black.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.11);
    final footerText = isDark
        ? Colors.white.withValues(alpha: 0.86)
        : const Color(0xFF475569);

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height - 48),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Set New Password',
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
                          'Use a strong password to keep your account secure.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: subtitleColor,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
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
                            children: [
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: _decoration(
                                  isDark: isDark,
                                  hint: 'New password',
                                  prefix: Icons.lock_outline_rounded,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                      color: isDark
                                          ? const Color(0xFF5E7FA3)
                                          : const Color(0xFF64748B),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Use at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: _decoration(
                                  isDark: isDark,
                                  hint: 'Confirm new password',
                                  prefix: Icons.verified_user_outlined,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                      color: isDark
                                          ? const Color(0xFF5E7FA3)
                                          : const Color(0xFF64748B),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        CommonButton(
                          text: 'Update Password',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PasswordUpdatedScreen(),
                                ),
                              );
                            }
                          },
                          gradient: AppColors.premiumActionGradient,
                          borderRadius: 18,
                          height: 56,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Back to',
                              style: TextStyle(
                                fontSize: 14,
                                color: footerText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/signin',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
