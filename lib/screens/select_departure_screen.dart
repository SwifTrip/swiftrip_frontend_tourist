import 'package:flutter/material.dart';
import '../models/tour_package.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';

class SelectDepartureScreen extends StatefulWidget {
  final TourPackage package;

  const SelectDepartureScreen({super.key, required this.package});

  @override
  State<SelectDepartureScreen> createState() => _SelectDepartureScreenState();
}

class _SelectDepartureScreenState extends State<SelectDepartureScreen> {
  int _selectedMonthIndex = 0;
  int _selectedDepartureIndex = 1;

  final List<String> _months = ["June '24", "July '24", "August '24", "September '24"];

  final List<Map<String, dynamic>> _departures = [
    {
      'month': 'JUN',
      'day': '10',
      'date': DateTime(2024, 6, 10),
      'range': 'Mon - Fri',
      'fullRange': 'Jun 10 - Jun 14',
      'seats': 0,
      'status': 'Fully Booked',
    },
    {
      'month': 'JUN',
      'day': '24',
      'date': DateTime(2024, 6, 24),
      'range': 'Mon - Sat',
      'fullRange': 'Jun 24 - Jun 29',
      'seats': 4,
      'status': 'Selling Fast',
    },
    {
      'month': 'JUL',
      'day': '08',
      'date': DateTime(2024, 7, 8),
      'range': 'Mon - Sat',
      'fullRange': 'Jul 08 - Jul 13',
      'seats': 10,
      'status': 'Available',
    },
    {
      'month': 'JUL',
      'day': '22',
      'date': DateTime(2024, 7, 22),
      'range': 'Mon - Sat',
      'fullRange': 'Jul 22 - Jul 27',
      'seats': 8,
      'status': 'Available',
    },
    {
      'month': 'AUG',
      'day': '05',
      'date': DateTime(2024, 8, 5),
      'range': 'Mon - Sat',
      'fullRange': 'Aug 05 - Aug 10',
      'seats': 12,
      'status': 'Available',
    },
  ];

  static const Color _accentColor = Color(0xFF137FEC);

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
          'Select Departure',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
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
                _buildMonthSelector(),
                const SizedBox(height: 100, child: Center(child: Text("Departure selection coming..."))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _months.asMap().entries.map((entry) {
          bool isSelected = _selectedMonthIndex == entry.key;
          return GestureDetector(
            onTap: () => setState(() => _selectedMonthIndex = entry.key),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : AppColors.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: isSelected ? Colors.transparent : AppColors.border),
                boxShadow: isSelected ? [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
                ] : null,
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  color: isSelected ? AppColors.background : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(8),
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
                Text(
                  widget.package.title,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.package.duration,
                        style: const TextStyle(color: _accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Public Group Tour',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$550',
                style: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 12, decoration: TextDecoration.lineThrough),
              ),
              Text(
                widget.package.price,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
