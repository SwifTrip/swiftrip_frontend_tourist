import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/booking_model.dart';
import 'token_service.dart';

class BookingService {
  /// Get all bookings for the logged-in user
  Future<BookingsResponse?> getUserBookings({String when = 'UPCOMING'}) async {
    try {
      // Get the auth token
      final token = await TokenService.getToken();

      if (token == null) {
        return null;
      }

      final uri = Uri.parse(ApiConfig.myBookings).replace(
        queryParameters: {
          'when': when,
          'status': 'CONFIRMED',
        },
      );

      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              // Send bearer token per API requirement
              'Authorization': 'Bearer $token',
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
  
  /// Get single booking details
  Future<dynamic> getBookingDetails(int bookingId, String type) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) return null;

      // Note: If backend doesn't have a direct single-booking endpoint, 
      // we fetch all and filter, or assume /tourist/bookings/:id
      // For now, let's try to fetch from the general list and filter for simplicity 
      // if a specific endpoint isn't confirmed.
      // But usually it's better to have a specific one.
      final response = await getUserBookings(when: 'ALL');
      if (response != null && response.success) {
        if (type == 'PUBLIC') {
          return response.data.publicTours.firstWhere((b) => b.id == bookingId);
        } else {
          return response.data.privateTours.firstWhere((b) => b.id == bookingId);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching booking details: $e');
      return null;
    }
  }

  /// Create a new booking (custom tour or schedule-based)

  Future<Map<String, dynamic>?> createBooking({
    int? customTourId,
    int? publicTourId,
    required int seats,
    String? paymentMethod,
  }) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Authentication required'};
      }

      final Map<String, dynamic> requestBody = {
        'seats': seats,
        if (customTourId != null) 'customTourId': customTourId,
        if (publicTourId != null) 'publicTourId': publicTourId,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
      };

      final response = await http
          .post(
            Uri.parse(ApiConfig.createBooking),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': responseData['message'] ?? 'Booking created successfully!',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create booking',
        };
      }
    } on http.ClientException catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }
}
