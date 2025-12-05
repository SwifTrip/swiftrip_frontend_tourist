import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import '../widgets/accommodation_selection_sheet.dart';
import 'review_trip_screen.dart';

class CustomizeItineraryScreen extends StatefulWidget {
  final CustomizeItineraryModel package;
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
    final duration = (widget.package.duration is int)
        ? (widget.package.duration as int)
        : widget.package.duration.toInt();
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
      body: Stack(
        children: [
          Column(
            children: [
              _buildDaySelector(dates),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildDayHeader(dates[_selectedDayIndex]),
                      const SizedBox(height: 24),
                      _buildSectionHeader('ACCOMMODATION', isCustomizable: !widget.isPublic),
                      const SizedBox(height: 12),
                      _buildHotelCard(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('TRANSPORT', isFixed: true),
                      const SizedBox(height: 12),
                      _buildTransportCard(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('ACTIVITIES & EXTRAS'),
                      const SizedBox(height: 12),
                      _buildActivityCard(
                        title: 'Baltit Fort Guided Tour',
                        subtitle: 'Historic Landmark visit',
                        icon: Icons.fort_outlined,
                        isInPlan: true,
                      ),
                      const SizedBox(height: 12),
                      _buildActivityCard(
                        title: 'Traditional Hunza Dinner',
                        subtitle: 'Live music & local cuisine',
                        icon: Icons.restaurant_outlined,
                        isPopular: true,
                        price: '+\$35',
                      ),
                      const SizedBox(height: 24),
                      _buildDayNote(),
                      const SizedBox(height: 140), // Spacing for footer
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildStickyFooter(),
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
              widget.package.itineraries[_selectedDayIndex].title,
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

  void _showAccommodationPicker(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AccommodationSelectionSheet(
        isPublic: widget.isPublic,
        day: 'Day ${_selectedDayIndex + 1}',
        date: '${date.day} ${months[date.month - 1]}',
        location: widget.package.itineraries[_selectedDayIndex].title,
      ),
    );
  }

  Widget _buildHotelCard() {
    final isCustomizable = !widget.isPublic;
    
    return GestureDetector(
      onTap: isCustomizable ? () => _showAccommodationPicker(widget.startDate.add(Duration(days: _selectedDayIndex))) : null,
      child: Container(
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
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCJ63yU4pc9m4bcYiIRArzFDSP_KI3AUe5IOfp2OPRbK0WFJrIq9oZLq2MJlkHnUlKc7_gSDi0ZDtT8Qgjqlt1KdpJ3kT8ZKTdUTV3n86Ao5glkAvkNvpKz5mFdmcdBbu_E5BkzpbU2VWmHO1JDXoYKy8cRSSqiZWTlVFboXax5qolrS3ZhApq-YbGOkgcuV7T-ig44eFIHE3pqCqrzlNWfJBeHAO-Jn8b7jv-I5sPGUZNVxg9F02GWis-boOAMc5Q2rUbJ3D4NdtZU',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Luxus Hunza Resort',
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      if (isCustomizable)
                        Icon(Icons.chevron_right, color: AppColors.textSecondary.withOpacity(0.5)),
                    ],
                  ),
                  Text(
                    'Deluxe Lake View Room',
                    style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8), fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.white, size: 8),
                            SizedBox(width: 2),
                            Text('4.8', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Current Selection',
                        style: TextStyle(color: _accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(widget.isPublic ? Icons.directions_bus_outlined : Icons.airport_shuttle_outlined, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.isPublic ? 'Shared AC Coaster' : 'Private Airport Transfer',
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          Icon(Icons.lock_outline, color: AppColors.textSecondary.withOpacity(0.5), size: 14),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String subtitle,
    required IconData icon,
    bool isInPlan = false,
    bool isPopular = false,
    String? price,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isInPlan ? _accentColor.withOpacity(0.05) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isInPlan ? _accentColor.withOpacity(0.3) : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isInPlan ? _accentColor.withOpacity(0.1) : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isInPlan ? _accentColor : AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    if (isPopular)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: const Text('POPULAR', style: TextStyle(color: Color(0xFF10B981), fontSize: 7, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isInPlan)
            const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (price != null)
                  Text(price, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                const Text('ADD', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDayNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DAY NOTE',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.edit_note_outlined, color: AppColors.textSecondary.withOpacity(0.5), size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Add a special request or note for this day...',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStickyFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -10))
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ESTIMATED TOTAL',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                Text(
                  widget.isPublic ? '${widget.package.currency} ${widget.package.basePrice}' : '\$3,450',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.isPublic ? 'Fixed Price' : 'Includes + \$220 upgrades',
                  style: TextStyle(color: widget.isPublic ? AppColors.textSecondary : const Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 56,
                child: CommonButton(
                  text: 'Review Trip',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewTripScreen(
                          package: widget.package,
                          isPublic: widget.isPublic,
                          startDate: widget.startDate,
                        ),
                      ),
                    );
                  },
                  backgroundColor: _accentColor,
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
