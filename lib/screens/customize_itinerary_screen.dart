// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import 'review_trip_screen.dart';
import 'dart:ui';

class CustomizeItineraryScreen extends StatefulWidget {
  final CustomizeItineraryModel package;
  final bool isPublic;
  final DateTime startDate;
  final int travelers;
  final int? scheduleId;

  const CustomizeItineraryScreen({
    super.key,
    required this.package,
    required this.isPublic,
    required this.startDate,
    required this.travelers,
    this.scheduleId,
  });

  @override
  State<CustomizeItineraryScreen> createState() =>
      _CustomizeItineraryScreenState();
}

class _CustomizeItineraryScreenState extends State<CustomizeItineraryScreen> {
  int _selectedDayIndex = 0;

  final Map<int, bool> _selectedOptionalItems = {};

  Color get _accentColor => AppColors.accent;
  Color get _transportTone => AppColors.accentBlue;
  Color get _mealTone => AppColors.accentTeal;
  Color get _activityTone => AppColors.accentViolet;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final duration = (widget.package.duration is int)
        ? (widget.package.duration as int)
        : widget.package.duration.toInt();
    final dates = List.generate(
      duration,
      (index) => widget.startDate.add(Duration(days: index)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: AppColors.background.withOpacity(0.7)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Customize Itinerary',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              widget.package.title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + 110,
              bottom: 150,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTripModeCard(),
                    const SizedBox(height: 16),
                    _buildDayHeader(dates[_selectedDayIndex]),
                    const SizedBox(height: 24),
                    if (_getAccommodationItemsForDay().isNotEmpty) ...[
                      _buildSectionHeader(
                        'ACCOMMODATION',
                        isFixed: widget.isPublic,
                      ),
                      const SizedBox(height: 12),
                      _buildAccommodationSection(dates[_selectedDayIndex]),
                      const SizedBox(height: 24),
                    ],
                    if (_getTransportItemsForDay().isNotEmpty) ...[
                      _buildSectionHeader(
                        'TRANSPORT',
                        isFixed: widget.isPublic,
                      ),
                      const SizedBox(height: 12),
                      _buildTransportSection(dates[_selectedDayIndex]),
                      const SizedBox(height: 24),
                    ],
                    if (_getMealItemsForDay().isNotEmpty) ...[
                      _buildSectionHeader('MEALS', isFixed: widget.isPublic),
                      const SizedBox(height: 12),
                      _buildMealSection(dates[_selectedDayIndex]),
                      const SizedBox(height: 24),
                    ],
                    if (_getActivityItemsForDay().isNotEmpty)
                      ..._buildActivitySection(),
                  ],
                ),
              ),
            ],
          ),
          // Floating Day Selector
          Positioned(
            top: kToolbarHeight + 10,
            left: 0,
            right: 0,
            child: _buildDaySelector(dates),
          ),
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildDaySelector(List<DateTime> dates) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: AppColors.background.withOpacity(0.4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: dates.asMap().entries.map((entry) {
                final index = entry.key;
                final date = entry.value;
                final isSelected = _selectedDayIndex == index;
                final months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];

                return _BounceButton(
                  onTap: () => setState(() => _selectedDayIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _accentColor
                          : AppColors.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.border.withOpacity(0.5),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _accentColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'DAY ${index + 1}',
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : AppColors.textSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day} ${months[date.month - 1]}',
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
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
        ),
      ),
    );
  }

  Widget _buildDayHeader(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.package.itineraries[_selectedDayIndex].title,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool isFixed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        if (isFixed)
          Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: AppColors.textSecondary.withOpacity(0.5),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                'LOCKED',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary.withOpacity(0.5),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTripModeCard() {
    final Color tone = widget.isPublic
        ? AppColors.accentBlue
        : AppColors.primaryEmerald;
    final IconData icon = widget.isPublic
        ? Icons.event_seat_outlined
        : Icons.auto_fix_high_rounded;
    final String title = widget.isPublic
        ? 'Public Schedule Selected'
        : 'Private Trip Builder';
    final String description = widget.isPublic
        ? 'You are reviewing a fixed departure. Only allowed add-ons can be adjusted before booking.'
        : 'You can shape the trip before checkout. Dates and options stay flexible for your group.';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: tone.withOpacity(0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tone.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tone, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          date: widget.startDate.add(Duration(days: _selectedDayIndex)),
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
    for (final day in widget.package.itineraries) {
      for (final item in day.items) {
        if (item.optional && (_selectedOptionalItems[item.id] ?? false)) {
          total += item.price;
        }
      }
    }

    return total * widget.travelers;
  }

  String _buildPriceDescription() {
    num addOnTotal = 0;

    for (final day in widget.package.itineraries) {
      for (final item in day.items) {
        if (item.optional && (_selectedOptionalItems[item.id] ?? false)) {
          addOnTotal += item.price;
        }
      }
    }

    if (addOnTotal > 0) {
      return 'Base + ${widget.package.currency} $addOnTotal add-ons';
    } else {
      return 'Base price';
    }
  }

  List<String> _buildMetaBadges(ItineraryItem item, DateTime date) {
    final badges = <String>[];
    if (item.duration > 0) {
      badges.add('${item.duration} min');
    }
    if (item.location.isNotEmpty) {
      badges.add(item.location);
    }
    badges.add('${date.day}/${date.month}/${date.year}');
    return badges;
  }

  Widget _buildBadgeRow(List<String> badges) {
    if (badges.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: badges
          .map(
            (badge) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border.withOpacity(0.45)),
              ),
              child: Text(
                badge,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary.withOpacity(0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDetailLine(
    String label,
    String value, {
    Color? tone,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSecondary,
            fontSize: 10,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: GoogleFonts.plusJakartaSans(
                color: tone ?? AppColors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
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
            Icon(
              Icons.hotel_outlined,
              color: AppColors.textSecondary,
              size: 18,
            ),
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
          _buildAccommodationCard(item: stays[i], date: date),
          if (i < stays.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildAccommodationCard({
    required ItineraryItem item,
    required DateTime date,
  }) {
    final isCustomizable = item.optional;
    final isFixed = !item.optional;
    final isSelected =
        _selectedOptionalItems[item.id] ?? item.optional == false;

    return _BounceButton(
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
                _selectedOptionalItems[item.id] =
                    !(_selectedOptionalItems[item.id] ?? false);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withOpacity(0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryOrange
                : AppColors.border.withOpacity(0.5),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange.withOpacity(0.12)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.hotel_rounded,
                color: isSelected
                    ? AppColors.primaryOrange
                    : AppColors.textSecondary,
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
                          item.name.isNotEmpty ? item.name : 'Stay',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFixed)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'INCLUDED',
                            style: TextStyle(
                              color: AppColors.primaryEmerald,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primaryOrange,
                          size: 24,
                        )
                      else
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppColors.textSecondary.withOpacity(0.3),
                          size: 24,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description.isNotEmpty
                        ? item.description
                        : 'Accommodation for this night.',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  _buildBadgeRow(_buildMetaBadges(item, date)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      if (item.price > 0)
                        Text(
                          item.optional
                              ? '+${widget.package.currency} ${item.price}'
                              : '${widget.package.currency} ${item.price}',
                          style: GoogleFonts.plusJakartaSans(
                            color: isFixed
                                ? AppColors.textSecondary
                                : AppColors.primaryOrange,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        const Text(
                          'Included',
                          style: TextStyle(
                            color: AppColors.primaryEmerald,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
            Icon(
              Icons.directions_bus_outlined,
              color: AppColors.textSecondary,
              size: 18,
            ),
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
    final isCustomizable = item.optional;
    final isFixed = !item.optional;
    final isSelected =
        _selectedOptionalItems[item.id] ?? item.optional == false;

    return GestureDetector(
      onTap: isCustomizable
          ? () {
              setState(() {
                _selectedOptionalItems[item.id] =
                    !(_selectedOptionalItems[item.id] ?? false);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? _transportTone.withOpacity(0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? _transportTone : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? _transportTone.withOpacity(0.12)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.directions_bus_outlined,
                color: isSelected ? _transportTone : AppColors.textSecondary,
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
                          item.name.isNotEmpty ? item.name : 'Transport',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFixed)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'INCLUDED',
                            style: TextStyle(
                              color: AppColors.primaryEmerald,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: _transportTone,
                          size: 20,
                        )
                      else
                        Icon(
                          Icons.add_circle_outline,
                          color: AppColors.textSecondary.withOpacity(0.4),
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description.isNotEmpty
                        ? item.description
                        : 'Transport for this day.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  if (item.transportDetails.isNotEmpty) ...[
                    for (final detail in item.transportDetails) ...[
                      if (detail.vehicleType.isNotEmpty)
                        _buildDetailLine(
                          'Vehicle',
                          detail.vehicleType,
                          tone: _transportTone,
                        ),
                      if (detail.pickupLocation.isNotEmpty)
                        _buildDetailLine('Pickup', detail.pickupLocation),
                      if (detail.dropoffLocation.isNotEmpty)
                        _buildDetailLine('Drop-off', detail.dropoffLocation),
                    ],
                    const SizedBox(height: 10),
                  ],
                  _buildBadgeRow(_buildMetaBadges(item, date)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      if (item.price > 0)
                        Text(
                          item.optional
                              ? '+${widget.package.currency} ${item.price}'
                              : '${widget.package.currency} ${item.price}',
                          style: GoogleFonts.plusJakartaSans(
                            color: isFixed
                                ? AppColors.textSecondary
                                : _transportTone,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        const Text(
                          'Included',
                          style: TextStyle(
                            color: AppColors.primaryEmerald,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
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
            Icon(
              Icons.restaurant_menu_outlined,
              color: AppColors.textSecondary,
              size: 18,
            ),
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
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
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
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
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
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
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
    final isCustomizable = item.optional;
    final isFixed = !item.optional;
    final isSelected =
        _selectedOptionalItems[item.id] ?? item.optional == false;

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
                _selectedOptionalItems[item.id] =
                    !(_selectedOptionalItems[item.id] ?? false);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? _mealTone.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? _mealTone : AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? _mealTone.withOpacity(0.12)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.restaurant_menu_outlined,
                color: isSelected ? _mealTone : AppColors.textSecondary,
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
                          item.name.isNotEmpty ? item.name : 'Meal',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFixed)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'INCLUDED',
                            style: TextStyle(
                              color: AppColors.primaryEmerald,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (isSelected)
                        Icon(Icons.check_circle, color: _mealTone, size: 20)
                      else
                        Icon(
                          Icons.add_circle_outline,
                          color: AppColors.textSecondary.withOpacity(0.4),
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description.isNotEmpty
                        ? item.description
                        : 'Meal for this day.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  if (item.mealDetails.isNotEmpty) ...[
                    for (final detail in item.mealDetails)
                      if (detail.cuisine.isNotEmpty)
                        _buildDetailLine(
                          '${detail.mealType} Cuisine',
                          detail.cuisine,
                          tone: _mealTone,
                        ),
                    const SizedBox(height: 10),
                  ],
                  _buildBadgeRow(_buildMetaBadges(item, date)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      if (item.price > 0)
                        Text(
                          item.optional
                              ? '+${widget.package.currency} ${item.price}'
                              : '${widget.package.currency} ${item.price}',
                          style: GoogleFonts.plusJakartaSans(
                            color: isFixed
                                ? AppColors.textSecondary
                                : _mealTone,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        const Text(
                          'Included',
                          style: TextStyle(
                            color: AppColors.primaryEmerald,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
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
    required DateTime date,
  }) {
    final isIncluded = isFixed && item.optional == false;

    return GestureDetector(
      onTap: isFixed
          ? null
          : () {
              setState(() {
                _selectedOptionalItems[item.id] =
                    !(_selectedOptionalItems[item.id] ?? false);
              });
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? _activityTone.withOpacity(0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? _activityTone
                : (isFixed
                      ? AppColors.border.withOpacity(0.5)
                      : AppColors.border),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
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
                  color: isSelected
                      ? _activityTone.withOpacity(0.12)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.local_activity_outlined,
                  color: isSelected ? _activityTone : AppColors.textSecondary,
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
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isIncluded)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryEmerald.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'INCLUDED',
                              style: TextStyle(
                                color: AppColors.primaryEmerald,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isFixed) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.price > 0
                            ? '+${widget.package.currency} ${item.price}'
                            : 'Free Activity',
                        style: GoogleFonts.plusJakartaSans(
                          color: isSelected
                              ? _activityTone
                              : AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    _buildBadgeRow(_buildMetaBadges(item, date)),
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
                Icon(Icons.check_circle, color: _activityTone, size: 24)
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
    final totalPrice = _calculateTotalPrice();
    final description = widget.isPublic
        ? 'Fixed schedule • add-ons only'
        : _buildPriceDescription();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.8),
              border: Border(
                top: BorderSide(color: AppColors.border.withOpacity(0.5)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ESTIMATED TOTAL',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: totalPrice.toDouble(),
                          ),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) {
                            return Text(
                              'Rs${value.toInt()}',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: GoogleFonts.plusJakartaSans(
                            color: widget.isPublic
                                ? AppColors.textSecondary
                                : AppColors.primaryEmerald,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CommonButton(
                      text: widget.isPublic ? 'Review Seats' : 'Review Trip',
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
                              scheduleId: widget.scheduleId,
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
          ),
        ),
      ),
    );
  }
}

// Boing Physics Button
class _BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _BounceButton({required this.child, this.onTap});

  @override
  State<_BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<_BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
