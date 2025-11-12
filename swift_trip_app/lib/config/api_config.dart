class ApiConfig {
  // Base URL for the API
  // The baseUrl can be overridden at build time using --dart-define=API_BASE_URL=https://your-production-api.com/api
  // For Chrome/Web use localhost
  // For Android Emulator use 10.0.2.2
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  // Auth Endpoints
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';

  // Request timeout duration
  static const Duration timeout = Duration(seconds: 30);
}
