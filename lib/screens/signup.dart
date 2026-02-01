import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signin.dart';
import 'email_sent_screen.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Form key and controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  // Service
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
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
          // Navigate to EmailSentScreen after success
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EmailSentScreen(email: _emailController.text.trim()),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF7ED), // orange-50
              Color(0xFFECFDF5), // emerald-50
              Color(0xFFFFF7ED), // orange-50
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),

                    // Logo
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Image.asset('lib/assets/logo.png', height: 60),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Header
                    Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join SwiftTrip and transform your travel experience',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Form Content Grouped in Cards for Brand Aesthetic
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _firstNameController,
                            hintText: 'First Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Required';
                              return null;
                            },
                          ),
                          const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.border),
                          CustomTextFormField(
                            controller: _lastNameController,
                            hintText: 'Last Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Required';
                              return null;
                            },
                          ),
                          const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.border),
                          CustomTextFormField(
                            controller: _emailController,
                            hintText: 'Email Address',
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Required';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _passwordController,
                            hintText: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Required';
                              return null;
                            },
                          ),
                          const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.border),
                          CustomTextFormField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) return 'Mismatch';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Sign Up Button
                    CommonButton(
                      text: 'Create Account',
                      onPressed: _isLoading ? null : _handleCreateAccount,
                      isEnabled: !_isLoading,
                    ),

                    const SizedBox(height: 32),

                     // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const Signin()),
                            );
                          },
                          child: const Text('Sign In', 
                            style: TextStyle(
                              color: AppColors.primaryEmerald, 
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? inputType;

  const CustomTextFormField({
    super.key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
