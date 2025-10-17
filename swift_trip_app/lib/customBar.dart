import 'package:flutter/material.dart';

class customBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          height: 100,
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
                        Navigator.pop(context);
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buttonBuild("Destination"),
                    buttonBuild("Agency"),
                    buttonBuild("Planning"),
                    buttonBuild("Summary"),
                    buttonBuild("Payment"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonBuild(String title) {
    return TextButton(
      onPressed: () {},
      child: Text(title, style: TextStyle(color: Colors.black, fontSize: 16)),
    );
  }
}
