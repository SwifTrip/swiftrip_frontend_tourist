import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/Signin.dart';
import 'screens/Signup.dart';
import 'screens/verification_screen.dart';
import 'services/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SwifTripTouristApp());
}

class SwifTripTouristApp extends StatefulWidget {
  const SwifTripTouristApp({super.key});

  @override
  State<SwifTripTouristApp> createState() => _SwifTripTouristAppState();
}

class _SwifTripTouristAppState extends State<SwifTripTouristApp> {
  late Future<bool> _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = _checkLoginStatus();
  }

  Future<bool> _checkLoginStatus() async {
    final token = await TokenService.getToken();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwifTrip Tourist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFDFF2FE)),
      home: FutureBuilder<bool>(
        future: _isLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show splash/loading screen while checking auth status
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If logged in, show home screen; otherwise show sign in
          if (snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const Signin();
          }
        },
      ),
      onGenerateRoute: (settings) {
        if (settings.name == null) return null;
        
        final uri = Uri.parse(settings.name!);
        
        if (uri.path == '/') {
          return MaterialPageRoute(builder: (_) => const HomeScreen());
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
        
        return null;
      },
    );
  }
}
