import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../models/custom_tour_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import '../services/custom_tour_service.dart';

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
  late final Color _accentColor;
  bool _allExpanded = true;
  bool _isSubmitting = false;
  final CustomTourService _customTourService = CustomTourService();

  @override
  void initState() {
    super.initState();
    _accentColor = widget.isPublic ? const Color(0xFF137FEC) : const Color(0xFF8B5CF6);
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
        title: Column(
          children: const [
            Text(
              'Review Trip',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Step 3 of 4',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
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
                        TextSpan(text: 'Terms of Service', style: TextStyle(decoration: TextDecoration.underline)),
                        TextSpan(text: ' and '),
                        TextSpan(text: 'Cancellation Policy', style: TextStyle(decoration: TextDecoration.underline)),
                        TextSpan(text: '.'),
                      ],
                    ),
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 120), // Spacing for footer
              ],
            ),
          ),
          _buildStickyFooter(),
        ],
      ),
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
        child: CommonButton(
          text: _isSubmitting ? 'Saving...' : 'Click to save',
          onPressed: _isSubmitting ? null : _saveCustomTour,
          isEnabled: !_isSubmitting,
          backgroundColor: _accentColor,
          textColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    // Calculate breakdowns
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
    num finalTotal = widget.package.basePrice + totalAddOns;
    finalTotal*=widget.travelers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Breakdown',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildPriceRow('Base Tour Price', '${widget.package.currency} ${widget.package.basePrice}'),
              if (accommodationTotal > 0) ...[
                const SizedBox(height: 12),
                _buildPriceRow('Accommodation Add-ons', '+${widget.package.currency} $accommodationTotal'),
              ],
              if (transportTotal > 0) ...[
                const SizedBox(height: 12),
                _buildPriceRow('Transport Add-ons', '+${widget.package.currency} $transportTotal'),
              ],
              if (mealTotal > 0) ...[
                const SizedBox(height: 12),
                _buildPriceRow('Meal Add-ons', '+${widget.package.currency} $mealTotal'),
              ],
              if (activityTotal > 0) ...[
                const SizedBox(height: 12),
                _buildPriceRow('Activities & Extras', '+${widget.package.currency} $activityTotal'),
              ],
              const SizedBox(height: 12),
              _buildPriceRow("Group Size", '${widget.travelers}'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.border, height: 1),
              ),
              _buildPriceRow('Total Amount', '${widget.package.currency} $finalTotal', isTotal: true),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Including all taxes and fees',
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.textPrimary : AppColors.textPrimary,
            fontSize: isTotal ? 20 : 13,
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
            const Text(
              'Trip Itinerary',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.package.itineraries.length} Days Summary',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        TextButton(
          onPressed: () => setState(() => _allExpanded = !_allExpanded),
          child: Text(
            _allExpanded ? 'Collapse All' : 'Expand All',
            style: TextStyle(color: _accentColor, fontSize: 12, fontWeight: FontWeight.bold),
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
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

        // Filter items: show only fixed items OR optional items that are selected
        final accommodations = day.items
            .where((item) =>
                item.type.toLowerCase() == 'stay' &&
                (!item.optional || (widget.selectedOptionalItems[item.id] ?? false)))
            .toList();
        final transports = day.items
            .where((item) =>
                item.type.toLowerCase() == 'transport' &&
                (!item.optional || (widget.selectedOptionalItems[item.id] ?? false)))
            .toList();
        final meals = day.items
            .where((item) =>
                item.type.toLowerCase() == 'meal' &&
                (!item.optional || (widget.selectedOptionalItems[item.id] ?? false)))
            .toList();
        final activities = day.items
            .where((item) =>
                item.type.toLowerCase() == 'activity' &&
                (!item.optional || (widget.selectedOptionalItems[item.id] ?? false)))
            .toList();

        // Only show day if it has at least one item
        final hasItems = accommodations.isNotEmpty ||
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: _allExpanded,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${date.day}\n${months[date.month - 1]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _accentColor, fontSize: 10, fontWeight: FontWeight.bold, height: 1.1),
                  ),
                ),
              ),
              title: Text(
                'Day ${index + 1}: ${day.title}',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
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
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        for (final item in accommodations)
                          _buildReviewItem(Icons.hotel_outlined, item.name, item.optional),
                        const SizedBox(height: 12),
                      ],
                      // Transport
                      if (transports.isNotEmpty) ...[
                        const Text(
                          'TRANSPORT',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        for (final item in transports)
                          _buildReviewItem(Icons.directions_bus_outlined, item.name, item.optional),
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
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        for (final item in activities)
                          _buildReviewItem(Icons.local_activity_outlined, item.name, item.optional),
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
      widgets.add(const Text(
        'BREAKFAST',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
      ));
      widgets.add(const SizedBox(height: 8));
      for (final item in breakfastMeals) {
        widgets.add(_buildReviewItem(Icons.restaurant_menu_outlined, item.name, item.optional));
      }
      widgets.add(const SizedBox(height: 12));
    }

    if (lunchMeals.isNotEmpty) {
      widgets.add(const Text(
        'LUNCH',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
      ));
      widgets.add(const SizedBox(height: 8));
      for (final item in lunchMeals) {
        widgets.add(_buildReviewItem(Icons.restaurant_menu_outlined, item.name, item.optional));
      }
      widgets.add(const SizedBox(height: 12));
    }

    if (dinnerMeals.isNotEmpty) {
      widgets.add(const Text(
        'DINNER',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
      ));
      widgets.add(const SizedBox(height: 8));
      for (final item in dinnerMeals) {
        widgets.add(_buildReviewItem(Icons.restaurant_menu_outlined, item.name, item.optional));
      }
    }

    return widgets;
  }

  Widget _buildReviewItem(IconData icon, String text, bool isOptional) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
                if (isOptional)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ADDED',
                      style: TextStyle(color: Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    final endDate = widget.startDate.add(Duration(days: ((widget.package.duration is int) ? (widget.package.duration as int) : widget.package.duration.toInt()) - 1));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.isPublic ? 'PUBLIC TOUR' : 'PRIVATE TOUR',
                              style: TextStyle(
                                color: _accentColor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.package.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                          image: DecorationImage(
                          image: NetworkImage(widget.package.media.isNotEmpty ? widget.package.media.first.url : 'https://via.placeholder.com/100x100.png?text=Trip'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: AppColors.border.withOpacity(0.5), height: 1),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.calendar_month_outlined,
                        'DATES',
                        '${months[widget.startDate.month - 1]} ${widget.startDate.day} - ${months[endDate.month - 1]} ${endDate.day}',
                        const Color(0xFF3B82F6),
                      ),
                    ),
                    Container(width: 1, height: 32, color: AppColors.border),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.group_outlined,
                        'TRAVELERS',
                         '${widget.travelers} Persons',
                        const Color(0xFFF97316),
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

  Widget _buildInfoItem(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 9, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _saveCustomTour() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Calculate end date based on package duration
      final durationDays = ((widget.package.duration is int)
              ? (widget.package.duration as int)
              : widget.package.duration.toInt()) -
          1;
      final endDate = widget.startDate.add(Duration(days: durationDays));

      // Build itineraries list
      final itineraries = widget.package.itineraries.map((day) {
        // Include ALL items (both optional and required) with their inclusion status
        final selectedItems = day.items.map((item) {
          // If item is optional, check if user selected it
          // If item is required (not optional), it's always included
          final included = !item.optional || (widget.selectedOptionalItems[item.id] ?? false);
          
          return {
            'itemId': item.id,
            'included': included,
          };
        }).toList();

        return {
          'dayNumber': day.id,
          'selectedItems': selectedItems,
        };
      }).toList();

      // Build the request body to show in snackbar
      final requestBody = {
        'basePackageId': widget.package.id,
        'startDate': widget.startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'travelerCount': widget.travelers,
        'itineraries': itineraries,
      };

      // Show the JSON body in snackbar
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SingleChildScrollView(
            child: Text(
              'Request Body:\n${jsonEncode(requestBody)}',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          backgroundColor: Colors.blueGrey[800],
          duration: const Duration(seconds: 10),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Wait a moment so user can see the snackbar
      await Future.delayed(const Duration(milliseconds: 500));

      // Call the API
      final result = await _customTourService.createCustomTour(
        basePackageId: widget.package.id,
        startDate: widget.startDate,
        endDate: endDate,
        travelerCount: widget.travelers,
        itineraries: itineraries,
      );

      if (!mounted) return;

      if (result != null && result['success'] == true) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Custom tour saved successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to next screen or back
        // You can navigate to payment screen or booking confirmation here
        // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(...)));
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['message'] ?? 'Failed to save custom tour'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  ItinerarySelectionRequest _buildSelectionRequest() {
    final durationDays = ((widget.package.duration is int)
            ? (widget.package.duration as int)
            : widget.package.duration.toInt()) -
        1;
    final endDate = widget.startDate.add(Duration(days: durationDays));

    final itinerarySelections = widget.package.itineraries.map((day) {
      // Only include optional items in selectedItems
      final items = day.items
          .where((item) => item.optional)
          .map((item) {
            final included = widget.selectedOptionalItems[item.id] ?? false;
            return SelectedItemSelection(itemId: item.id, included: included);
          })
          .toList();

      // Use itinerary id (day.id) as dayNumber
      return ItineraryDaySelection(dayNumber: day.id, selectedItems: items);
    }).toList();

    return ItinerarySelectionRequest(
      basePackageId: widget.package.id,
      startDate: widget.startDate,
      endDate: endDate,
      travelerCount: widget.travelers,
      itineraries: itinerarySelections,
    );
  }
}
