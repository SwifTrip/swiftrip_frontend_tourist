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
                const SizedBox(height: 24),
                _buildSectionLabel('AVAILABLE DATES'),
                const SizedBox(height: 16),
                ..._departures.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildDepartureCard(entry.key, entry.value),
                  );
                }).toList(),
                const SizedBox(height: 24),
                _buildLegend(),
                const SizedBox(height: 140), // Spacing for footer
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        const Icon(Icons.calendar_month, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(const Color(0xFF10B981), 'Available'),
        const SizedBox(width: 16),
        _buildLegendItem(const Color(0xFFF59E0B), 'Selling Fast'),
        const SizedBox(width: 16),
        _buildLegendItem(AppColors.textSecondary.withOpacity(0.5), 'Sold Out'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
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

  Widget _buildDepartureCard(int index, Map<String, dynamic> data) {
    bool isSelected = _selectedDepartureIndex == index;
    bool isFull = data['seats'] == 0;
    
    return GestureDetector(
      onTap: isFull ? null : () => setState(() => _selectedDepartureIndex = index),
      child: Opacity(
        opacity: isFull ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? _accentColor.withOpacity(0.05) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? _accentColor : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Column(
                  children: [
                    Text(
                      data['month'],
                      style: TextStyle(
                        color: isSelected ? _accentColor : AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data['day'],
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: 32,
                width: 1,
                color: isSelected ? _accentColor.withOpacity(0.2) : AppColors.border,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['range'],
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['fullRange'],
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusBadge(data),
                  const SizedBox(height: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? _accentColor : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? _accentColor : AppColors.textSecondary.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Map<String, dynamic> data) {
    Color color;
    IconData? icon;
    String label = data['status'];

    if (data['seats'] == 0) {
      color = AppColors.textSecondary.withOpacity(0.5);
    } else if (data['seats'] <= 5) {
      color = const Color(0xFFF59E0B);
      icon = Icons.local_fire_department;
      label = '${data['seats']} seats left';
    } else {
      color = const Color(0xFF10B981);
      label = '${data['seats']} seats left';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 10),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
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
