import 'package:flutter/material.dart';

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
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF0F5FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF0F5FF),
          elevation: 0,
          leading: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          title: const Text(
            'Create Account',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomInputField(
                      icon: Icons.person_outline,
                      hintText: 'Enter your first name',
                      controller: _firstNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      icon: Icons.person_outline,
                      hintText: 'Enter your last name',
                      controller: _lastNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      icon: Icons.email_outlined,
                      hintText: 'Enter your email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    const CustomInputField(
                      icon: Icons.phone_outlined,
                      hintText: 'Enter your phone number',
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      icon: Icons.lock_outline,
                      hintText: 'Create a password',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      icon: Icons.lock_outline,
                      hintText: 'Confirm your password',
                      obscureText: true,
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFE5E5E5)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.language),
                        ),
                        hint: const Text(
                          'Select your language',
                          style: TextStyle(color: Color(0xFFA1A1A1)),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'ur', child: Text('Urdu')),
                          DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: Color(0xFF111827)),
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFFA1A1A1)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA1A1A1)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB)),
        ),
      ),
    );
  }
}
