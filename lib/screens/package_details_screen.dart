import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/tour_package.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';

class PackageDetailsScreen extends StatefulWidget {
  final TourPackage package;
  final bool isPublic;

  const PackageDetailsScreen({
    super.key, 
    required this.package, 
    this.isPublic = true,
  });

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  final List<bool> _isDayExpanded = [];

  @override
  void initState() {
    super.initState();
    // Initialize all days as collapsed except the first one
    for (int i = 0; i < widget.package.itinerary.length; i++) {
      _isDayExpanded.add(i == 0);
    }
  }

  Color get _accentColor => widget.isPublic ? const Color(0xFF137FEC) : Colors.purpleAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const Center(child: Text("Package Details Skeleton")),
    );
  }
}
