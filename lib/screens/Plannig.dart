import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/customBar.dart';

class PlanningScreen extends StatefulWidget {
  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}
class _PlanningScreenState extends State<PlanningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: customBar(selectedIndex: 3),
      ),
      body: Center(
        child: Text("This is the Planning Screen"),
      ),
    );
  }
}