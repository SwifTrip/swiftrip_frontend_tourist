import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/Signin.dart';

class customBar extends StatelessWidget {
  final int selectedIndex ;

  const customBar({super.key, required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 130,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return Signin();
                      }));
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Center(
                      child: Text(
                        "Custom Tour Creation",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: LinearProgressIndicator(
                        value: (selectedIndex) / 5,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text("Step $selectedIndex of 5"),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonBuild(1,"Destination"),
                  buttonBuild(2,"Agency"),
                  buttonBuild(3,"Planning"),
                  buttonBuild(4,"Summary"),
                  buttonBuild(5,"Payment"),
                ],
              ),
            ),
            
          ],
        ),
    );
  }

  Widget buttonBuild(int index,String title) {
    bool isSelected = index == selectedIndex;
    return TextButton(
      onPressed: () {},
      child: Text(title, style: TextStyle(color: isSelected ? Colors.blue : Colors.black, fontSize: 16)),
    );
  }
}
