import 'package:flutter/material.dart';
import '../models/tour_package.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';

class ReviewTripScreen extends StatefulWidget {
  final TourPackage package;
  final bool isPublic;
  final DateTime startDate;

  const ReviewTripScreen({
    super.key,
    required this.package,
    required this.isPublic,
    required this.startDate,
  });

  @override
  State<ReviewTripScreen> createState() => _ReviewTripScreenState();
}

class _ReviewTripScreenState extends State<ReviewTripScreen> {
  late final Color _accentColor;
  bool _allExpanded = true;

  @override
  void initState() {
    super.initState();
    _accentColor = widget.isPublic ? const Color(0xFF137FEC) : const Color(0xFF8B5CF6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text(
              'Review Trip',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Step 3 of 4',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: const Center(child: Text("Review Trip Skeleton")),
    );
  }
}
