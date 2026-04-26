import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import '../services/payment_service.dart';
import 'home_screen.dart';

class StripePaymentScreen extends StatefulWidget {
  final int? customTourId;
  final int? publicTourId;
  final int travelers;
  final num totalAmount;
  final String currency;
  final String tripTitle;

  const StripePaymentScreen({
    super.key,
    this.customTourId,
    this.publicTourId,
    required this.travelers,
    required this.totalAmount,
    required this.currency,
    required this.tripTitle,
  }) : assert(
         (customTourId != null) != (publicTourId != null),
         'Provide exactly one of customTourId or publicTourId.',
       );

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvcCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  final PaymentService _paymentService = PaymentService();

  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvcCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  String get _formattedAmount {
    final amount = widget.totalAmount.toStringAsFixed(2);
    return 'Rs $amount'; // force display currency in UI
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Parse expiry MM / YY
    final expParts = _expiryCtrl.text.replaceAll(' ', '').split('/');
    final expMonth = expParts[0].trim();
    final expYear = '20${expParts[1].trim()}';

    try {
      // Single call — backend handles everything with the secret key
      final result = await _paymentService.processPayment(
        cardNumber: _cardNumberCtrl.text,
        expMonth: expMonth,
        expYear: expYear,
        cvc: _cvcCtrl.text,
        customTourId: widget.customTourId,
        publicTourId: widget.publicTourId,
        seats: widget.travelers,
        currency: 'usd', // backend always USD
      );

      if (!mounted) return;

      if (result != null && result['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        _showSuccessDialog();
      } else {
        _setError(result?['message'] ?? 'Payment failed. Please try again.');
      }
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _setError(String msg) {
    if (!mounted) return;
    setState(() {
      _errorMessage = msg;
      _isLoading = false;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated check
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (ctx, val, child) =>
                    Transform.scale(scale: val, child: child),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryEmerald,
                        AppColors.primaryEmerald.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryEmerald.withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Successful!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your booking is confirmed. \nGet ready for your adventure! 🎉',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: CommonButton(
                  text: 'Back to Home',
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  gradient: const [AppColors.primaryEmerald, Color(0xFF0EA371)],
                  borderRadius: 16,
                  height: 52,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: Center(
          child: Text(
            'Payment',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTripSummaryCard(),
              const SizedBox(height: 24),
              _buildCardForm(),
              const SizedBox(height: 16),
              if (_errorMessage != null) ...[
                _buildErrorBanner(),
                const SizedBox(height: 12),
              ],
              _buildTestCardsHint(),
              const SizedBox(height: 28),
              _buildPayButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Trip Summary ─────────────────────────────────────────────────────────
  Widget _buildTripSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withOpacity(0.08),
            AppColors.primaryEmerald.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: AppColors.primaryOrange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tripTitle,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.travelers} traveler${widget.travelers > 1 ? 's' : ''}',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formattedAmount,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primaryOrange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Card Form ─────────────────────────────────────────────────────────────
  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Card Details'),
          const SizedBox(height: 14),
          // Cardholder name
          _buildField(
            controller: _nameCtrl,
            label: 'Cardholder Name',
            hint: 'John Smith',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter cardholder name' : null,
          ),
          const SizedBox(height: 14),
          // Card Number
          _buildField(
            controller: _cardNumberCtrl,
            label: 'Card Number',
            hint: '4242 4242 4242 4242',
            icon: Icons.credit_card_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            maxLength: 19,
            validator: (v) {
              final digits = v?.replaceAll(' ', '') ?? '';
              if (digits.length < 13 || digits.length > 19) {
                return 'Enter a valid card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Expiry
              Expanded(
                child: _buildField(
                  controller: _expiryCtrl,
                  label: 'MM / YY',
                  hint: '12 / 26',
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpiryFormatter(),
                  ],
                  maxLength: 7,
                  validator: (v) {
                    if (v == null || !v.contains('/')) {
                      return 'Invalid expiry';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 14),
              // CVC
              Expanded(
                child: _buildField(
                  controller: _cvcCtrl,
                  label: 'CVC',
                  hint: '123',
                  icon: Icons.lock_outline_rounded,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 4,
                  validator: (v) {
                    if (v == null || v.length < 3) return 'Invalid CVC';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      maxLength: maxLength,
      validator: validator,
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary.withOpacity(0.5),
          fontSize: 13,
          letterSpacing: 0.5,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryOrange,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  // ── Error Banner ─────────────────────────────────────────────────────────
  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Test Cards Hint ───────────────────────────────────────────────────────
  Widget _buildTestCardsHint() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.science_outlined,
                color: AppColors.accentTeal,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Stripe Sandbox — Test Cards',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _testRow('✅ Success', '4242 4242 4242 4242'),
          _testRow('❌ Card Declined', '4000 0000 0000 0002'),
          _testRow('⚠️ Insufficient Funds', '4000 0000 0000 9995'),
          const SizedBox(height: 6),
          Text(
            'Expiry: any future date  ·  CVC: any 3 digits  ·  ZIP: any 5 digits',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _testRow(String label, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            number,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Pay Button ────────────────────────────────────────────────────────────
  Widget _buildPayButton() {
    return CommonButton(
      text: 'Pay $_formattedAmount',
      onPressed: _isLoading ? null : _handlePayment,
      isEnabled: !_isLoading,
      isLoading: _isLoading,
      borderRadius: 24,
      height: 54,
    );
  }
}

// ── Input Formatters ─────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = digits;
    if (digits.length >= 3) {
      formatted = '${digits.substring(0, 2)} / ${digits.substring(2)}';
    } else if (digits.length == 2 && oldValue.text.length == 1) {
      formatted = '$digits / ';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
