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
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                    "Choose Your Travel Partner",
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 15),
                    child: Text(
                      "Select from our trusted travel agencies",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
          ],),
        )
      ),
    );
  }
}