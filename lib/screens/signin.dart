import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_mode_controller.dart';
import '../widgets/common_button.dart';
import 'forgot_password_screen.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});
  @override
  State<Signin> createState() {
    return SigninState();
  }
}

class SigninState extends State<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Service
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Show loading state briefly
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final result = await _authService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Login successful'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to HomeScreen after success
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          setState(() {
            _errorMessage =
                result['message'] ??
                'Login failed. Please check your credentials.';
          });
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      }
    } else {
      // Show error if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors above'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _buildInputDecoration({
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
    final helperChipColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.85);
    final helperChipBorder = isDark ? Colors.white24 : const Color(0xFFE2E8F0);
    final helperChipText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
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
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height - 48),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 18),
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
                            child: Image.asset(
                              'lib/assets/logo.png',
                              height: 78,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Text(
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: (size.width * 0.085).clamp(30.0, 36.0),
                            fontWeight: FontWeight.w800,
                            color: headingColor,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to unlock curated escapes and unforgettable experiences.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: subtitleColor,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 22),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: helperChipColor,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: helperChipBorder),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.travel_explore,
                                  color: AppColors.primaryOrange,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Plan. Explore. Repeat.',
                                  style: TextStyle(
                                    color: helperChipText,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
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
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(
                                  color: AppColors.oceanDeep,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: _buildInputDecoration(
                                  isDark: isDark,
                                  hint: 'Email address',
                                  prefix: Icons.mail_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email is required';
                                  }
                                  final emailRegex = RegExp(
                                    r'^[\w\.-]+@[\w\.-]+\.\w{2,}$',
                                  );
                                  if (!emailRegex.hasMatch(value.trim())) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) {
                                  if (!_isLoading) _handleLogin();
                                },
                                style: const TextStyle(
                                  color: AppColors.oceanDeep,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: _buildInputDecoration(
                                  isDark: isDark,
                                  hint: 'Password',
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
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        CommonButton(
                          text: 'Sign In',
                          onPressed: _isLoading ? null : _handleLogin,
                          isEnabled: !_isLoading,
                          isLoading: _isLoading,
                          gradient: AppColors.premiumActionGradient,
                          borderRadius: 18,
                          height: 58,
                        ),

                        const SizedBox(height: 26),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to SwifTrip?',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
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
