import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'common_button.dart';

class AccommodationSelectionSheet extends StatefulWidget {
  final bool isPublic;
  final String day;
  final String date;
  final String location;

  const AccommodationSelectionSheet({
    super.key,
    required this.isPublic,
    required this.day,
    required this.date,
    required this.location,
  });

  @override
  State<AccommodationSelectionSheet> createState() => _AccommodationSelectionSheetState();
}

class _AccommodationSelectionSheetState extends State<AccommodationSelectionSheet> {
  int _selectedIndex = 0;
  late final Color _accentColor;

  final List<Map<String, dynamic>> _hotels = [
    {
      'name': 'Luxus Hunza Resort',
      'room': 'Deluxe Lake View Room',
      'rating': 4.8,
      'status': 'Current Choice',
      'priceLabel': 'Included in price',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCJ63yU4pc9m4bcYiIRArzFDSP_KI3AUe5IOfp2OPRbK0WFJrIq9oZLq2MJlkHnUlKc7_gSDi0ZDtT8Qgjqlt1KdpJ3kT8ZKTdUTV3n86Ao5glkAvkNvpKz5mFdmcdBbu_E5BkzpbU2VWmHO1JDXoYKy8cRSSqiZWTlVFboXax5qolrS3ZhApq-YbGOkgcuV7T-ig44eFIHE3pqCqrzlNWfJBeHAO-Jn8b7jv-I5sPGUZNVxg9F02GWis-boOAMc5Q2rUbJ3D4NdtZU',
    },
    {
      'name': 'Serena Inn Hunza',
      'room': 'Standard Room • Garden View',
      'rating': 4.5,
      'status': 'Save',
      'priceLabel': '-\$120 save',
      'isSavings': true,
      'icon': Icons.hotel_outlined,
    },
    {
      'name': 'Darbar Hotel',
      'room': 'Presidential Suite',
      'rating': 5.0,
      'status': 'Upgrade',
      'priceLabel': '+\$450 total',
      'isUpgrade': true,
      'icon': Icons.king_bed_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _accentColor = widget.isPublic ? const Color(0xFF137FEC) : const Color(0xFF8B5CF6);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 48,
            height: 6,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(99)),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Change Accommodation',
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.day} • ${widget.date} • ${widget.location}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(backgroundColor: Colors.white12, padding: const EdgeInsets.all(8)),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          // Hotel List
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: _hotels.asMap().entries.map((entry) {
                  final index = entry.key;
                  final hotel = entry.value;
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? _accentColor.withOpacity(0.05) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? _accentColor : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: _accentColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                        ] : null,
                      ),
                      child: Row(
                        children: [
                          _buildHotelImage(hotel),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _buildRatingBadge(hotel['rating']),
                                    const SizedBox(width: 6),
                                    if (hotel['status'] != null)
                                      _buildStatusTag(hotel),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hotel['name'],
                                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  hotel['room'],
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  hotel['priceLabel'],
                                  style: TextStyle(
                                    color: hotel['isSavings'] == true 
                                        ? const Color(0xFF10B981) 
                                        : AppColors.textPrimary,
                                    fontWeight: hotel['isSavings'] == true || hotel['isUpgrade'] == true 
                                        ? FontWeight.bold : FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildRadioCircle(isSelected),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: CommonButton(
                text: 'Apply Changes',
                onPressed: () => Navigator.pop(context),
                backgroundColor: _accentColor,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelImage(Map<String, dynamic> hotel) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: hotel['imageUrl'] != null
            ? Image.network(hotel['imageUrl'], fit: BoxFit.cover)
            : Icon(hotel['icon'] ?? Icons.hotel, color: AppColors.textSecondary, size: 32),
      ),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 10),
          const SizedBox(width: 2),
          Text(
            rating.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(Map<String, dynamic> hotel) {
    final status = hotel['status'];
    Color bgColor = _accentColor.withOpacity(0.1);
    Color textColor = _accentColor;
    
    if (hotel['isUpgrade'] == true) {
      bgColor = const Color(0xFFF59E0B).withOpacity(0.1);
      textColor = const Color(0xFFF59E0B);
    } else if (hotel['isSavings'] == true) {
      bgColor = const Color(0xFF10B981).withOpacity(0.1);
      textColor = const Color(0xFF10B981);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        status,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRadioCircle(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? _accentColor : Colors.white24,
          width: 2,
        ),
        color: isSelected ? _accentColor : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Colors.white, size: 14)
          : null,
    );
  }
}
