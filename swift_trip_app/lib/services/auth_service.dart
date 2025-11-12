import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  // Register new user
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    String? companyName,
    String? companyRegistrationNumber,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
      };

      // Add company fields if role is AGENCY_STAFF
      if (role == 'AGENCY_STAFF') {
        body['companyName'] = companyName;
        body['companyRegistrationNumber'] = companyRegistrationNumber;
      }

      final response = await http
          .post(
            Uri.parse(ApiConfig.register),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Success
        return {
          'success': true,
          'message': responseData['message'],
          'user': UserModel.fromJson(responseData['data']),
        };
      } else {
        // Error from server
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      // Network or other errors
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.login),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Success
        return {
          'success': true,
          'message': responseData['message'],
          'user': UserModel.fromJson(responseData['data']),
        };
      } else {
        // Error from server
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      // Network or other errors
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Logout user
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.logout),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Logout failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
