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
        child: Text("Destination Screen"),
      ),
    );
  }
}
