
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Trip"), backgroundColor: AppColors.background),
      body: const Center(child: Text("Create Trip Placeholder", style: TextStyle(color: Colors.black))),
    );
  }
}
