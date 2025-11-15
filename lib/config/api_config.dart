class ApiConfig {
  // Base URL for the API
  // For Chrome/Web use localhost
  // For Android Emulator use 10.0.2.2
  static const String baseUrl = 'http://localhost:3000/api';

  // Auth Endpoints
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';

  // Agency search in custom tour Endpoint
  static const String tourSearch = '$baseUrl/custom-tour/search';

// Custom Tour Endpoints
  static const String createCustomTour = '$baseUrl/custom-tour/create';

  // Request timeout duration
  static const Duration timeout = Duration(seconds: 30);
}
