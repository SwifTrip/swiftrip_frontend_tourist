import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Signin.dart';
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
  // Validation patterns
  static final RegExp _nameRegExp = RegExp(r'^[A-Za-z]+$');
  static final RegExp _digitsOnlyRegExp = RegExp(r'^\d+$');
  static final RegExp _strongPasswordRegExp =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');

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
      body: SingleChildScrollView(
        child: Padding(
           padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),

                // Logo
                Image.asset('lib/assets/logo.png', height: 120),
                const SizedBox(height: 40),

                // Header
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start your adventure with us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 40),

                // First Name
                CustomTextFormField(
                  controller: _firstNameController,
                  hintText: 'First Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Required';
                    if (!_nameRegExp.hasMatch(value.trim())) {
                      return 'Letters only';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                 // Last Name
                CustomTextFormField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Required';
                    if (!_nameRegExp.hasMatch(value.trim())) {
                      return 'Letters only';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                 CustomTextFormField(
                   controller: _phoneController,
                   hintText: 'Phone Number',
                   icon: Icons.phone_outlined,
                   inputType: TextInputType.phone,
                   validator: (value) {
                       if (value == null || value.trim().isEmpty) return 'Phone number is required';
                       if (!_digitsOnlyRegExp.hasMatch(value.trim())) return 'Digits only';
                     return null;
                   },
                 ),
                 const SizedBox(height: 16),

                // Password
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (!_strongPasswordRegExp.hasMatch(value)) {
                      return 'Min 8, 1 upper, 1 lower, 1 digit, 1 special';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Confirm your password';
                    if (value != _passwordController.text) return 'Mismatch';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Language Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: AppColors.surface,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.language, color: AppColors.textSecondary),
                    ),
                    hint: const Text(
                      'Select your language',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    style: const TextStyle(color: AppColors.textPrimary),
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'ur', child: Text('Urdu')),
                      DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                    ],
                    onChanged: (value) {},
                  ),
                ),

                const SizedBox(height: 24),

                // Sign Up Button
                CommonButton(
                  text: 'Create Account',
                  onPressed: _isLoading ? null : _handleCreateAccount,
                  isEnabled: !_isLoading,
                ),

                const SizedBox(height: 40),

                 // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Signin()),
                        );
                      },
                      child: const Text('Login', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      style: const TextStyle(color: AppColors.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
