import 'package:flutter/material.dart';
import '../models/tour_package.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
// import '../widgets/accommodation_selection_sheet.dart'; // To be migrated next
// import 'review_trip_screen.dart'; // To be migrated later

class CustomizeItineraryScreen extends StatefulWidget {
  final TourPackage package;
  final bool isPublic;
  final DateTime startDate;

  const CustomizeItineraryScreen({
    super.key, 
    required this.package, 
    required this.isPublic,
    required this.startDate,
  });

  @override
  State<CustomizeItineraryScreen> createState() => _CustomizeItineraryScreenState();
}

class _CustomizeItineraryScreenState extends State<CustomizeItineraryScreen> {
  int _selectedDayIndex = 0;
  
  // Accents based on tour type
  late final Color _accentColor;
  
  @override
  void initState() {
    super.initState();
    _accentColor = widget.isPublic ? const Color(0xFF137FEC) : const Color(0xFF8B5CF6);
  }

  @override
  Widget build(BuildContext context) {
    // Generate dates based on start date and duration
    final duration = int.parse(widget.package.duration.split(' ')[0]);
    final dates = List.generate(duration, (index) => widget.startDate.add(Duration(days: index)));

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
            const Text(
              'Customize Itinerary',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.package.title,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined, color: _accentColor),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppColors.border, height: 1),
        ),
      ),
      body: Column(
        children: [
          _buildDaySelector(dates),
          const Expanded(child: Center(child: Text("Itinerary Content Placeholder"))),
        ],
      ),
    );
  }

  Widget _buildDaySelector(List<DateTime> dates) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: dates.asMap().entries.map((entry) {
            final index = entry.key;
            final date = entry.value;
            final isSelected = _selectedDayIndex == index;
            final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            
            return GestureDetector(
              onTap: () => setState(() => _selectedDayIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(minWidth: 70),
                decoration: BoxDecoration(
                  color: isSelected ? _accentColor : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? Colors.transparent : AppColors.border),
                  boxShadow: isSelected ? [
                    BoxShadow(color: _accentColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                  ] : null,
                ),
                child: Column(
                  children: [
                    Text(
                      'DAY ${index + 1}',
                      style: TextStyle(
                        color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textSecondary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '${date.day} ${months[date.month - 1]}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  Widget _buildDayHeader(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              widget.package.itinerary[_selectedDayIndex].title,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Icon(Icons.location_on_outlined, color: _accentColor, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool isCustomizable = false, bool isFixed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        if (isCustomizable)
          const Text(
            'CHANGE',
            style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
          )
        else if (isFixed)
          Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.textSecondary.withOpacity(0.5), size: 10),
              const SizedBox(width: 4),
              Text(
                'LOCKED',
                style: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ],
    );
  }
}
