import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_mode_controller.dart';
import '../widgets/common_button.dart';
import 'email_sent_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    return emailRegex.hasMatch(value.trim());
  }

  InputDecoration _buildInputDecoration(bool isDark) {
    return InputDecoration(
      hintText: 'Email address',
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFFB8C4D6) : const Color(0xFF94A3B8),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(
        Icons.mail_outline_rounded,
        size: 20,
        color: isDark ? const Color(0xFF5E7FA3) : const Color(0xFF64748B),
      ),
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
        borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
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

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailSentScreen(
          email: _emailController.text.trim(),
          isPasswordReset: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
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
    final backBtnBg = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.9);
    final backBtnIcon = isDark ? Colors.white : const Color(0xFF334155);
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
                  color: topBlob,
                  shape: BoxShape.circle,
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
                  color: midBlob,
                  shape: BoxShape.circle,
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
                  color: bottomBlob,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height - 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            style: IconButton.styleFrom(
                              backgroundColor: backBtnBg,
                            ),
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: backBtnIcon,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.16)
                                      : Colors.black.withValues(alpha: 0.09),
                                  blurRadius: isDark ? 28 : 24,
                                  offset: Offset(0, isDark ? 14 : 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock_reset,
                              size: 58,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: (size.width * 0.085).clamp(30.0, 36.0),
                            fontWeight: FontWeight.w800,
                            color: headingColor,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Enter your email address and we'll send you a link to reset your password.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: subtitleColor,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
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
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (!_isSubmitting) {
                                _handleSendResetLink();
                              }
                            },
                            style: const TextStyle(
                              color: AppColors.oceanDeep,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: _buildInputDecoration(isDark),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!_isValidEmail(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        CommonButton(
                          text: 'Send Reset Link',
                          onPressed: _isSubmitting
                              ? null
                              : _handleSendResetLink,
                          isEnabled: !_isSubmitting,
                          isLoading: _isSubmitting,
                          gradient: AppColors.premiumActionGradient,
                          borderRadius: 18,
                          height: 58,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Back to',
                              style: TextStyle(
                                color: footerText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.sand,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
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
                    backgroundColor: backBtnBg,
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.24)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: backBtnIcon,
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
