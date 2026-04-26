import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signin.dart';
import 'email_sent_screen.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_mode_controller.dart';
import '../widgets/common_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _lastNameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  late final FocusNode _confirmPasswordFocus;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
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
        borderSide: const BorderSide(color: Color(0xFFEA580C), width: 1.4),
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

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    return emailRegex.hasMatch(value.trim());
  }

  void _handleCreateAccount() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _authService.register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: 'TOURIST',
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Account created'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  EmailSentScreen(email: _emailController.text.trim()),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Registration failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors above'),
          backgroundColor: Colors.red,
        ),
      );
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
              top: 140,
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
                              height: 72,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Create Account',
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
                          'Join SwifTrip and start discovering journeys crafted for you.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: subtitleColor,
                            height: 1.45,
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
                                controller: _firstNameController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                onFieldSubmitted: (_) => FocusScope.of(
                                  context,
                                ).requestFocus(_lastNameFocus),
                                style: const TextStyle(
                                  color: AppColors.oceanDeep,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: _buildInputDecoration(
                                  isDark: isDark,
                                  hint: 'First name',
                                  prefix: Icons.person_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'First name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _lastNameController,
                                focusNode: _lastNameFocus,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                onFieldSubmitted: (_) => FocusScope.of(
                                  context,
                                ).requestFocus(_emailFocus),
                                style: const TextStyle(
                                  color: AppColors.oceanDeep,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: _buildInputDecoration(
                                  isDark: isDark,
                                  hint: 'Last name',
                                  prefix: Icons.person_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Last name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocus,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => FocusScope.of(
                                  context,
                                ).requestFocus(_passwordFocus),
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
                                  if (!_isValidEmail(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => FocusScope.of(
                                  context,
                                ).requestFocus(_confirmPasswordFocus),
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
                                  if (value.length < 6) {
                                    return 'Use at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocus,
                                obscureText: _obscureConfirmPassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) {
                                  if (!_isLoading) {
                                    _handleCreateAccount();
                                  }
                                },
                                style: const TextStyle(
                                  color: AppColors.oceanDeep,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: _buildInputDecoration(
                                  isDark: isDark,
                                  hint: 'Confirm password',
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
                                    onPressed: () => setState(
                                      () => _obscureConfirmPassword =
                                          !_obscureConfirmPassword,
                                    ),
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

                        const SizedBox(height: 20),

                        CommonButton(
                          text: 'Create Account',
                          onPressed: _isLoading ? null : _handleCreateAccount,
                          isEnabled: !_isLoading,
                          isLoading: _isLoading,
                          gradient: AppColors.premiumActionGradient,
                          borderRadius: 18,
                          height: 58,
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: footerText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const Signin(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign In',
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
