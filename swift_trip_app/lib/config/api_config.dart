class ApiConfig {
  // Base URL for the API

  static const String baseUrl = 'http://10.0.2.2:3000/api';
    
  // Auth Endpoints
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  
  // Request timeout duration
  static const Duration timeout = Duration(seconds: 30);
}
