import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/Agency.dart';

void main() {
  runApp(SwifTripTouristApp());
}

class SwifTripTouristApp extends StatelessWidget {
  const SwifTripTouristApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwifTrip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFDFF2FE),
          ),
      home: AgencyScreen(),
    );
  }
}
