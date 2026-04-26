// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../config/api_config.dart';
import '../theme/app_colors.dart';
import '../models/search_result.dart';
import '../services/package_service.dart';
import 'package_details_screen.dart';

class AgencySelection extends StatefulWidget {
  final String destination;
  final String dates;
  final int travelers;
  final bool isPublic;
  final List<TourPackageResult> packages;
  final PaginationInfo? pagination;

  const AgencySelection({
    super.key,
    required this.isPublic,
    required this.destination,
    required this.dates,
    this.travelers = 0,
    this.packages = const [],
    this.pagination,
  });

  @override
  State<AgencySelection> createState() => _AgencySelectionState();
}

class _AgencySelectionState extends State<AgencySelection> {
  String _activeFilter = 'Recommended';

  Color _tagColor(int index) {
    const colors = [
      AppColors.primaryOrange,
      AppColors.accentTeal,
      AppColors.accentBlue,
      AppColors.accentViolet,
      AppColors.accentRose,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
              '${widget.destination} ${widget.isPublic ? 'Public' : 'Private'} Tours',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.dates} • ${widget.travelers} travelers',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColors.primaryOrange,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + kToolbarHeight + 12,
          ),
          _buildFilterBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildBookingModeGuideCard(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.packages.length} tours found',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.destination,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.packages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.packages.length,
                    itemBuilder: (context, index) {
                      final pkg = widget.packages[index];
                      final agencyName = pkg.company.name;
                      final packageIsPublic = pkg.isPublic;
                      final price = pkg.basePrice;
                      final currency = pkg.currency.toUpperCase();
                      final durationLabel = pkg.duration > 0
                          ? '${pkg.duration.round()} day${pkg.duration.round() == 1 ? '' : 's'}'
                          : 'Flexible';
                      final rawImage = pkg.coverImage?.isNotEmpty == true
                          ? pkg.coverImage!
                          : 'https://placehold.co/600x400/png?text=Tour+Package';

                      final String coverImage =
                          (kIsWeb && rawImage.startsWith('http'))
                          ? '${ApiConfig.chatSocket}/proxy-image?url=${Uri.encodeComponent(rawImage)}'
                          : rawImage;
                      final from = pkg.fromLocation;
                      final to = pkg.toLocation;
                      final locations = '$from → $to';
                      final category = pkg.category;
                      final tags = _buildTags(pkg.includes, category);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildTourCard(
                          title: pkg.title,
                          agencyName: agencyName,
                          locations: locations,
                          price: price,
                          currency: currency,
                          rating: 4.7,
                          reviews: 12,
                          duration: durationLabel,
                          imageUrl: coverImage,
                          tags: tags,
                          isPopular: index == 0,
                          packageIsPublic: packageIsPublic,
                          packageResult: pkg,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off, color: AppColors.textSecondary, size: 48),
          SizedBox(height: 12),
          Text(
            'No tours found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Try adjusting your filters',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  List<String> _buildTags(PackageIncludes includes, String category) {
    final tags = <String>[];
    if (includes.guide != null) {
      tags.add('Guide');
    }
    if (includes.meals != null) {
      tags.add('Meals');
    }
    if (includes.permits) {
      tags.add('Permits');
    }
    if (includes.transport != null) {
      tags.add('Transport');
    }
    if (tags.isNotEmpty) return tags;
    if (category.isNotEmpty) return [category];
    return ['Activities'];
  }

  String _formatPrice(num? price, String currency) {
    if (price == null) return '--';
    if (price % 1 == 0) {
      return '$currency ${price.toStringAsFixed(0)}';
    }
    return '$currency ${price.toStringAsFixed(2)}';
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(
            'Recommended',
            isActive: _activeFilter == 'Recommended',
            hasDropdown: true,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Price: Low to High',
            isActive: _activeFilter == 'Price: Low to High',
          ),
          const SizedBox(width: 8),
          _buildFilterChip('Duration', isActive: _activeFilter == 'Duration'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    bool isActive = false,
    bool hasDropdown = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isActive ? AppColors.accent : AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTourCard({
    required String title,
    required String agencyName,
    required String locations,
    required num price,
    required String currency,
    required double rating,
    required int reviews,
    required String duration,
    required String imageUrl,
    required List<String> tags,
    required bool packageIsPublic,
    required TourPackageResult packageResult,
    bool isPopular = false,
  }) {
    final buttonText = packageIsPublic
        ? 'Check Seats & Details'
        : 'Choose Dates & Details';
    final pricingUnit = packageIsPublic ? '/ person' : '/ group';
    final priceText = _formatPrice(price, currency);
    final nextDepartureId = packageIsPublic
        ? int.tryParse(packageResult.nextDeparture?['id']?.toString() ?? '')
        : null;
    final nextDepartureDate = packageIsPublic
        ? DateTime.tryParse(
            packageResult.nextDeparture?['departureDate']?.toString() ?? '',
          )
        : null;

    return _BounceButton(
      onTap: () async {
        final currentContext = context;
        if (packageIsPublic &&
            (nextDepartureId == null || nextDepartureDate == null)) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text(
                'This public package has no active departure schedule yet. Please choose another departure.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        CustomizeItineraryModel? packageDetails;

        showDialog(
          context: currentContext,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        try {
          final packageService = PackageService();
          final response = await packageService.getPackageDetailsWithItinerary(
            packageResult.id,
          );

          if (!currentContext.mounted) return;
          Navigator.pop(currentContext); // Close loading dialog

          if (response != null && response.success) {
            packageDetails = response.data;
          } else {
            ScaffoldMessenger.of(currentContext).showSnackBar(
              const SnackBar(
                content: Text('Failed to load package details'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        } catch (e) {
          if (!currentContext.mounted) return;
          Navigator.pop(currentContext); // Close loading dialog
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final details = packageDetails;

        if (!currentContext.mounted) return;
        Navigator.push(
          currentContext,
          MaterialPageRoute(
            builder: (context) => PackageDetailsScreen(
              isPublic: packageIsPublic,
              customizeItinerary: details,
              travelers: widget.travelers,
              publicScheduleId: packageIsPublic ? nextDepartureId : null,
              fixedStartDate: packageIsPublic ? nextDepartureDate : null,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (packageIsPublic
                                      ? AppColors.textEmerald
                                      : AppColors.textOrange)
                                  .withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: packageIsPublic
                                    ? AppColors.textEmerald
                                    : AppColors.textOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              packageIsPublic
                                  ? 'PUBLIC TOUR'
                                  : 'PRIVATE REQUEST',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              agencyName,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.amber,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.take(4).toList().asMap().entries.map((
                        entry,
                      ) {
                        final color = _tagColor(
                          entry.key + (packageIsPublic ? 0 : 2),
                        );
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: color.withOpacity(0.25)),
                          ),
                          child: Text(
                            entry.value,
                            style: GoogleFonts.plusJakartaSans(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (packageIsPublic
                                  ? AppColors.accentBlue
                                  : AppColors.primaryEmerald)
                              .withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            (packageIsPublic
                                    ? AppColors.accentBlue
                                    : AppColors.primaryEmerald)
                                .withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      packageIsPublic
                          ? 'Public flow: fixed departure date, seat availability checked live.'
                          : 'Private flow: choose your own dates and tailor the itinerary.',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PACKAGE PRICE',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: priceText,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.accent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' $pricingUnit',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.premiumActionGradient,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOrange.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          buttonText,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildBookingModeGuideCard() {
    final tone = widget.isPublic
        ? AppColors.accentBlue
        : AppColors.primaryEmerald;
    final icon = widget.isPublic
        ? Icons.event_seat_outlined
        : Icons.auto_fix_high_rounded;
    final title = widget.isPublic
        ? 'Public Package Results'
        : 'Private Package Results';
    final subtitle = widget.isPublic
        ? 'These tours use fixed departure schedules. Seat availability is checked before booking.'
        : 'These tours are flexible. You will choose dates and finalize your custom trip before payment.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tone.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tone.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: tone, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
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
