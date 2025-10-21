import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const CustomInputField(
                    icon: Icons.person_outline,
                    hintText: 'Enter your full name',
                  ),
                  const SizedBox(height: 16),
                  const CustomInputField(
                    icon: Icons.email_outlined,
                    hintText: 'Enter your email',
                  ),
                  const SizedBox(height: 16),
                  const CustomInputField(
                    icon: Icons.phone_outlined,
                    hintText: 'Enter your phone number',
                  ),
                  const SizedBox(height: 16),
                  const CustomInputField(
                    icon: Icons.lock_outline,
                    hintText: 'Create a password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  const CustomInputField(
                    icon: Icons.lock_outline,
                    hintText: 'Confirm your password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )

          ],
        ),
      )
    );
  }
}




class CustomInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;

  const CustomInputField({
    super.key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFFA1A1A1)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA1A1A1)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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


