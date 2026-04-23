import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'theme/theme_mode_controller.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/verification_screen.dart';
import 'screens/trip_details_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialMode = await ThemeModeController.loadInitialMode();
  runApp(SwifTripTouristApp(initialThemeMode: initialMode));
}

class SwifTripTouristApp extends StatefulWidget {
  const SwifTripTouristApp({super.key, required this.initialThemeMode});

  final ThemeMode initialThemeMode;

  @override
  State<SwifTripTouristApp> createState() => _SwifTripTouristAppState();
}

class _SwifTripTouristAppState extends State<SwifTripTouristApp> {
  late final ThemeModeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeModeController(widget.initialThemeMode);
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    return ThemeData(
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0B1220)
          : AppColors.background,
      primaryColor: AppColors.primaryOrange,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryOrange,
        surface: isDark ? const Color(0xFF111C30) : AppColors.surface,
        primary: AppColors.primaryOrange,
        secondary: AppColors.primaryEmerald,
        brightness: brightness,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF14243D) : Colors.white,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primaryOrange,
            width: 1.4,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeModeProvider(
      controller: _themeController,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeController,
        builder: (context, themeMode, _) {
          return MaterialApp(
            title: 'SwifTrip Tourist',
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            themeMode: themeMode,
            onGenerateInitialRoutes: (initialRoute) {
              return [MaterialPageRoute(builder: (_) => const SplashScreen())];
            },
            onGenerateRoute: (settings) {
              if (settings.name == null) return null;

              final uri = Uri.parse(settings.name!);

              if (uri.path == '/splash') {
                return MaterialPageRoute(builder: (_) => const SplashScreen());
              }

              if (uri.path == '/') {
                return MaterialPageRoute(builder: (_) => const SplashScreen());
              }

              if (uri.path == '/signin') {
                return MaterialPageRoute(builder: (_) => const Signin());
              }

              if (uri.path == '/signup') {
                return MaterialPageRoute(builder: (_) => const SignupScreen());
              }

              if (uri.path == '/verify-email') {
                final token = uri.queryParameters['token'];
                return MaterialPageRoute(
                  builder: (_) => VerificationScreen(token: token),
                );
              }

              if (uri.path == '/tripDetails') {
                final args = settings.arguments as Map<String, dynamic>?;
                if (args != null &&
                    args.containsKey('bookingId') &&
                    args.containsKey('type')) {
                  return MaterialPageRoute(
                    builder: (_) => TripDetailsScreen(
                      bookingId: args['bookingId'],
                      type: args['type'],
                    ),
                  );
                }
              }

              return null;
            },
            onUnknownRoute: (_) =>
                MaterialPageRoute(builder: (_) => const SplashScreen()),
          );
        },
      ),
    );
  }
}
