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

  static const String getPackages = '$baseUrl/agency';

// Custom Tour Endpoints
  static const String createCustomTour = '$baseUrl/custom-tour/create';
  static const String touristCustomTours = '$baseUrl/tourist/custom-tours';

  // Tourist Package Search Endpoints (Public)
  static const String searchPackages = '$baseUrl/tourist/packages/search';
  static const String touristPackages = '$baseUrl/tourist/packages';

  // Request timeout duration
  static const Duration timeout = Duration(seconds: 30);
}
