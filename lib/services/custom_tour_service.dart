import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../services/token_service.dart';

class CustomTourService {
  /// Create a custom tour booking
  Future<Map<String, dynamic>?> createCustomTour({
    required int basePackageId,
    required DateTime startDate,
    required DateTime endDate,
    required int travelerCount,
    required List<Map<String, dynamic>> itineraries,
  }) async {
    try {
      // Get auth token
      final token = await TokenService.getToken();
      
      if (token == null) {
        print('No authentication token found');
        return {'success': false, 'message': 'Authentication required'};
      }

      // Build request body
      final Map<String, dynamic> requestBody = {
        'basePackageId': basePackageId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'travelerCount': travelerCount,
        'itineraries': itineraries,
      };

      print('Creating custom tour with data: ${jsonEncode(requestBody)}');

      final response = await http
          .post(
            Uri.parse(ApiConfig.touristCustomTours),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Custom tour created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create custom tour',
        };
      }
    } on http.ClientException catch (e) {
      print('Connection error: ${e.message}');
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
      };
    } catch (e) {
      print('Error creating custom tour: ${e.toString()}');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }
}
