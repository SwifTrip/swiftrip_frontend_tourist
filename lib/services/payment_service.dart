import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_service.dart';

class PaymentService {
  /// Maps Stripe's predefined test card numbers to their pre-built test tokens.
  /// This is the correct sandbox approach - no raw card data sent to Stripe.
  static String _cardNumberToToken(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'\s+'), '');
    switch (digits) {
      case '4242424242424242':
        return 'tok_visa'; // Success
      case '4000000000000002':
        return 'tok_chargeDeclined'; // Card declined
      case '4000000000009995':
        return 'tok_chargeDeclinedInsufficientFunds'; // Insufficient funds
      case '4000000000009987':
        return 'tok_chargeDeclinedLostCard'; // Lost card
      case '5555555555554444':
        return 'tok_mastercard'; // Mastercard success
      case '378282246310005':
        return 'tok_amex'; // Amex success
      default:
        // Any unrecognised number - use the generic visa success token
        return 'tok_visa';
    }
  }
}