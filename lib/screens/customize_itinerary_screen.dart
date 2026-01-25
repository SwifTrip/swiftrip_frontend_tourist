import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import 'review_trip_screen.dart';

class CustomizeItineraryScreen extends StatefulWidget {
  final CustomizeItineraryModel package;
  final bool isPublic;
  final DateTime startDate;
  final int travelers;

  const CustomizeItineraryScreen({
    super.key, 
    required this.package, 
    required this.isPublic,
    required this.startDate,
    required this.travelers,
  });

  @override
  State<CustomizeItineraryScreen> createState() => _CustomizeItineraryScreenState();
}

class _CustomizeItineraryScreenState extends State<CustomizeItineraryScreen> {
  int _selectedDayIndex = 0;
  
  Map<int, bool> _selectedOptionalItems = {};
  
  Color get _accentColor => AppColors.primaryOrange;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Customize Itinerary',
              style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.package.title,
              style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
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
                      if (_getAccommodationItemsForDay().isNotEmpty) ...[
                        _buildSectionHeader('ACCOMMODATION', isCustomizable: !widget.isPublic),
                        const SizedBox(height: 12),
                        _buildAccommodationSection(dates[_selectedDayIndex]),
                        const SizedBox(height: 24),
                      ],
                      if (_getTransportItemsForDay().isNotEmpty) ...[
                        _buildSectionHeader('TRANSPORT', isCustomizable: !widget.isPublic),
                        const SizedBox(height: 12),
                        _buildTransportSection(dates[_selectedDayIndex]),
                        const SizedBox(height: 24),
                      ],
                      if (_getMealItemsForDay().isNotEmpty) ...[
                        _buildSectionHeader('MEALS', isCustomizable: !widget.isPublic),
                        const SizedBox(height: 12),
                        _buildMealSection(dates[_selectedDayIndex]),
                        const SizedBox(height: 24),
                      ],
                      if (_getActivityItemsForDay().isNotEmpty) ..._buildActivitySection(),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.5))),
      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? _accentColor : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? Colors.transparent : AppColors.border),
                  boxShadow: isSelected ? [
                    BoxShadow(color: _accentColor.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6))
                  ] : null,
                ),
                child: Column(
                  children: [
                    Text(
                      'DAY ${index + 1}',
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textSecondary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day} ${months[date.month - 1]}',
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 14,
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
          style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          widget.package.itineraries[_selectedDayIndex].title,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
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
          style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),if (isFixed)
          Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.textSecondary.withOpacity(0.5), size: 12),
              const SizedBox(width: 4),
              Text(
                'LOCKED',
                style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ],
    );
  }

  List<ItineraryItem> _getItemsForSelectedDay() {
    if (_selectedDayIndex >= widget.package.itineraries.length) {
      return [];
    }
    return widget.package.itineraries[_selectedDayIndex].items;
  }

  List<ItineraryItem> _getAccommodationItemsForDay() {
    return _getItemsForSelectedDay()
        .where((item) => item.type.toLowerCase() == 'stay')
        .toList();
  }

  List<ItineraryItem> _getTransportItemsForDay() {
    return _getItemsForSelectedDay()
        .where((item) => item.type.toLowerCase() == 'transport')
        .toList();
  }

  List<ItineraryItem> _getMealItemsForDay() {
    return _getItemsForSelectedDay()
        .where((item) => item.type.toLowerCase() == 'meal')
        .toList();
  }

  List<ItineraryItem> _getActivityItemsForDay() {
    return _getItemsForSelectedDay()
        .where((item) => item.type.toLowerCase() == 'activity')
        .toList();
  }

  List<Widget> _buildActivitySection() {
    final items = _getActivityItemsForDay();
    final widgets = <Widget>[
      _buildSectionHeader('ACTIVITIES'),
      const SizedBox(height: 12),
    ];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      widgets.add(
        _buildActivityCard(
          item: item,
          isFixed: !item.optional,
          isSelected: _selectedOptionalItems[item.id] ?? false,
        ),
      );
      if (i < items.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }

    return widgets;
  }

  num _calculateTotalPrice() {
    num total = widget.package.basePrice;
    final items = [
      ..._getActivityItemsForDay(),
      ..._getAccommodationItemsForDay(),
      ..._getTransportItemsForDay(),
      ..._getMealItemsForDay(),
    ];

    for (final item in items) {
      if (item.optional && (_selectedOptionalItems[item.id] ?? false)) {
        total += item.price;
      }
    }

    return total*widget.travelers;
  }

  String _buildPriceDescription() {
    final items = [
      ..._getActivityItemsForDay(),
      ..._getAccommodationItemsForDay(),
      ..._getTransportItemsForDay(),
      ..._getMealItemsForDay(),
    ];
    num addOnTotal = 0;

    for (final item in items) {
      if (item.optional && (_selectedOptionalItems[item.id] ?? false)) {
        addOnTotal += item.price;
      }
    }

    if (addOnTotal > 0) {
      return 'Base + Rs${addOnTotal} add-ons';
    } else {
      return 'Base price';
    }
  }

  Widget _buildAccommodationSection(DateTime date) {
    final stays = _getAccommodationItemsForDay();
    if (stays.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: const [
            Icon(Icons.hotel_outlined, color: AppColors.textSecondary, size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No accommodation scheduled for this day.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < stays.length; i++) ...[
          _buildAccommodationCard(
            item: stays[i],
            date: date,
          ),
          if (i < stays.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildAccommodationCard({
    required ItineraryItem item,
    required DateTime date,
  }) {
    final isCustomizable = !widget.isPublic && item.optional;
    final isFixed = !item.optional;
    final isSelected = _selectedOptionalItems[item.id] ?? item.optional == false;

    return GestureDetector(
      onTap: isCustomizable
          ? () {
              setState(() {
                final optionalAccommodations = _getAccommodationItemsForDay()
                    .where((acc) => acc.optional)
                    .toList();
                
                for (final acc in optionalAccommodations) {
                  if (acc.id != item.id) {
                    _selectedOptionalItems[acc.id] = false;
                  }
                }
                _selectedOptionalItems[item.id] = !(_selectedOptionalItems[item.id] ?? false);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.primaryOrange : AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryOrange.withOpacity(0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.hotel_outlined, color: isSelected ? AppColors.primaryOrange : AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name.isNotEmpty ? item.name : 'Stay',
                          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFixed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('INCLUDED', style: TextStyle(color: AppColors.primaryEmerald, fontSize: 8, fontWeight: FontWeight.bold)),
                        )
                      else if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primaryOrange, size: 20)
                      else
                        Icon(Icons.add_circle_outline, color: AppColors.textSecondary.withOpacity(0.4), size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description.isNotEmpty ? item.description : 'Accommodation for this night.',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary.withOpacity(0.5)),
                      const SizedBox(width: 6),
                      Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontSize: 11),
                      ),
                      const Spacer(),
                      if (item.price > 0)
                        Text(
                          item.optional ? '+Rs${item.price}' : 'Rs${item.price}',
                          style: GoogleFonts.plusJakartaSans(color: isFixed ? AppColors.textSecondary : AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      else
                        const Text(
                          'Included',
                          style: TextStyle(color: AppColors.primaryEmerald, fontSize: 11, fontWeight: FontWeight.w600),
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

  Widget _buildTransportSection(DateTime date) {
    final transports = _getTransportItemsForDay();
    if (transports.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: const [
            Icon(Icons.directions_bus_outlined, color: AppColors.textSecondary, size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No transport scheduled for this day.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < transports.length; i++) ...[
          _buildTransportItemCard(item: transports[i], date: date),
          if (i < transports.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildTransportItemCard({
    required ItineraryItem item,
    required DateTime date,
  }) {
    final isCustomizable = !widget.isPublic && item.optional;
    final isFixed = !item.optional;
    final isSelected = _selectedOptionalItems[item.id] ?? item.optional == false;

    return GestureDetector(
      onTap: isCustomizable
          ? () {
              setState(() {
                _selectedOptionalItems[item.id] = !(_selectedOptionalItems[item.id] ?? false);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.primaryOrange : AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryOrange.withOpacity(0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.directions_bus_outlined, color: isSelected ? AppColors.primaryOrange : AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name.isNotEmpty ? item.name : 'Transport',
                          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFixed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('INCLUDED', style: TextStyle(color: AppColors.primaryEmerald, fontSize: 8, fontWeight: FontWeight.bold)),
                        )
                      else if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primaryOrange, size: 20)
                      else
                        Icon(Icons.add_circle_outline, color: AppColors.textSecondary.withOpacity(0.4), size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description.isNotEmpty ? item.description : 'Transport for this day.',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary.withOpacity(0.5)),
                      const SizedBox(width: 6),
                      Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontSize: 11),
                      ),
                      const Spacer(),
                      if (item.price > 0)
                        Text(
                          item.optional ? '+Rs${item.price}' : 'Rs${item.price}',
                          style: GoogleFonts.plusJakartaSans(color: isFixed ? AppColors.textSecondary : AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      else
                        const Text(
                          'Included',
                          style: TextStyle(color: AppColors.primaryEmerald, fontSize: 11, fontWeight: FontWeight.w600),
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

  Widget _buildMealSection(DateTime date) {
    final meals = _getMealItemsForDay();
    if (meals.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: const [
            Icon(Icons.restaurant_menu_outlined, color: AppColors.textSecondary, size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No meals scheduled for this day.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    // Group meals by meal type from mealDetails
    final breakfastMeals = <ItineraryItem>[];
    final lunchMeals = <ItineraryItem>[];
    final dinnerMeals = <ItineraryItem>[];

    for (final meal in meals) {
      for (final detail in meal.mealDetails) {
        final mealType = detail.mealType.toLowerCase();
        if (mealType == 'breakfast') {
          breakfastMeals.add(meal);
          break;
        } else if (mealType == 'lunch') {
          lunchMeals.add(meal);
          break;
        } else if (mealType == 'dinner') {
          dinnerMeals.add(meal);
          break;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breakfastMeals.isNotEmpty) ...[
          const Text(
            'BREAKFAST',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < breakfastMeals.length; i++) ...[
            _buildMealItemCard(item: breakfastMeals[i], date: date),
            if (i < breakfastMeals.length - 1) const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),
        ],
        if (lunchMeals.isNotEmpty) ...[
          const Text(
            'LUNCH',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < lunchMeals.length; i++) ...[
            _buildMealItemCard(item: lunchMeals[i], date: date),
            if (i < lunchMeals.length - 1) const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),
        ],
        if (dinnerMeals.isNotEmpty) ...[
          const Text(
            'DINNER',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < dinnerMeals.length; i++) ...[
            _buildMealItemCard(item: dinnerMeals[i], date: date),
            if (i < dinnerMeals.length - 1) const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }

  Widget _buildMealItemCard({
    required ItineraryItem item,
    required DateTime date,
  }) {
    final isCustomizable = !widget.isPublic && item.optional;
    final isFixed = !item.optional;
    final isSelected = _selectedOptionalItems[item.id] ?? item.optional == false;

    return GestureDetector(
      onTap: isCustomizable
          ? () {
              setState(() {
                String? currentMealType;
                for (final detail in item.mealDetails) {
                  currentMealType = detail.mealType.toLowerCase();
                  break;
                }
                
                if (currentMealType != null) {
                  final allMeals = _getMealItemsForDay();
                  for (final meal in allMeals) {
                    if (meal.optional && meal.id != item.id) {
                      for (final detail in meal.mealDetails) {
                        if (detail.mealType.toLowerCase() == currentMealType) {
                          _selectedOptionalItems[meal.id] = false;
                          break;
                        }
                      }
                    }
                  }
                }
                _selectedOptionalItems[item.id] = !(_selectedOptionalItems[item.id] ?? false);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.primaryOrange : AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryOrange.withOpacity(0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.restaurant_menu_outlined, color: isSelected ? AppColors.primaryOrange : AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name.isNotEmpty ? item.name : 'Meal',
                          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFixed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('INCLUDED', style: TextStyle(color: AppColors.primaryEmerald, fontSize: 8, fontWeight: FontWeight.bold)),
                        )
                      else if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primaryOrange, size: 20)
                      else
                        Icon(Icons.add_circle_outline, color: AppColors.textSecondary.withOpacity(0.4), size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description.isNotEmpty ? item.description : 'Meal for this day.',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary.withOpacity(0.5)),
                      const SizedBox(width: 6),
                      Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontSize: 11),
                      ),
                      const Spacer(),
                      if (item.price > 0)
                        Text(
                          item.optional ? '+Rs${item.price}' : 'Rs${item.price}',
                          style: GoogleFonts.plusJakartaSans(color: isFixed ? AppColors.textSecondary : AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      else
                        const Text(
                          'Included',
                          style: TextStyle(color: AppColors.primaryEmerald, fontSize: 11, fontWeight: FontWeight.w600),
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

  Widget _buildActivityCard({
    required ItineraryItem item,
    required bool isFixed,
    required bool isSelected,
  }) {
    final isIncluded = isFixed && item.optional == false;
    
    return GestureDetector(
      onTap: isFixed ? null : () {
        setState(() {
          _selectedOptionalItems[item.id] = !(_selectedOptionalItems[item.id] ?? false);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.primaryOrange : (isFixed ? AppColors.border.withOpacity(0.5) : AppColors.border)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Opacity(
          opacity: isFixed ? 0.8 : 1.0,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryOrange.withOpacity(0.1) : AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.local_activity_outlined,
                  color: isSelected ? AppColors.primaryOrange : AppColors.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isIncluded)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryEmerald.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'INCLUDED',
                              style: TextStyle(color: AppColors.primaryEmerald, fontSize: 7, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.4),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isFixed) ...[
                       const SizedBox(height: 6),
                       Text(
                          item.price > 0 ? '+Rs${item.price}' : 'Free Activity',
                          style: GoogleFonts.plusJakartaSans(color: isSelected ? AppColors.primaryOrange : AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isFixed)
                Icon(
                  Icons.lock_outline,
                  color: AppColors.textSecondary.withOpacity(0.3),
                  size: 18,
                )
              else if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primaryOrange, size: 24)
              else
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.textSecondary.withOpacity(0.3),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStickyFooter() {
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
                    'ESTIMATED TOTAL',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.package.currency} ${_calculateTotalPrice()}',
                    style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.isPublic ? 'Fixed Expedition Price' : _buildPriceDescription(),
                    style: TextStyle(color: widget.isPublic ? AppColors.textSecondary : AppColors.primaryEmerald, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
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
                        selectedOptionalItems: _selectedOptionalItems,
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
}
