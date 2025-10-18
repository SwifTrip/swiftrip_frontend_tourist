import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/customBar.dart';

class DestinationScreen extends StatefulWidget {
  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final List<String> cities = ["Islamabad", "Lahore", "Karachi", "Peshawar"];
  String fromCity = "";
  String toCity = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: customBar(selectedIndex: 1),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Select Your Journey",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text(
                "Choose your departure and arrival cities",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _labelbuild("Departure City"),
                    _dropdownbuild("Departure City"),
                    _labelbuild("Arrival City"),
                    _dropdownbuild("Arrival City"),
                  ],
                ),
              ),
            ),
            Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 120,
                          vertical: 15,
                        ),
                        child: Text("Continue", style: TextStyle()),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _labelbuild(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.place,
            color: title == "Departure City" ? Colors.blue : Colors.green,
          ),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _dropdownbuild(String city) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffF9FAFB),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          hintText: city,
        ),
        items: cities.map((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) {
            if (city == "Arrival City") {
              toCity = value.toString();
            } else {
              fromCity = value.toString();
            }
          })
    );
  }
}
