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
  }
}
