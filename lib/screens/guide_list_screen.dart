
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GuideListScreen extends StatelessWidget {
  const GuideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guide List"), backgroundColor: AppColors.background),
      body: const Center(child: Text("Guide List Placeholder", style: TextStyle(color: Colors.black))),
    );
  }
}
