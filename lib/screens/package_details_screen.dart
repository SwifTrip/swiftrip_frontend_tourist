// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_trip_app/models/package_model.dart';
import '../theme/app_colors.dart';
import '../config/api_config.dart';
import '../widgets/common_button.dart';
import 'customize_itinerary_screen.dart';
import 'select_start_date_screen.dart';

class PackageDetailsScreen extends StatefulWidget {
  final CustomizeItineraryModel customizeItinerary;
  final bool isPublic;
  final int travelers;
  final DateTime? fixedStartDate;
  final int? publicScheduleId;

  const PackageDetailsScreen({
    super.key,
    required this.customizeItinerary,
    this.isPublic = true,
    required this.travelers,
    this.fixedStartDate,
    this.publicScheduleId,
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
          style: GoogleFonts.plusJakartaSans(
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
                      const SizedBox(height: 16),
                      _buildFlowSummaryCard(),
                      const SizedBox(height: 32),
                      _buildOverview(),
                      const SizedBox(height: 32),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryEmerald,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'What\'s Included',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._buildIncludedItems().map((text) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryEmerald,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
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
    if ((inc.guide ?? '').isNotEmpty) {
      items.add('Professional local guide: ${inc.guide}');
    }
    if ((inc.meals ?? '').isNotEmpty) {
      items.add('Meal plan: ${inc.meals}');
    }
    if ((inc.transport ?? '').isNotEmpty) {
      items.add('Vehicle: ${inc.transport}');
    }
    if (inc.permits) {
      items.add('All necessary permits and entrance fees');
    }
    return items.take(4).toList();
  }

  Widget _buildCustomizableCard() {
    final accentBg = AppColors.primaryOrange.withOpacity(0.08);
    final accentBorder = AppColors.primaryOrange.withOpacity(0.15);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accentBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              widget.isPublic ? Icons.tune : Icons.auto_fix_high,
              color: AppColors.primaryOrange,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isPublic
                      ? 'Customizable Options'
                      : 'What\'s Customizable?',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.isPublic
                      ? 'Add airport transfers or single supplements to your plan.'
                      : 'Every detail from dates to luxury hotel choices is flexible.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
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
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildInfoItem(
              Icons.calendar_month,
              'Duration',
              '${widget.customizeItinerary.duration} Day${widget.customizeItinerary.duration == 1 ? '' : 's'}',
              AppColors.primaryOrange,
            ),
            const VerticalDivider(
              width: 1,
              indent: 12,
              endIndent: 12,
              color: AppColors.border,
            ),
            _buildInfoItem(
              Icons.group,
              'Travelers',
              '${widget.travelers} Guest${widget.travelers == 1 ? '' : 's'}',
              AppColors.accentBlue,
            ),
            const VerticalDivider(
              width: 1,
              indent: 12,
              endIndent: 12,
              color: AppColors.border,
            ),
            _buildInfoItem(
              Icons.verified_user,
              'Type',
              widget.isPublic ? 'Public' : 'Private',
              AppColors.accentTeal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color tone) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(icon, color: tone, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
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
        Text(
          'Overview',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.isPublic
              ? 'Uncover the hidden wonders of the Hunza Valley. This expedition takes you through ancient Silk Road passages, emerald lakes, and towering peaks, offering an immersion into the legacy of the north.'
              : 'Our Private Expedition offers a bespoke journey tailored strictly for you. Includes a dedicated luxury 4x4, hand-picked boutique stays, and a personal host to ensure your experience in Hunza is truly unmatched.',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar() {
    final String buttonText = widget.isPublic
        ? 'Check Seats & Review'
        : 'Choose Dates & Review';

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'TOTAL PRICE',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${widget.customizeItinerary.currency} ${widget.customizeItinerary.basePrice}',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.isPublic ? ' / seat' : ' / guest',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CommonButton(
                text: buttonText,
                onPressed: () {
                  if (widget.isPublic && widget.fixedStartDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No fixed departure date found for this tour.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.isPublic
                          ? CustomizeItineraryScreen(
                              package: widget.customizeItinerary,
                              isPublic: true,
                              startDate: widget.fixedStartDate!,
                              travelers: widget.travelers,
                              scheduleId: widget.publicScheduleId,
                            )
                          : SelectStartDateScreen(
                              package: widget.customizeItinerary,
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

  String _resolveImageUrl(String? rawUrl) {
    const fallback = 'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=1200';
    if (rawUrl == null || rawUrl.trim().isEmpty) return fallback;

    String url = rawUrl.trim();

    // Convert relative paths to absolute URLs
    if (url.startsWith('/uploads')) {
      url = '${ApiConfig.chatSocket}$url';
    } else if (url.startsWith('uploads/')) {
      url = '${ApiConfig.chatSocket}/$url';
    } else if (!url.startsWith('http')) {
      url = '${ApiConfig.chatSocket}/${url.replaceFirst(RegExp(r'^/+'), '')}';
    }

    // For web, use proxy to handle CORS
    if (kIsWeb && url.startsWith('http')) {
      return '${ApiConfig.chatSocket}/proxy-image?url=${Uri.encodeComponent(url)}';
    }

    return url;
  }

  String _getPackageImageUrl() {
    const fallbackUrl =
        'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=1200';

    // Check if media list has items
    if (widget.customizeItinerary.media.isEmpty) {
      return fallbackUrl;
    }

    // Get first media item with type 'image', or just the first one
    final Media? imageMedia = widget.customizeItinerary.media.firstWhere(
      (media) => media.type.toLowerCase() == 'image',
      orElse: () => widget.customizeItinerary.media.first,
    );

    // Return resolved media URL if available, otherwise fallback
    final String rawUrl = imageMedia?.url ?? '';
    return rawUrl.isNotEmpty ? _resolveImageUrl(rawUrl) : fallbackUrl;
  }

  Widget _buildHeroSection() {
    final imageUrl = _getPackageImageUrl();
    return Stack(
      children: [
        Hero(
          tag: 'package_${widget.customizeItinerary.id}',
          child: Image.network(
            imageUrl,
            height: 420,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 420,
              color: AppColors.surface,
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 50,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 420,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                AppColors.background.withOpacity(0.8),
                AppColors.background,
              ],
              stops: const [0.0, 0.4, 0.9, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildBadge(),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      widget.customizeItinerary.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.customizeItinerary.title,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.accentBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.customizeItinerary.fromLocation} to ${widget.customizeItinerary.toLocation}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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

  Widget _buildBadge() {
    final color = widget.isPublic
        ? AppColors.accentTeal
        : AppColors.accentViolet;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isPublic ? Icons.public : Icons.workspace_premium,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            widget.isPublic ? 'PUBLIC TOUR' : 'PRIVATE EXPERIENCE',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowSummaryCard() {
    final Color tone = widget.isPublic
        ? AppColors.accentBlue
        : AppColors.primaryEmerald;
    final IconData icon = widget.isPublic
        ? Icons.event_available_outlined
        : Icons.auto_fix_high_rounded;
    final String title = widget.isPublic
        ? 'Public Schedule Booking'
        : 'Private Custom Trip';
    final List<String> points = widget.isPublic
        ? [
            'Your departure date is fixed by the selected schedule',
            'Seat availability is checked live before booking',
            'Optional add-ons can be adjusted before payment',
          ]
        : [
            'Pick a start date in the next step',
            'The trip stays flexible for your group',
            'Review itinerary and price before checkout',
          ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: tone.withOpacity(0.06),
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
                ...points.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: tone,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            point,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
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
