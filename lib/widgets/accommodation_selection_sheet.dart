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
      child: const Center(child: Text("Accommodation Selection Sheet")),
    );
  }
}
