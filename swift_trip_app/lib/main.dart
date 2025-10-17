import 'package:flutter/material.dart';
import 'package:swift_trip_app/customBar.dart';

void main() {
  runApp(SwifTripTouristApp());
}

class SwifTripTouristApp extends StatelessWidget {
  const SwifTripTouristApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwifTrip Tourist ',
      home: customBar()
    );
  }
}
