import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/Agency.dart';
import 'package:swift_trip_app/screens/Plannig.dart';
import 'package:swift_trip_app/screens/Signin.dart';

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
      home: PlanningScreen(), // Start with Signin screen
    );
  }
}
