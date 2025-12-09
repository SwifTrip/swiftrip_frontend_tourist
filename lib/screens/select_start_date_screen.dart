import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import 'customize_itinerary_screen.dart';

class SelectStartDateScreen extends StatefulWidget {
  final CustomizeItineraryModel package;
  final int travelers;

  const SelectStartDateScreen({super.key, required this.package, required this.travelers});

  @override
  State<SelectStartDateScreen> createState() => _SelectStartDateScreenState();
}

class _SelectStartDateScreenState extends State<SelectStartDateScreen> {
  DateTime? _selectedDate = DateTime(2024, 10, 14);
  late int _durationDays;

  // Private tour accent color (Purple as per mockup)
  static const Color _privateAccent = Color(0xFF8B5CF6);

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
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
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
                const SizedBox(height: 24),
                _buildInfoBox(),
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
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -10))
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
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatDate(_selectedDate),
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(rangeEnd),
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
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
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_durationDays Days / ${_durationDays - 1} Nights',
                      style: const TextStyle(color: _privateAccent, fontSize: 12, fontWeight: FontWeight.bold),
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
        _buildLegendItem(_privateAccent.withOpacity(0.15), 'Trip Duration', isRange: true),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool isRange = false}) {
    return Row(
      children: [
        Container(
          width: isRange ? 32 : 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(isRange ? 4 : 999)),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Flexible Start Dates',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Since this is a private tour, you can start on any date that suits you. The 7-day itinerary will automatically adjust.',
                  style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    final daysInMonth = 31;
    final firstDayOffset = 2; // Oct 1, 2024 starts on Tuesday
    final weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdays.map((day) => Text(
            day,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
          )).toList(),
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
            final date = DateTime(2024, 10, day);
            final isPast = day < 12;
            final isSelected = _selectedDate != null && date.isAtSameMomentAs(_selectedDate!);
            
            // Range logic
            bool isInRange = false;
            bool isRangeEnd = false;
            if (_selectedDate != null) {
              final rangeEnd = _selectedDate!.add(Duration(days: _durationDays - 1));
              isInRange = date.isAfter(_selectedDate!) && date.isBefore(rangeEnd);
              isRangeEnd = date.isAtSameMomentAs(rangeEnd);
            }

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
                      boxShadow: isSelected ? [
                        BoxShadow(color: _privateAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                      ] : null,
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: isPast 
                              ? AppColors.textSecondary.withOpacity(0.3)
                              : (isSelected ? Colors.white : (isInRange || isRangeEnd ? _privateAccent : AppColors.textPrimary)),
                          fontWeight: isSelected || isInRange || isRangeEnd ? FontWeight.bold : FontWeight.normal,
                          decoration: isPast ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),

                  if (isSelected)
                    Positioned(
                      top: -30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Text(
                              'Start',
                              style: TextStyle(color: Color(0xFF101922), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            Positioned(
                              bottom: -8,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Transform.rotate(
                                  angle: 0.785, // 45 degrees
                                  child: Container(width: 8, height: 8, color: Colors.white),
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
                        decoration: const BoxDecoration(color: _privateAccent, shape: BoxShape.circle),
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
              widget.package.media.isNotEmpty ? widget.package.media.first.url : 'https://via.placeholder.com/300x300.png?text=Trip',
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
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.package.duration} days',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: Colors.white24)),
                    const SizedBox(width: 8),
                    const Text(
                      'Fixed Duration',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
          onPressed: () {},
        ),
        const Spacer(),
        const Text(
          'October 2024',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
}
