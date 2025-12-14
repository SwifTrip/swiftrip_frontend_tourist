import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swift_trip_app/config/api_config.dart';
import 'package:swift_trip_app/models/Agency.dart';
import 'package:swift_trip_app/services/token_service.dart';

class TourService {
  Future<List<Agency>> searchAgencies({
    required String fromCity,
    required String toCity,
    required int minBudget,
    required int maxBudget,
  }) async {
    final url = Uri.parse(
      "${ApiConfig.tourSearch}?fromLocation=$fromCity&toLocation=$toCity&minBudget=$minBudget&maxBudget=$maxBudget",
    );

    // Get the auth token
    final token = await TokenService.getToken();

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final response = await http
        .get(url, headers: headers)
        .timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);

      if (jsonBody['success'] == true) {
        List agenciesJson = jsonBody['data'];

        return agenciesJson.map((e) => Agency.fromJson(e)).toList();
      } else {
        throw Exception(jsonBody['message'] ?? "Search failed");
      }
    } else {
      throw Exception("Server returned ${response.statusCode}");
    }
  }
}
