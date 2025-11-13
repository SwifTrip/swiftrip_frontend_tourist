import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/customBar.dart';
import 'package:swift_trip_app/widgets/custom_app_bar.dart';
import 'package:swift_trip_app/widgets/custom_bottom_bar.dart';

class AgencyScreen extends StatefulWidget {
  @override
  _AgencyScreenState createState() => _AgencyScreenState();
}
class _AgencyScreenState extends State<AgencyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentStep: 1),
      body: Center(
        child: Text('Welcome to the Agency Screen!'),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1),
    );
  }
}