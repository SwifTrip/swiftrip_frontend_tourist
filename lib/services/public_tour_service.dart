import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../services/token_service.dart';

class PublicTourService {
  Future<Map<String, dynamic>?> createPublicTour({
    required int scheduleId,
    required int travelerCount,
    required List<Map<String, dynamic>> itineraries,
    bool allowWaitlistRequest = false,
  }) async {
    try {
      final token = await TokenService.getToken();

      if (token == null) {
        return {'success': false, 'message': 'Authentication required'};
      }

      final Map<String, dynamic> requestBody = {
        'scheduleId': scheduleId,
        'travelerCount': travelerCount,
        'itineraries': itineraries,
        'allowWaitlistRequest': allowWaitlistRequest,
      };

      final response = await http
          .post(
            Uri.parse(ApiConfig.touristPublicTours),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Public tour created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create public tour',
        };
      }
    } on http.ClientException catch (e) {
      return {
        'success': false,
        'message':
            'Connection error. Please check your internet connection. ${e.toString()}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }
}
