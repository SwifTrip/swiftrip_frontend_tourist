import 'package:flutter/material.dart';
import '../models/tour_package.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';

class SelectStartDateScreen extends StatefulWidget {
  final TourPackage package;

  const SelectStartDateScreen({super.key, required this.package});

  @override
  State<SelectStartDateScreen> createState() => _SelectStartDateScreenState();
}

class _SelectStartDateScreenState extends State<SelectStartDateScreen> {
  DateTime _currentMonth = DateTime(2024, 10);
  DateTime? _selectedDate = DateTime(2024, 10, 14);
  final int _durationDays = 7;

  // Private tour accent color (Purple as per mockup)
  static const Color _privateAccent = Color(0xFF8B5CF6);

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
        title: const Text(
          'Select Start Date',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildTripSummaryCard(),
                const SizedBox(height: 24),
                _buildCalendarHeader(),
                const SizedBox(height: 100, child: Center(child: Text("Calendar selection coming..."))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.package.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PRIVATE TOUR',
                  style: TextStyle(
                    color: _privateAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  widget.package.title,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      widget.package.duration,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: Colors.white24)),
                    const SizedBox(width: 8),
                    const Text(
                      'Fixed Duration',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
          onPressed: () {},
        ),
        const Spacer(),
        const Text(
          'October 2024',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
}
