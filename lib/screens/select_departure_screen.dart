import 'package:flutter/material.dart';
import '../models/tour_package.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';

class SelectDepartureScreen extends StatefulWidget {
  final TourPackage package;

  const SelectDepartureScreen({super.key, required this.package});

  @override
  State<SelectDepartureScreen> createState() => _SelectDepartureScreenState();
}

class _SelectDepartureScreenState extends State<SelectDepartureScreen> {
  int _selectedMonthIndex = 0;
  int _selectedDepartureIndex = 1;

  final List<String> _months = ["June '24", "July '24", "August '24", "September '24"];

  final List<Map<String, dynamic>> _departures = [
    {
      'month': 'JUN',
      'day': '10',
      'date': DateTime(2024, 6, 10),
      'range': 'Mon - Fri',
      'fullRange': 'Jun 10 - Jun 14',
      'seats': 0,
      'status': 'Fully Booked',
    },
    {
      'month': 'JUN',
      'day': '24',
      'date': DateTime(2024, 6, 24),
      'range': 'Mon - Sat',
      'fullRange': 'Jun 24 - Jun 29',
      'seats': 4,
      'status': 'Selling Fast',
    },
    {
      'month': 'JUL',
      'day': '08',
      'date': DateTime(2024, 7, 8),
      'range': 'Mon - Sat',
      'fullRange': 'Jul 08 - Jul 13',
      'seats': 10,
      'status': 'Available',
    },
    {
      'month': 'JUL',
      'day': '22',
      'date': DateTime(2024, 7, 22),
      'range': 'Mon - Sat',
      'fullRange': 'Jul 22 - Jul 27',
      'seats': 8,
      'status': 'Available',
    },
    {
      'month': 'AUG',
      'day': '05',
      'date': DateTime(2024, 8, 5),
      'range': 'Mon - Sat',
      'fullRange': 'Aug 05 - Aug 10',
      'seats': 12,
      'status': 'Available',
    },
  ];

  static const Color _accentColor = Color(0xFF137FEC);

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
        title: const Text(
          'Select Departure',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: const Center(child: Text("Select Departure Skeleton")),
    );
  }
}
