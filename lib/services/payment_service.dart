import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_service.dart';

class PaymentService {
  /// Maps Stripe's predefined test card numbers to their pre-built test tokens.
  /// This is the correct sandbox approach � no raw card data sent to Stripe.
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
        // Any unrecognised number — use the generic visa success token
        return 'tok_visa';
    }
  }

  /// Sends the Stripe test token to our backend.
  /// Backend creates a PaymentMethod from it, confirms the PaymentIntent, and creates the booking.
  Future<Map<String, dynamic>?> processPayment({
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
    required int customTourId,
    required int seats,
    required int amountInCents,
    String currency = 'usd',
  }) async {
    try {
      final jwtToken = await TokenService.getToken();
      if (jwtToken == null) {
        return {'success': false, 'message': 'Authentication required'};
      }

      // Map card number to a safe Stripe test token
      final stripeToken = _cardNumberToToken(cardNumber);

      final response = await http
          .post(
            Uri.parse(ApiConfig.processPayment),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $jwtToken',
            },
            body: jsonEncode({
              'tokenId': stripeToken,
              'customTourId': customTourId,
              'seats': seats,
              'amount': amountInCents,
              'currency': currency,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
          'bookingId': data['bookingId'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Payment failed. Please try again.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error. Please check your internet.',
      };
    }
  }
}
