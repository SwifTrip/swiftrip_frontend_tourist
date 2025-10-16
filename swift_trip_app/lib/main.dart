import 'package:flutter/material.dart';

void main() {
  runApp(SwifTripTouristApp());
}

class SwifTripTouristApp extends StatelessWidget {
  const SwifTripTouristApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwifTrip Tourist',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Roboto'),
    );
  }
}
