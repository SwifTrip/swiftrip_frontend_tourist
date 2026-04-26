import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/search_result.dart';
import '../models/package_model.dart';

class PackageService {
  Future<Map<String, dynamic>?> getPlanningSuggestions({int limit = 8}) async {
    try {
      final uri = Uri.parse(
        ApiConfig.planningSuggestions,
      ).replace(queryParameters: {'limit': limit.toString()});

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] as Map<String, dynamic>?;
      }

      debugPrint(
        'Planning suggestions error: ${response.statusCode} - ${response.body}',
      );
      return null;
    } catch (e) {
      debugPrint('Planning suggestions request error: ${e.toString()}');
      return null;
    }
  }

  Future<AgencyResult?> getTrendingPackages({int limit = 8}) async {
    try {
      final uri = Uri.parse(
        ApiConfig.trendingPackages,
      ).replace(queryParameters: {'limit': limit.toString()});

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return AgencyResult.fromJson(responseData);
      }

      debugPrint(
        'Trending packages error: ${response.statusCode} - ${response.body}',
      );
      return null;
    } on http.ClientException catch (e) {
      debugPrint('Connection error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Trending request error: ${e.toString()}');
      return null;
    }
  }

  Future<AgencyResult?> searchPackages({
    String? fromLocation,
    String? toLocation,
    String? category,
    int? travelers,
    String? tourType,
    String? startDate,
    // double? minBudget,
    // double? maxBudget,
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
      if (startDate != null && startDate.isNotEmpty) {
        queryParams['startDate'] = startDate;
      }
      // if (minBudget != null) {
      //   queryParams['minBudget'] = minBudget.toString();
      // }
      // if (maxBudget != null) {
      //   queryParams['maxBudget'] = maxBudget.toString();
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
        // Success - parse into AgencyResult model
        return AgencyResult.fromJson(responseData);
      } else {
        // Error from server
        debugPrint('Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on http.ClientException catch (e) {
      debugPrint('Connection error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Network error: ${e.toString()}');
      return null;
    }
  }

  /// Get package details by ID with full itinerary
  Future<PackageDetailsResponse?> getPackageDetailsWithItinerary(
    int packageId,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.touristPackages}/$packageId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Parse the response using the model
        if (responseData['success'] == true) {
          return PackageDetailsResponse.fromJson(responseData);
        } else {
          debugPrint('API returned success: false');
          return null;
        }
      } else {
        debugPrint('Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Network error: ${e.toString()}');
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

  /// Get live seat availability and booking policy for a specific schedule.
  Future<Map<String, dynamic>> getScheduleAvailability(
    int scheduleId, {
    int travelers = 1,
  }) async {
    try {
      final uri = Uri.parse(
        ApiConfig.touristScheduleAvailability(scheduleId.toString()),
      ).replace(queryParameters: {'travelers': travelers.toString()});

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'] ?? {},
          'message': 'Availability retrieved successfully',
        };
      }

      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to get availability',
        'data': {},
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': {},
      };
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
