
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import '../models/tour_package.dart';
// import 'package_details_screen.dart'; // To be migrated in Phase 3

class TourResultsScreen extends StatelessWidget {
  final String destination;
  final String dates;
  final int guests;
  final bool isPublic;

  const TourResultsScreen({
    super.key,
    required this.isPublic,
    this.destination = 'Hunza',
    this.dates = 'Sep 15 - Sep 19',
    this.guests = 2,
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTourCard(
                  context: context,
                  title: isPublic ? 'Classic Hunza Expedition' : 'Classic Hunza Private Expedition',
                  locations: 'Karimabad, Altit, Baltit',
                  price: isPublic ? 450 : 950,
                  rating: 4.8,
                  reviews: 128,
                  duration: '5 Days',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCJ63yU4pc9m4bcYiIRArzFDSP_KI3AUe5IOfp2OPRbK0WFJrIq9oZLq2MJlkHnUlKc7_gSDi0ZDtT8Qgjqlt1KdpJ3kT8ZKTdUTV3n86Ao5glkAvkNvpKz5mFdmcdBbu_E5BkzpbU2VWmHO1JDXoYKy8cRSSqiZWTlVFboXax5qolrS3ZhApq-YbGOkgcuV7T-ig44eFIHE3pqCqrzlNWfJBeHAO-Jn8b7jv-I5sPGUZNVxg9F02GWis-boOAMc5Q2rUbJ3D4NdtZU',
                  tags: isPublic 
                      ? ['Transportation', 'Hotels', 'Guide'] 
                      : ['Private Car', 'Luxury Hotels', 'Dedicated Guide'],
                ),
                const SizedBox(height: 20),
                _buildTourCard(
                  context: context,
                  title: isPublic ? 'Attabad & Passu Adventure' : 'Attabad & Passu Luxury Private',
                  locations: 'Attabad Lake, Passu Cones',
                  price: isPublic ? 620 : 1200,
                  rating: 4.9,
                  reviews: 84,
                  duration: '7 Days',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeaQ9BAz698k59yniB4d6C2z2ywKuBqhjVSDAcd9Ntj664CjGA1sw1imif_dIw8evhs0E58snAcPnDT_Pr8vYB-Ll9i-OPQ-4aoJVhDCTUYPKQbILC_8OMI2oh9xtaJ_gqGVcEBFcYXFG5r074QxscACVwhT3-MktmsZXjyaULwzgib2iIk3nkaryP0Yw5w9Dy-BwBZpNvnrBM-6GI29CZ9ImF4yYthMR7vEDy-JxUqjSMVlAy_N1DHassPk-OBM7Upk321K2zD7Kg',
                  tags: isPublic 
                      ? ['Boating', 'Hiking', 'Breakfast'] 
                      : ['Private Boat', 'Hiking', 'Breakfast Included'],
                  isPopular: true,
                ),
                const SizedBox(height: 20),
                _buildTourCard(
                  context: context,
                  title: isPublic ? 'Cultural Heritage Tour' : 'Cultural Private Tour',
                  locations: 'Ganish, Altit Fort',
                  price: isPublic ? 380 : 780,
                  rating: 4.6,
                  reviews: 45,
                  duration: '3 Days',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDJjHyHnTeWrSSeTZaAuHj1nfzxx7r_qWJLl6CWuaUWTu6qmL2_GMiKfWnw1MtVQ_lrYN0EvMbGsn5EBcZwSpGVzHZS66auuUQXGnAGwVHcLLXfkMrTFaUojO46gfjKbosV5KV70XuvWI1q4anY--PUEtSYimyYt8sxD1bLSuXiSaQa9_in5hl9b4sYkHJUZjFZdMBJgg7sRjLvFO8ripDgDOPhjAFPkAeR2_txXtJIgu1n1QzXUBd3q72PS__48YKQxQ9YDrdMh7U1',
                  tags: isPublic 
                      ? ['History', 'Museums', 'Local Food'] 
                      : ['Private Guide', 'Exclusive Access', 'Local Cuisine'],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildFilterChip(String label, {bool isActive = false, bool hasDropdown = false}) {
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
    required String locations,
    required int price,
    required double rating,
    required int reviews,
    required String duration,
    required String imageUrl,
    required List<String> tags,
    bool isPopular = false,
  }) {
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isPublic ? AppColors.background.withOpacity(0.6) : Colors.purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isPublic ? Colors.green : Colors.purpleAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isPublic ? 'PUBLIC AVAILABLE' : 'PRIVATE AVAILABLE',
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule, color: Colors.white, size: 14),
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
                              const Icon(Icons.location_on, color: AppColors.textSecondary, size: 14),
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
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.yellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.yellow, size: 14),
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
                  children: tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPublic ? Colors.blue.withOpacity(0.1) : Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isPublic ? Colors.blue : Colors.purpleAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )).toList(),
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
                                  '\$$price',
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
                          // TODO: Navigate to PackageDetailsScreen once migrated
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Package details coming soon!"))
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
