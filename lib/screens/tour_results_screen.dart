
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              '$destination ${isPublic ? 'Public' : 'Private'} Tours',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$dates • $guests Guests',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildFilterBar(),
          const Expanded(
            child: Center(
              child: Text(
                'Tour results list coming next...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip('Recommended', isActive: true, hasDropdown: true),
          const SizedBox(width: 8),
          _buildFilterChip('Price: Low to High'),
          const SizedBox(width: 8),
          _buildFilterChip('Duration'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isActive = false, bool hasDropdown = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.accent : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isActive ? AppColors.accent : AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  Widget _buildTourCard({
    required BuildContext context,
    required String title,
    required String locations,
    required int price,
    required double rating,
    required int reviews,
    required String duration,
    required String imageUrl,
    required List<String> tags,
    bool isPopular = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content will be added in subsequent commits
          const SizedBox(height: 100, child: Center(child: Text("Tour Card Content"))),
        ],
      ),
    );
  }
}
