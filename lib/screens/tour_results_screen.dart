
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import '../models/tour_package.dart';
// import 'package_details_screen.dart'; // To be migrated in Phase 3

class TourResultsScreen extends StatelessWidget {
  final String destination;
  final String dates;
  final int guests;
  final bool isPublic;

  const TourResultsScreen({
    super.key,
    required this.isPublic,
    this.destination = 'Hunza',
    this.dates = 'Sep 15 - Sep 19',
    this.guests = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Tour Results for $destination',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
