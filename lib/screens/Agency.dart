import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/customBar.dart';

class AgencyScreen extends StatefulWidget {
  @override
  _AgencyScreenState createState() => _AgencyScreenState();
}
class _AgencyScreenState extends State<AgencyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: customBar(selectedIndex: 2)),
      body: Center(
        child: Text('Welcome to the Agency Screen!'),
      ),
    );
  }
}