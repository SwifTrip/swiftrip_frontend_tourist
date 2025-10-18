import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/Destination.dart';
import 'package:swift_trip_app/screens/customBar.dart';

void main() {
  runApp(SwifTripTouristApp());
}

class SwifTripTouristApp extends StatelessWidget {
  const SwifTripTouristApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwifTrip Tourist ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFDFF2FE),
          ),
      home: DestinationScreen(),
    );
  }
}
