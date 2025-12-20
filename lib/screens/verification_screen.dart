import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import 'Signin.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isLoading 
                      ? Colors.white.withOpacity(0.05)
                      : (_isSuccess ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1)),
                ),
                child: _isLoading 
                    ? const Padding(
                        padding: EdgeInsets.all(25.0),
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                          strokeWidth: 3,
                        ),
                      )
                    : Icon(
                        _isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                        size: 60,
                        color: _isSuccess ? Colors.green : Colors.red,
                      ),
              ),
              const SizedBox(height: 32),
              
              // Status Message
              Text(
                _isLoading ? 'Processing...' : (_isSuccess ? 'Verified!' : 'Verification Failed'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              
              // Action Button
              if (!_isLoading)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Signin()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Return to Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
