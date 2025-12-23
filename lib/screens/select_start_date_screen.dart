import 'package:flutter/material.dart';
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

  // Private tour accent color (Purple as per mockup)
  static const Color _privateAccent = Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    // Set selected date to tomorrow
    _selectedDate = DateTime(_currentDate.year, _currentDate.month, _currentDate.day + 1);
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
        title: const Text(
          'Select Start Date',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
                const SizedBox(height: 16),
                _buildCalendarView(),
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
    final rangeEnd = _selectedDate?.add(Duration(days: _durationDays - 1));

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
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SELECTED DATES',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatDate(_selectedDate),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppColors.textSecondary,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(rangeEnd),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'DURATION',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_durationDays Days / ${_durationDays - 1} Nights',
                      style: const TextStyle(
                        color: _privateAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: CommonButton(
                text: 'Continue',
                onPressed: () {
                  if (_selectedDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomizeItineraryScreen(
                          package: widget.package,
                          isPublic: false,
                          startDate: _selectedDate!,
                          travelers: widget.travelers,
                        ),
                      ),
                    );
                  }
                },
                backgroundColor: _privateAccent,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(_privateAccent, 'Start Date'),
        const SizedBox(width: 24),
        _buildLegendItem(
          _privateAccent.withOpacity(0.15),
          'Trip Duration',
          isRange: true,
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool isRange = false}) {
    return Row(
      children: [
        Container(
          width: isRange ? 32 : 12,
          height: 12,
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
            fontSize: 12,
            fontWeight: FontWeight.w500,
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
    final firstDayOffset = firstDay.weekday; // 0 = Sunday, 1 = Monday, etc.
    
    final weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

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
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 0,
          ),
          itemCount: daysInMonth + firstDayOffset,
          itemBuilder: (context, index) {
            if (index < firstDayOffset) return const SizedBox.shrink();

            final day = index - firstDayOffset + 1;
            final date = DateTime(year, month, day);
            
            // Only allow dates greater than today
            final today = DateTime.now();
            final todayWithoutTime = DateTime(today.year, today.month, today.day);
            final isPast = date.isBefore(todayWithoutTime) || date.isAtSameMomentAs(todayWithoutTime);
            
            final isSelected = date.year == _selectedDate.year &&
                date.month == _selectedDate.month &&
                date.day == _selectedDate.day;

            // Range logic
            bool isInRange = false;
            bool isRangeEnd = false;
            final rangeEnd = _selectedDate.add(
              Duration(days: _durationDays - 1),
            );
            isInRange = date.isAfter(_selectedDate) && date.isBefore(rangeEnd);
            isRangeEnd = date.year == rangeEnd.year &&
                date.month == rangeEnd.month &&
                date.day == rangeEnd.day;

            return GestureDetector(
              onTap: isPast ? null : () => setState(() => _selectedDate = date),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Middle range background
                  if (isInRange)
                    Container(
                      decoration: BoxDecoration(
                        color: _privateAccent.withOpacity(0.15),
                      ),
                    ),

                  // Start date background extention
                  if (isSelected)
                    Positioned(
                      right: 0,
                      left: 20,
                      top: 0,
                      bottom: 0,
                      child: Container(color: _privateAccent.withOpacity(0.15)),
                    ),

                  // End date background extension
                  if (isRangeEnd)
                    Positioned(
                      left: 0,
                      right: 20,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _privateAccent.withOpacity(0.15),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(999),
                            bottomRight: Radius.circular(999),
                          ),
                        ),
                      ),
                    ),

                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? _privateAccent : Colors.transparent,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _privateAccent.withOpacity(0.3),
                                blurRadius: 10,
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
                                          ? _privateAccent
                                          : AppColors.textPrimary)),
                          fontWeight: isSelected || isInRange || isRangeEnd
                              ? FontWeight.bold
                              : FontWeight.normal,
                          decoration: isPast
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ),

                  if (isSelected)
                    Positioned(
                      top: -30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Text(
                              'Start',
                              style: TextStyle(
                                color: Color(0xFF101922),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Positioned(
                              bottom: -8,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Transform.rotate(
                                  angle: 0.785, // 45 degrees
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (isRangeEnd)
                    Positioned(
                      bottom: 4,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: _privateAccent,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.package.media.isNotEmpty
                  ? "https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                  : 'https://via.placeholder.com/300x300.png?text=Trip',
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
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppColors.textSecondary,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.package.duration} days',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: Colors.white24)),
                    const SizedBox(width: 8),
                    const Text(
                      'Fixed Duration',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
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
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final monthName = months[_displayedMonth.month - 1];
    final year = _displayedMonth.year;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
          onPressed: () {
            setState(() {
              _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
            });
          },
        ),
        const Spacer(),
        Text(
          '$monthName $year',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
          onPressed: () {
            setState(() {
              _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
            });
          },
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
