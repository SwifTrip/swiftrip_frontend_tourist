import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import 'select_departure_screen.dart';
import 'select_start_date_screen.dart';

class PackageDetailsScreen extends StatefulWidget {
  final CustomizeItineraryModel customizeItinerary;
  final bool isPublic;
  final int travelers;

  const PackageDetailsScreen({
    super.key,
    required this.customizeItinerary,
    this.isPublic = true,
    required this.travelers,
  });

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  final List<bool> _isDayExpanded = [];

  @override
  void initState() {
    super.initState();
    // Initialize all days as collapsed except the first one
    for (int i = 0; i < widget.customizeItinerary.itineraries.length; i++) {
      _isDayExpanded.add(i == 0);
    }
  }

  Color get _accentColor =>
      widget.isPublic ? Color(0xFF137FEC) : Colors.purpleAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'Package Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: IconButton(
                icon: Icon(
                  widget.isPublic ? Icons.share : Icons.favorite_border,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildInfoGrid(),
                      const SizedBox(height: 32),
                      _buildOverview(),
                      const SizedBox(height: 32),
                      if (widget.isPublic) ...[
                        _buildItinerarySection(),
                        const SizedBox(height: 32),
                      ],
                      _buildIncludedSection(),
                      const SizedBox(height: 32),
                      _buildCustomizableCard(),
                      const SizedBox(height: 140), // Spacing for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildStickyBottomBar(),
        ],
      ),
    );
  }

  Widget _buildIncludedSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
              SizedBox(width: 8),
              Text(
                'What\'s Included',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._buildIncludedItems().map((text) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<String> _buildIncludedItems() {
    final inc = widget.customizeItinerary.includes;
    final items = <String>[];
    if ((inc.guide ?? '').isNotEmpty) items.add('Guide: ${inc.guide}');
    if ((inc.meals ?? '').isNotEmpty) items.add('Meals: ${inc.meals}');
    if ((inc.transport ?? '').isNotEmpty)
      items.add('Transport: ${inc.transport}');
    if (inc.permits) items.add('Permits included');
    return items.take(4).toList();
  }

  Widget _buildCustomizableCard() {
    final bgColor = widget.isPublic
        ? const Color(0xFF137FEC).withOpacity(0.05)
        : Colors.transparent;
    final borderColor = widget.isPublic
        ? const Color(0xFF137FEC).withOpacity(0.2)
        : Colors.transparent;

    return Container(
      padding: EdgeInsets.all(widget.isPublic ? 0 : 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: widget.isPublic
            ? null
            : LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.5),
                  Colors.blue.withOpacity(0.5),
                ],
              ),
        color: widget.isPublic ? bgColor : null,
        border: widget.isPublic ? Border.all(color: borderColor) : null,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isPublic ? Colors.transparent : AppColors.surface,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.isPublic ? Icons.tune : Icons.auto_fix_high,
                color: _accentColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isPublic
                        ? 'Customizable Options'
                        : 'What\'s Customizable?',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isPublic
                        ? 'Add airport transfers or single supplements.'
                        : 'Dates, activities, and hotels are all flexible.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItinerarySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Itinerary',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View Full Itinerary',
                style: TextStyle(
                  color: _accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...widget.customizeItinerary.itineraries.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildExpandableDay(index, day),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildExpandableDay(int index, DayItinerary day) {
    bool isExpanded = _isDayExpanded[index];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? _accentColor.withOpacity(0.3) : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: CircleAvatar(
              backgroundColor: isExpanded ? _accentColor : AppColors.background,
              radius: 14,
              child: Text(
                ((day.dayNumber == 0 ? index + 1 : day.dayNumber))
                    .toString()
                    .padLeft(2, '0'),
                style: TextStyle(
                  color: isExpanded ? Colors.white : AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              day.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: isExpanded ? _accentColor : AppColors.textSecondary,
              size: 20,
            ),
            onTap: () {
              setState(() {
                _isDayExpanded[index] = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (day.dayType.toLowerCase().contains('drive')
                            ? 'Drive Day'
                            : 'Activity Day'),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        _buildInfoItem(
          Icons.calendar_month,
          'DURATION',
          '${widget.customizeItinerary.duration} days',
        ),
        const SizedBox(width: 12),
        _buildInfoItem(
          Icons.group_add,
          'TOUR TYPE',
          widget.isPublic ? 'PUBLIC' : 'Private',
        ),
        const SizedBox(width: 12),
        _buildInfoItem(
          Icons.people,
          'GROUP SIZE',
          (widget.travelers).toString(),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: _accentColor, size: 22),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.isPublic
              ? 'Experience the magic of Hunza Valley in this classic expedition. From the ancient forts of Altit and Baltit to the bustling streets of Karimabad, immerse yourself in the rich culture and breathtaking landscapes.'
              : 'Indulge in an exclusive private escape to the legendary Hunza Valley. This premium itinerary is crafted for those who value privacy, comfort, and flexibility. Travel in a dedicated Luxury SUV with a personal guide.',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar() {
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.isPublic ? 'BASE PRICE' : 'STARTING FROM',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${widget.customizeItinerary.currency} ${widget.customizeItinerary.basePrice}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' / person',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 56,
                child: CommonButton(
                  text: widget.isPublic
                      ? 'Choose Departure'
                      : 'Choose Start Date',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.isPublic
                            ? SelectDepartureScreen(
                                package: widget.customizeItinerary,
                                travelers: widget.travelers,
                              )
                            : SelectStartDateScreen(
                                package: widget.customizeItinerary,
                                travelers: widget.travelers,
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

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Image.network(
          widget.customizeItinerary.media.isNotEmpty
              ? "https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
              : 'https://via.placeholder.com/1200x800.png?text=Trip',
          height: 380,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 380,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
                AppColors.background.withOpacity(0.8),
                AppColors.background,
              ],
              stops: const [0.0, 0.3, 0.8, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildBadge(),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.category,
                          color: Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.customizeItinerary.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.customizeItinerary.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white70, size: 16),
                  SizedBox(width: 4),
                  Text(
                    widget.customizeItinerary.fromLocation +
                        " to " +
                        widget.customizeItinerary.toLocation,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge() {
    final color = widget.isPublic
        ? const Color(0xFF10B981)
        : Colors.purpleAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isPublic ? Icons.circle : Icons.diamond,
            color: color,
            size: 10,
          ),
          const SizedBox(width: 6),
          Text(
            widget.isPublic ? 'PUBLIC TOUR' : 'PRIVATE TOUR',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
