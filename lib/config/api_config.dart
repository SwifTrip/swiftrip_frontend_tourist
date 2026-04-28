class ApiConfig {
  // Base URL for the API
  // For Chrome/Web use localhost
  // For Android Emulator use 10.0.2.2
  static const String baseUrl = 'http://localhost:3000/api';

  // Auth Endpoints
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String verifyEmail = '$baseUrl/verify-email';
  static const String resendVerification = '$baseUrl/resend-verification';

  // Agency search in custom tour Endpoint
  static const String tourSearch = '$baseUrl/custom-tour/search';

  static const String getPackages = '$baseUrl/agency';

  // Custom Tour Endpoints
  static const String createCustomTour = '$baseUrl/custom-tour/create';
  static const String touristCustomTours = '$baseUrl/tourist/custom-tours';

  // Public Tour Endpoints
  static const String touristPublicTours = '$baseUrl/tourist/public-tours';

  // Tourist Package Search Endpoints (Public)
  static const String searchPackages = '$baseUrl/tourist/packages/search';
  static const String trendingPackages = '$baseUrl/tourist/packages/trending';
  static const String planningSuggestions =
      '$baseUrl/tourist/planning/suggestions';
  static const String touristPackages = '$baseUrl/tourist/packages';
  static String touristScheduleAvailability(String scheduleId) =>
      '$baseUrl/tourist/schedules/$scheduleId/availability';

  // Tourist Bookings Endpoints
  static const String myBookings = '$baseUrl/tourist/bookings/my';
  static const String createBooking = '$baseUrl/tourist/bookings';

  // Stripe Payment — all-in-one server-side processing
  static const String processPayment = '$baseUrl/tourist/payment/process';

  // Chat Endpoints
  static const String chatSocket = 'http://localhost:3000'; // Socket Server URL
  static const String myChatRooms = '$baseUrl/chat/rooms';
  static String chatMessages(String roomId) =>
      '$baseUrl/chat/rooms/$roomId/messages';

  // Request timeout duration
  static const Duration timeout = Duration(seconds: 30);
}
