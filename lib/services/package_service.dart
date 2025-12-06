import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/search_result.dart';

class PackageService {
  Future<agencyResult?> searchPackages({
    String? fromLocation,
    String? toLocation,
    String? category,
    int? travelers,
    String? tourType,
    // double? minBudget,
    // double? maxBudget,
    // String? startDate,
    // int page = 1,
    // int limit = 20,
  }) async {
    try {
      // Build query parameters
      final Map<String, String> queryParams = {};

      if (fromLocation != null && fromLocation.isNotEmpty) {
        queryParams['fromLocation'] = fromLocation;
      }
      if (toLocation != null && toLocation.isNotEmpty) {
        queryParams['toLocation'] = toLocation;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (travelers != null) {
        queryParams['travelers'] = travelers.toString();
      }
      if (tourType != null && tourType.isNotEmpty) {
        queryParams['tourType'] = tourType;
      }
      // if (minBudget != null) {
      //   queryParams['minBudget'] = minBudget.toString();
      // }
      // if (maxBudget != null) {
      //   queryParams['maxBudget'] = maxBudget.toString();
      // }
      // if (startDate != null && startDate.isNotEmpty) {
      //   queryParams['startDate'] = startDate;
      // }
      // queryParams['page'] = page.toString();
      // queryParams['limit'] = limit.toString();

      // Create URI with query parameters
      final uri = Uri.parse(
        ApiConfig.searchPackages,
      ).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(ApiConfig.timeout);


      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Success - parse into agencyResult model
        return agencyResult.fromJson(responseData);
      } else {
        // Error from server
        print('Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on http.ClientException catch (e) {
      print('Connection error: ${e.message}');
      return null;
    } catch (e) {
      print('Network error: ${e.toString()}');
      return null;
    }
  }

  /// Get package details by ID
  Future<Map<String, dynamic>> getPackageDetails(String packageId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.touristPackages}/$packageId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': 'Package details retrieved successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to get package details',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Get available schedules for a package
  Future<Map<String, dynamic>> getPackageSchedules(
    String packageId, {
    String? fromDate,
    int? travelers,
  }) async {
    try {
      final Map<String, String> queryParams = {};

      if (fromDate != null && fromDate.isNotEmpty) {
        queryParams['fromDate'] = fromDate;
      }
      if (travelers != null) {
        queryParams['travelers'] = travelers.toString();
      }

      final uri = Uri.parse(
        '${ApiConfig.touristPackages}/$packageId/schedules',
      ).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'] ?? [],
          'message': 'Schedules retrieved successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to get schedules',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': [],
      };
    }
  }
}
