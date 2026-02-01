import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import '../services/custom_tour_service.dart';
import 'home_screen.dart';
import 'payment_screen.dart';

class ReviewTripScreen extends StatefulWidget {
  final CustomizeItineraryModel package;
  final bool isPublic;
  final DateTime startDate;
  final Map<int, bool> selectedOptionalItems;
  final int travelers;

  const ReviewTripScreen({
    super.key,
    required this.package,
    required this.isPublic,
    required this.startDate,
    required this.selectedOptionalItems,
    required this.travelers,
  });

  @override
  State<ReviewTripScreen> createState() => _ReviewTripScreenState();
}

class _ReviewTripScreenState extends State<ReviewTripScreen> {
  bool _allExpanded = true;
  bool _isSubmitting = false;
  bool _isBooking = false;
  final CustomTourService _customTourService = CustomTourService();

  Color get _accentColor => AppColors.primaryOrange;

  @override
  void initState() {
    super.initState();
  }

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
          'Review Trip',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTripSummaryCard(),
                const SizedBox(height: 32),
                _buildItineraryHeader(),
                const SizedBox(height: 16),
                _buildItinerarySummary(),
                const SizedBox(height: 32),
                _buildPriceBreakdown(),
                const SizedBox(height: 24),
                const Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'By proceeding, you agree to our '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Cancellation Policy',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 150), // Spacing for footer
              ],
            ),
          ),
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildStickyFooter() {
    final bool busy = _isSubmitting || _isBooking;
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
        child: Row(
          children: [
            // ── Save Trip (secondary) ──
            Expanded(
              child: OutlinedButton(
                onPressed: busy ? null : _saveCustomTour,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: busy
                        ? AppColors.border.withOpacity(0.3)
                        : AppColors.primaryOrange,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryOrange,
                        ),
                      )
                    : Text(
                        'Save Trip',
                        style: GoogleFonts.plusJakartaSans(
                          color: busy
                              ? AppColors.textSecondary
                              : AppColors.primaryOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // ── Book Now (primary) ──
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: busy ? null : _saveAndBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  disabledBackgroundColor:
                      AppColors.primaryOrange.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: _isBooking
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.confirmation_number_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Book Now',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    num accommodationTotal = 0;
    num transportTotal = 0;
    num mealTotal = 0;
    num activityTotal = 0;

    for (final day in widget.package.itineraries) {
      for (final item in day.items) {
        if (item.optional && (widget.selectedOptionalItems[item.id] ?? false)) {
          if (item.type.toLowerCase() == 'stay') {
            accommodationTotal += item.price;
          } else if (item.type.toLowerCase() == 'transport') {
            transportTotal += item.price;
          } else if (item.type.toLowerCase() == 'meal') {
            mealTotal += item.price;
          } else if (item.type.toLowerCase() == 'activity') {
            activityTotal += item.price;
          }
        }
      }
    }

    num totalAddOns = accommodationTotal + transportTotal + mealTotal + activityTotal;
    num finalTotal = (widget.package.basePrice + totalAddOns) * widget.travelers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Breakdown',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            children: [
              _buildPriceRow(
                'Base Tour Price',
                '${widget.package.currency} ${widget.package.basePrice}',
              ),
              if (totalAddOns > 0) ...[
                const SizedBox(height: 12),
                _buildPriceRow(
                  'Custom Selection Add-ons',
                  '+${widget.package.currency} $totalAddOns',
                  accent: true,
                ),
              ],
              const SizedBox(height: 12),
              _buildPriceRow("Group Size", '${widget.travelers} Guests'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: AppColors.border, height: 1),
              ),
              _buildPriceRow(
                'Total Investment',
                '${widget.package.currency} $finalTotal',
                isTotal: true,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.verified, color: AppColors.primaryEmerald, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Inclusive of all service taxes',
                    style: GoogleFonts.plusJakartaSans(
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
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false, bool accent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: accent ? AppColors.primaryOrange : AppColors.textPrimary,
            fontSize: isTotal ? 22 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildItineraryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Itinerary',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Full ${widget.package.itineraries.length}-Day Expedition Summary',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () => setState(() => _allExpanded = !_allExpanded),
          child: Text(
            _allExpanded ? 'Collapse All' : 'Expand All',
            style: GoogleFonts.plusJakartaSans(
              color: _accentColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItinerarySummary() {
    return ListView.builder(
      key: ValueKey(_allExpanded),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.package.itineraries.length,
      itemBuilder: (context, index) {
        final day = widget.package.itineraries[index];
        final date = widget.startDate.add(Duration(days: index));
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

        // Filter items: show only fixed items OR optional items that are selected
        final accommodations = day.items
            .where(
              (item) =>
                  item.type.toLowerCase() == 'stay' &&
                  (!item.optional ||
                      (widget.selectedOptionalItems[item.id] ?? false)),
            )
            .toList();
        final transports = day.items
            .where(
              (item) =>
                  item.type.toLowerCase() == 'transport' &&
                  (!item.optional ||
                      (widget.selectedOptionalItems[item.id] ?? false)),
            )
            .toList();
        final meals = day.items
            .where(
              (item) =>
                  item.type.toLowerCase() == 'meal' &&
                  (!item.optional ||
                      (widget.selectedOptionalItems[item.id] ?? false)),
            )
            .toList();
        final activities = day.items
            .where(
              (item) =>
                  item.type.toLowerCase() == 'activity' &&
                  (!item.optional ||
                      (widget.selectedOptionalItems[item.id] ?? false)),
            )
            .toList();

        // Only show day if it has at least one item
        final hasItems =
            accommodations.isNotEmpty ||
            transports.isNotEmpty ||
            meals.isNotEmpty ||
            activities.isNotEmpty;

        if (!hasItems) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: _allExpanded,
              iconColor: _accentColor,
              collapsedIconColor: AppColors.textSecondary,
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${date.day}\n${months[date.month - 1]}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: _accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Day ${index + 1}: ${day.title}',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(68, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Accommodations
                      if (accommodations.isNotEmpty) ...[
                        const Text(
                          'ACCOMMODATION',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final item in accommodations)
                          _buildReviewItem(
                            Icons.hotel_outlined,
                            item.name,
                            item.optional,
                            price: item.price,
                            currency: widget.package.currency,
                          ),
                        const SizedBox(height: 12),
                      ],
                      // Transport
                      if (transports.isNotEmpty) ...[
                        const Text(
                          'TRANSPORT',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final item in transports)
                          _buildReviewItem(
                            Icons.directions_bus_outlined,
                            item.name,
                            item.optional,
                            price: item.price,
                            currency: widget.package.currency,
                          ),
                        const SizedBox(height: 12),
                      ],
                      // Meals - grouped by meal type
                      if (meals.isNotEmpty) ...[
                        ..._buildMealsGroupedSection(meals),
                        const SizedBox(height: 12),
                      ],
                      // Activities
                      if (activities.isNotEmpty) ...[
                        const Text(
                          'ACTIVITIES',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final item in activities)
                          _buildReviewItem(
                            Icons.local_activity_outlined,
                            item.name,
                            item.optional,
                            price: item.price,
                            currency: widget.package.currency,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildMealsGroupedSection(List<ItineraryItem> meals) {
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

    final widgets = <Widget>[];

    if (breakfastMeals.isNotEmpty) {
      widgets.add(
        const Text(
          'BREAKFAST',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      );
      widgets.add(const SizedBox(height: 8));
      for (final item in breakfastMeals) {
        widgets.add(
          _buildReviewItem(
            Icons.restaurant_menu_outlined,
            item.name,
            item.optional,
            price: item.price,
            currency: widget.package.currency,
          ),
        );
      }
      widgets.add(const SizedBox(height: 12));
    }

    if (lunchMeals.isNotEmpty) {
      widgets.add(
        const Text(
          'LUNCH',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      );
      widgets.add(const SizedBox(height: 8));
      for (final item in lunchMeals) {
        widgets.add(
          _buildReviewItem(
            Icons.restaurant_menu_outlined,
            item.name,
            item.optional,
            price: item.price,
            currency: widget.package.currency,
          ),
        );
      }
      widgets.add(const SizedBox(height: 12));
    }

    if (dinnerMeals.isNotEmpty) {
      widgets.add(
        const Text(
          'DINNER',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      );
      widgets.add(const SizedBox(height: 8));
      for (final item in dinnerMeals) {
        widgets.add(
          _buildReviewItem(
            Icons.restaurant_menu_outlined,
            item.name,
            item.optional,
            price: item.price,
            currency: widget.package.currency,
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildReviewItem(IconData icon, String text, bool isOptional, {num price = 0, String currency = 'Rs'}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isOptional && price > 0)
                  Text(
                    '+$currency $price',
                    style: GoogleFonts.plusJakartaSans(
                      color: _accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (isOptional) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'ADDED',
                      style: TextStyle(
                        color: AppColors.primaryEmerald,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    final endDate = widget.startDate.add(
      Duration(
        days:
            ((widget.package.duration is int)
                ? (widget.package.duration as int)
                : widget.package.duration.toInt()) -
            1,
      ),
    );
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.isPublic ? 'PUBLIC TOUR' : 'PRIVATE EXPERIENCE',
                              style: GoogleFonts.plusJakartaSans(
                                color: _accentColor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.package.title,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.package.media.isNotEmpty
                                ? widget.package.media.first.url
                                : 'https://via.placeholder.com/100x100.png?text=Trip',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(color: AppColors.border.withOpacity(0.3), height: 1),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.calendar_month_outlined,
                        'DATES',
                        '${months[widget.startDate.month - 1]} ${widget.startDate.day} - ${months[endDate.month - 1]} ${endDate.day}',
                        _accentColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.group_outlined,
                        'TRAVELERS',
                        '${widget.travelers} Guests',
                        AppColors.primaryEmerald,
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

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Shared: builds the itineraries payload ──────────────────────────────
  List<Map<String, dynamic>> _buildItineraries() {
    return widget.package.itineraries.map((day) {
      final selectedItems = day.items.map((item) {
        final included =
            !item.optional || (widget.selectedOptionalItems[item.id] ?? false);
        return {'itemId': item.id, 'included': included};
      }).toList();
      return {'dayNumber': day.dayNumber, 'selectedItems': selectedItems};
    }).toList();
  }

  // ── Shared: calls backend to create the custom tour, returns its ID ─────
  Future<int?> _createCustomTourAndGetId() async {
    final durationDays =
        ((widget.package.duration is int)
            ? (widget.package.duration as int)
            : widget.package.duration.toInt()) -
        1;
    final endDate = widget.startDate.add(Duration(days: durationDays));

    final result = await _customTourService.createCustomTour(
      basePackageId: widget.package.id,
      startDate: widget.startDate,
      endDate: endDate,
      travelerCount: widget.travelers,
      itineraries: _buildItineraries(),
    );

    if (result == null || result['success'] != true) {
      throw Exception(result?['message'] ?? 'Failed to save custom tour');
    }

    // Extract ID from response
    // customTourService wraps response: { success, data: <raw response body> }
    // Raw backend response: { success, message, data: { id, ... } }
    final dynamic wrapper = result['data'];
    if (wrapper is Map<String, dynamic>) {
      final dynamic inner = wrapper['data'];
      if (inner is Map<String, dynamic> && inner['id'] != null) {
        return inner['id'] as int;
      }
      if (wrapper['id'] != null) return wrapper['id'] as int;
    }
    return null;
  }

  // ── Save Trip ────────────────────────────────────────────────────────────
  Future<void> _saveCustomTour() async {
    setState(() => _isSubmitting = true);
    try {
      await _createCustomTourAndGetId();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip saved successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── Book Now (save first, then navigate to payment) ─────────────────────
  Future<void> _saveAndBook() async {
    setState(() => _isBooking = true);
    try {
      // Step 1: Save the custom tour to get its ID
      final tourId = await _createCustomTourAndGetId();

      if (!mounted) return;

      if (tourId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Trip saved but could not retrieve tour ID. Please book from your trips.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
        return;
      }

      // Step 2: Compute total price for Stripe
      num totalAddOns = 0;
      for (final day in widget.package.itineraries) {
        for (final item in day.items) {
          if (item.optional &&
              (widget.selectedOptionalItems[item.id] ?? false)) {
            totalAddOns += item.price;
          }
        }
      }
      final num totalAmount =
          (widget.package.basePrice + totalAddOns) * widget.travelers;

      // Step 3: Navigate to Stripe payment screen
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StripePaymentScreen(
            customTourId: tourId,
            travelers: widget.travelers,
            totalAmount: totalAmount,
            currency: 'usd', // Stripe sandbox uses USD for test cards
            tripTitle: widget.package.title,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }
}
