import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class PasswordUpdatedScreen extends StatefulWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  State<PasswordUpdatedScreen> createState() => _PasswordUpdatedScreenState();
}

class _PasswordUpdatedScreenState extends State<PasswordUpdatedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Content will be added in subsequent commits
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
