import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swift_trip_app/config/api_config.dart';
import 'package:swift_trip_app/models/agency_response_model.dart';

class PackageService {
  Future<TourResponse> getPackages({
    required int agencyId,
    required String toCity,
    required int minBudget,
  }) async {
    final url = Uri.parse(
      "${ApiConfig.getPackages}/$agencyId/base-package?destination=$toCity&budget={$minBudget}",
    );

    final response = await http
        .get(
          url,
          headers: {"Content-Type": "application/json"},
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);

      if (jsonBody['success'] == true) {
        
        return TourResponse.fromJson(jsonBody);

      } else {
        throw Exception(jsonBody['message'] ?? "Search failed");
      }
    } else {
      throw Exception("Server returned ${response.statusCode}");
    }
  }
}
