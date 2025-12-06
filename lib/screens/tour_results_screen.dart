import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import '../models/tour_package.dart';
import '../models/search_result.dart';
import 'package_details_screen.dart';

class TourResultsScreen extends StatelessWidget {
  final String destination;
  final String dates;
  final int guests;
  final bool isPublic;
  final List<TourPackageResult> packages;
  final PaginationInfo? pagination;

  const TourResultsScreen({
    super.key,
    required this.isPublic,
    this.destination = 'Hunza',
    this.dates = 'Sep 15 - Sep 19',
    this.guests = 2,
    this.packages = const [],
    this.pagination,
  });

  @override
  Widget build(BuildContext context) {
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
              '$destination ${isPublic ? 'Public' : 'Private'} Tours',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$dates • $guests Guests',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildFilterBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${packages.length} tours found',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  destination,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: packages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      final pkg = packages[index];
                      final agencyName = pkg.company.name;
                      final packageIsPublic = pkg.isPublic;
                      final price = pkg.basePrice;
                      final currency = pkg.currency.toUpperCase();
                      final durationLabel = pkg.duration > 0
                          ? '${pkg.duration.round()} day${pkg.duration.round() == 1 ? '' : 's'}'
                          : 'Flexible';
                      final coverImage = pkg.coverImage?.isNotEmpty == true
                          ? pkg.coverImage!
                          : 'https://via.placeholder.com/600x400.png?text=Tour+Package';
                      final from = pkg.fromLocation;
                      final to = pkg.toLocation;
                      final locations = '$from → $to';
                      final category = pkg.category;
                      final tags = _buildTags(pkg.includes, category);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildTourCard(
                          context: context,
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
          _buildFilterChip('Recommended', isActive: true, hasDropdown: true),
          const SizedBox(width: 8),
          _buildFilterChip('Price: Low to High'),
          const SizedBox(width: 8),
          _buildFilterChip('Duration'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    bool isActive = false,
    bool hasDropdown = false,
  }) {
    return Container(
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
    );
  }

  Widget _buildTourCard({
    required BuildContext context,
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
    final buttonText = packageIsPublic ? 'View Details' : 'Choose Start Date';
    final pricingUnit = packageIsPublic ? '/ person' : '/ group';
    final priceText = _formatPrice(price, currency);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  height: 200,
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
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              // Availability Badge
              Positioned(
                top: 12,
                left: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: packageIsPublic
                            ? AppColors.background.withOpacity(0.6)
                            : Colors.purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: packageIsPublic
                                  ? Colors.green
                                  : Colors.purpleAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            packageIsPublic
                                ? 'PUBLIC AVAILABLE'
                                : 'PRIVATE AVAILABLE',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Duration Badge
              Positioned(
                bottom: 12,
                left: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
            padding: const EdgeInsets.all(16),
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
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.store,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  agencyName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: AppColors.textSecondary,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                locations,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '($reviews reviews)',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: packageIsPublic
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: packageIsPublic
                                  ? Colors.blue
                                  : Colors.purpleAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PACKAGE PRICE',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  priceText,
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' $pricingUnit',
                                  style: const TextStyle(
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
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: CommonButton(
                        text: buttonText,
                        fontSize: 13,
                        height: 40,
                        onPressed: () {
                          final package = TourPackage(
                            title: title,
                            price: priceText,
                            duration: duration,
                            rating: rating.toString(),
                            reviewsCount: reviews,
                            imageUrl: imageUrl,
                            highlights: [
                              if (packageResult.description.isNotEmpty)
                                packageResult.description
                              else
                                'Great for scenic getaways',
                              'Operated by $agencyName',
                            ],
                            included: [
                              {
                                'icon': Icons.directions_bus,
                                'text': 'Transport included',
                              },
                              {
                                'icon': Icons.restaurant,
                                'text': 'Meals where listed',
                              },
                              {'icon': Icons.person, 'text': 'Local guide'},
                            ],
                            perfectFor: ['Friends', 'Families', 'Couples'],
                            itinerary: [
                              ItineraryDay(
                                day: 'Day 01',
                                title: 'Arrival & meet agency',
                                subtitle:
                                    'Check-in and meet your guide from $agencyName.',
                                icon: Icons.location_pin,
                              ),
                              ItineraryDay(
                                day: 'Day 02',
                                title: 'Explore highlights',
                                subtitle: 'Destinations: $locations.',
                                icon: Icons.map,
                              ),
                            ],
                            reviews: [
                              Review(
                                initial: agencyName.isNotEmpty
                                    ? agencyName[0].toUpperCase()
                                    : 'A',
                                name: agencyName,
                                date: 'recent',
                                stars: 5,
                                comment: 'Contact agency for full details.',
                              ),
                            ],
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackageDetailsScreen(
                                package: package,
                                isPublic: packageIsPublic,
                              ),
                            ),
                          );
                        },
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
}
