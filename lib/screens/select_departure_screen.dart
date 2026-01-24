import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import 'customize_itinerary_screen.dart';

class SelectDepartureScreen extends StatefulWidget {
  final CustomizeItineraryModel package;
  final int travelers;

  const SelectDepartureScreen({super.key, required this.package, required this.travelers});

  @override
  State<SelectDepartureScreen> createState() => _SelectDepartureScreenState();
}

class _SelectDepartureScreenState extends State<SelectDepartureScreen> {
  int _selectedMonthIndex = 0;
  int _selectedDepartureIndex = 1;

  final List<String> _months = ["June '26", "July '26", "August '26", "September '26"];

  final List<Map<String, dynamic>> _departures = [
    {
      'month': 'JUN',
      'day': '10',
      'date': DateTime(2026, 6, 10),
      'range': 'Mon - Fri',
      'fullRange': 'Jun 10 - Jun 14',
      'seats': 0,
      'status': 'Fully Booked',
    },
    {
      'month': 'JUN',
      'day': '24',
      'date': DateTime(2026, 6, 24),
      'range': 'Mon - Sat',
      'fullRange': 'Jun 24 - Jun 29',
      'seats': 4,
      'status': 'Selling Fast',
    },
    {
      'month': 'JUL',
      'day': '08',
      'date': DateTime(2026, 7, 8),
      'range': 'Mon - Sat',
      'fullRange': 'Jul 08 - Jul 13',
      'seats': 10,
      'status': 'Available',
    },
    {
      'month': 'JUL',
      'day': '22',
      'date': DateTime(2026, 7, 22),
      'range': 'Mon - Sat',
      'fullRange': 'Jul 22 - Jul 27',
      'seats': 8,
      'status': 'Available',
    },
    {
      'month': 'AUG',
      'day': '05',
      'date': DateTime(2026, 8, 5),
      'range': 'Mon - Sat',
      'fullRange': 'Aug 05 - Aug 10',
      'seats': 12,
      'status': 'Available',
    },
  ];

  Color get _accentColor => AppColors.primaryOrange;

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
        title: Text(
          'Select Departure',
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
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
                const SizedBox(height: 32),
                _buildMonthSelector(),
                const SizedBox(height: 32),
                _buildSectionLabel('AVAILABLE DEPARTURES'),
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
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildStickyFooter() {
    final selectedDeparture = _departures[_selectedDepartureIndex];
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, -10))
          ],
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SELECTED DEPARTURE',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedDeparture['fullRange'],
                    style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CommonButton(
                text: 'Continue',
                onPressed: () {
                  final selectedDeparture = _departures[_selectedDepartureIndex];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomizeItineraryScreen(
                        package: widget.package,
                        isPublic: true,
                        startDate: selectedDeparture['date'],
                        travelers: widget.travelers,
                      ),
                    ),
                  );
                },
                borderRadius: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        const Icon(Icons.event_note, color: AppColors.primaryOrange, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(AppColors.primaryEmerald, 'Available'),
          const SizedBox(width: 24),
          _buildLegendItem(Colors.amber, 'Selling Fast'),
          const SizedBox(width: 24),
          _buildLegendItem(AppColors.textSecondary.withOpacity(0.4), 'Fully Booked'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
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
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? Colors.transparent : AppColors.border),
                boxShadow: isSelected ? [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))
                ] : null,
              ),
              child: Text(
                entry.value,
                style: GoogleFonts.plusJakartaSans(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : (isFull ? AppColors.border.withOpacity(0.5) : AppColors.border),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: AppColors.primaryOrange.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))
          ] : null,
        ),
        child: Opacity(
          opacity: isFull ? 0.6 : 1.0,
          child: Row(
            children: [
              Container(
                width: 54,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryOrange : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      data['month'],
                      style: TextStyle(
                        color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data['day'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['range'],
                      style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['fullRange'],
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusBadge(data),
                  if (isSelected) ...[
                     const SizedBox(height: 8),
                     const Icon(Icons.check_circle, color: AppColors.primaryOrange, size: 24),
                  ],
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
      color = Colors.amber;
      icon = Icons.bolt;
      label = '${data['seats']} LEFT';
    } else {
      color = AppColors.primaryEmerald;
      label = 'AVAILABLE';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              "https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=300",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.package.title,
                  style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.package.duration} DAYS',
                        style: const TextStyle(color: AppColors.primaryOrange, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Group Expedition',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${widget.package.currency} ${widget.package.basePrice}',
                  style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Text('per guest', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
