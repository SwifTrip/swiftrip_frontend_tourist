import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/custom_tour_model.dart';
import '../models/custom_tour_request.dart';
import 'token_service.dart';

class CustomTourService {
  // Create custom tour
  Future<Map<String, dynamic>> createCustomTour({
    required int companyId,
    required int basePackageId,
    required String startDate,
    required String endDate,
    required int travelerCount,
    required List<ItineraryDay> itineraries,
  }) async {
    try {
      // Get token from storage
      final token = await TokenService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found. Please login again.',
        };
      }

      // Prepare request body
      final request = CustomTourRequest(
        companyId: companyId,
        basePackageId: basePackageId,
        startDate: startDate,
        endDate: endDate,
        travelerCount: travelerCount,
        itineraries: itineraries,
      );

      final response = await http
          .post(
            Uri.parse(ApiConfig.createCustomTour),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Success
        return {
          'success': true,
          'message':
              responseData['message'] ?? 'Custom tour created successfully',
          'customTour': CustomTourModel.fromJson(responseData['data']),
        };
      } else if (response.statusCode == 401) {
        // Unauthorized - token expired or invalid
        return {
          'success': false,
          'message': 'Session expired. Please login again.',
        };
      } else {
        // Error from server
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create custom tour',
        };
      }
    } catch (e) {
      // Network or other errors
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
