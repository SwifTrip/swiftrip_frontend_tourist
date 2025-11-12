import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/customBar.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final List<String> cities = ["Islamabad", "Lahore", "Karachi", "Peshawar"];
  late String fromCity = cities[0];
  late String toCity = cities[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: customBar(selectedIndex: 1),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                      _routePreviewBuild()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
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
      ),
    );
  }

  Widget _labelbuild(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      padding: EdgeInsets.symmetric(horizontal: 10),
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
        initialValue: city == "Arrival City" ? toCity : fromCity,
        items: cities.map((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) {
          setState(() {
            if (city == "Arrival City") {
            toCity = value.toString();
          } else {
            fromCity = value.toString();
          }
          });
        },
      ),
    );
  }

  Widget _routePreviewBuild() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 500,
        height: 105,
        child: Card(
          color: Color(0xffEFF6FF),
          elevation: 1,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(Icons.directions_bus, color: Colors.blueGrey),
                        ),
                        Text(
                          "Route Preview",
                          style: TextStyle(color: Color(0xff1C398E)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 0,
                ),
                child: Row(
                  children: [
                    Text(fromCity, style: TextStyle(color: Color(0xff1447E6))),
                    Icon(Icons.arrow_forward, color: Color(0xff1447E6)),
                    Text(toCity, style: TextStyle(color: Color(0xff1447E6))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
