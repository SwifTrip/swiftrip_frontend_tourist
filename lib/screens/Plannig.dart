import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/customBar.dart';

class PlanningScreen extends StatefulWidget {
  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}
class _PlanningScreenState extends State<PlanningScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: customBar(selectedIndex: 3),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Plan Your Journey",
                style: TextStyle(fontSize: 18),
              ),
            ),
            builAccomodationCard(1),
            builAccomodationCard(2),
            builAccomodationCard(3),
          ],
        ),
      ),
    );
  }


  Widget builAccomodationCard(int index) {
    bool selected = selectedIndex == index;
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Card(
          color: selected ? const Color(0xffEFF6FF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: selected ? Colors.blueAccent : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hotel Stay Resort \n ⭐4.5(150 reviews)"),
                    Text("Rs 8000/Night"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}