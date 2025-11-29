
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FixedPackagesScreen extends StatelessWidget {
  const FixedPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fixed Packages"), backgroundColor: AppColors.background),
      body: const Center(child: Text("Fixed Packages Placeholder", style: TextStyle(color: Colors.black))),
    );
  }
}
