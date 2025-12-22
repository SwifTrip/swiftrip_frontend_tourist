import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/booking_model.dart';
import 'token_service.dart';

class BookingService {
  /// Get all bookings for the logged-in user
  Future<BookingsResponse?> getUserBookings() async {
    try {
      // Get the auth token
      final token = await TokenService.getToken();

      if (token == null) {
        print('No auth token found');
        return null;
      }

      final response = await http
          .get(
            Uri.parse(ApiConfig.myBookings),
            headers: {
              'Content-Type': 'application/json',
              'Cookie': 'token=$token',
            },
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          return BookingsResponse.fromJson(responseData);
        } else {
          print('API returned success: false');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized - please login again');
        return null;
      } else {
        print('Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on http.ClientException catch (e) {
      print('Connection error: ${e.message}');
      return null;
    } catch (e) {
      print('Error fetching bookings: ${e.toString()}');
      return null;
    }
  }
}
