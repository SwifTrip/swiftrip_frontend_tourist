import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/Destination.dart';
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
        child: customBar(selectedIndex: 2),
      ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.brown,
                            ),
                            Text("Mountain \nAdventures"),
                            Text("Rs\n5000"),
                          ],
                        ),
                        Text("⭐ 4.8 (200 reviews)"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 300,
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 5,
                                  ),
                              shrinkWrap: true,
                              children: [
                                Card(
                                  child: Center(child: Text("Mountain Tours")),
                                ),
                                Card(
                                  child: Center(
                                    child: Text("Adventure Travels"),
                                  ),
                                ),
                                Card(child: Center(child: Text("Photography"))),
                              ],
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DestinationScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back, color: Colors.black),
                            Text("Back", style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
