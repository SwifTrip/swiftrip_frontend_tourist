import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});
  @override
  State<Signin> createState() {
    return SigninState();
  }
}

class SigninState extends State<Signin> {
  @override
  Widget build(context) {
    return MaterialApp(
      title: 'SwifTrip Tourist ',
      theme: ThemeData(
        primarySwatch: Colors.teal, 
        fontFamily: 'Roboto'
        ),
      home: Scaffold(
        body: SafeArea(
            child: Text(
                "Testing Signin Class"
                ),
            ),
      )
    );
    
  }
}
