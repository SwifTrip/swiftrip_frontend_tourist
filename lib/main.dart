import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/Signin.dart';
import 'screens/Signup.dart';
import 'screens/verification_screen.dart';

void main() {
  runApp(const SwifTripTouristApp());
}

class SwifTripTouristApp extends StatelessWidget {
  const SwifTripTouristApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwifTrip Tourist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFDFF2FE)),
      initialRoute: '/',
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
