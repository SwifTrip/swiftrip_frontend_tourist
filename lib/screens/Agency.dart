import 'package:flutter/material.dart';

class agency extends StatefulWidget {
  @override
  _agencyState createState() => _agencyState();
}
class _agencyState extends State<agency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agency Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Agency Screen!'),
      ),
    );
  }
}