import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import 'customize_itinerary_screen.dart';

class SelectStartDateScreen extends StatefulWidget {
  final CustomizeItineraryModel package;
  final int travelers;

  const SelectStartDateScreen({
    super.key,
    required this.package,
    required this.travelers,
  });

  @override
  State<SelectStartDateScreen> createState() => _SelectStartDateScreenState();
}

class _SelectStartDateScreenState extends State<SelectStartDateScreen> {
  late DateTime _selectedDate;
  late int _durationDays;
  late DateTime _currentDate;
  late DateTime _displayedMonth; // Track which month to display

  Color get _accentColor => AppColors.primaryOrange;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    // Set selected date to tomorrow
    _selectedDate = DateTime(
      _currentDate.year,
      _currentDate.month,
      _currentDate.day + 1,
    );
    // Set displayed month to current month
    _displayedMonth = DateTime(_currentDate.year, _currentDate.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    _durationDays = (widget.package.duration is int)
        ? (widget.package.duration as int)
        : widget.package.duration.toInt();
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
          'Select Start Date',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
                _buildCalendarHeader(),
                const SizedBox(height: 24),
                _buildCalendarView(),
                const SizedBox(height: 32),
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
    final rangeEnd = _selectedDate.add(Duration(days: _durationDays - 1));

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
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DATES SELECTED',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            _formatDate(_selectedDate),
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward,
                              color: AppColors.textSecondary.withOpacity(0.5),
                              size: 14,
                            ),
                          ),
                          Text(
                            _formatDate(rangeEnd),
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    '$_durationDays DAY${_durationDays == 1 ? '' : 'S'}',
                    style: const TextStyle(
                      color: AppColors.accentBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CommonButton(
              text: 'Confirm Date',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomizeItineraryScreen(
                      package: widget.package,
                      isPublic: false,
                      startDate: _selectedDate,
                      travelers: widget.travelers,
                    ),
                  ),
                );
              },
              borderRadius: 20,
            ),
          ],
        ),
      ),
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
          _buildLegendItem(_accentColor, 'Start Date'),
          const SizedBox(width: 32),
          _buildLegendItem(
            _accentColor.withOpacity(0.1),
            'Trip Duration',
            isRange: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool isRange = false}) {
    return Row(
      children: [
        Container(
          width: isRange ? 24 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(isRange ? 4 : 999),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarView() {
    final year = _displayedMonth.year;
    final month = _displayedMonth.month;

    // Get number of days in the displayed month
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Get the first day of the month and its weekday offset
    final firstDay = DateTime(year, month, 1);
    final firstDayOffset = firstDay.weekday; // 1 = Monday, 7 = Sunday
    // Adjust offset for Sunday start (0 = Sunday)
    final adjustedOffset = firstDayOffset % 7;

    final weekdays = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdays
              .map(
                (day) => Text(
                  day,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 12,
            crossAxisSpacing: 0,
          ),
          itemCount: daysInMonth + adjustedOffset,
          itemBuilder: (context, index) {
            if (index < adjustedOffset) return const SizedBox.shrink();

            final day = index - adjustedOffset + 1;
            final date = DateTime(year, month, day);

            // Only allow dates greater than today
            final today = DateTime.now();
            final todayWithoutTime = DateTime(
              today.year,
              today.month,
              today.day,
            );
            final isPast = date.isBefore(todayWithoutTime);

            final isSelected =
                date.year == _selectedDate.year &&
                date.month == _selectedDate.month &&
                date.day == _selectedDate.day;

            // Range logic
            bool isInRange = false;
            bool isRangeEnd = false;
            final rangeEnd = _selectedDate.add(
              Duration(days: _durationDays - 1),
            );
            isInRange = date.isAfter(_selectedDate) && date.isBefore(rangeEnd);
            isRangeEnd =
                date.year == rangeEnd.year &&
                date.month == rangeEnd.month &&
                date.day == rangeEnd.day;

            return GestureDetector(
              onTap: isPast ? null : () => setState(() => _selectedDate = date),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Middle range background
                  if (isInRange)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.08),
                      ),
                    ),

                  // Start date background extension
                  if (isSelected && _durationDays > 1)
                    Positioned(
                      right: 0,
                      left: 20,
                      top: 4,
                      bottom: 4,
                      child: Container(color: _accentColor.withOpacity(0.08)),
                    ),

                  // End date background extension
                  if (isRangeEnd && _durationDays > 1)
                    Positioned(
                      left: 0,
                      right: 20,
                      top: 4,
                      bottom: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.08),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(999),
                            bottomRight: Radius.circular(999),
                          ),
                        ),
                      ),
                    ),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? _accentColor
                          : (isRangeEnd
                                ? _accentColor.withOpacity(0.15)
                                : Colors.transparent),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _accentColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: isPast
                              ? AppColors.textSecondary.withOpacity(0.3)
                              : (isSelected
                                    ? Colors.white
                                    : (isInRange || isRangeEnd
                                          ? _accentColor
                                          : AppColors.textPrimary)),
                          fontSize: 14,
                          fontWeight: isSelected || isInRange || isRangeEnd
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  if (isSelected)
                    Positioned(
                      top: -4,
                      child: Container(
                        height: 4,
                        width: 4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
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
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
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
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentViolet.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'PRIVATE EXPEDITION',
                        style: TextStyle(
                          color: AppColors.accentViolet,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${widget.package.duration} DAY${widget.package.duration == 1 ? '' : 'S'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
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
    );
  }

  Widget _buildCalendarHeader() {
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
    final monthName = months[_displayedMonth.month - 1];
    final year = _displayedMonth.year;

    return Row(
      children: [
        Text(
          '$monthName $year',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: AppColors.accentBlue,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _displayedMonth = DateTime(
                      _displayedMonth.year,
                      _displayedMonth.month - 1,
                      1,
                    );
                  });
                },
              ),
              Container(width: 1, height: 20, color: AppColors.border),
              IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: AppColors.accentBlue,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _displayedMonth = DateTime(
                      _displayedMonth.year,
                      _displayedMonth.month + 1,
                      1,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
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
    return '${months[date.month - 1]} ${date.day}';
  }
}
