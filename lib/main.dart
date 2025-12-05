import 'package:flutter/material.dart';
import 'screens/Signin.dart';
import 'screens/home_screen.dart';

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
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFDFF2FE)),
      home: const Signin(), // Start with Signin screen
    );
  }
}
