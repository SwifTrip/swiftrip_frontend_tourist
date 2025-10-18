import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/customBar.dart';

class DestinationScreen extends StatefulWidget {
  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: customBar(selectedIndex: 0),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("Select Your Journey", style: TextStyle(fontSize: 18)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text(
                "Choose your departure and arrival cities",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
