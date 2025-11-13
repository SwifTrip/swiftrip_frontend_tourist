import 'package:flutter/material.dart';
import 'package:swift_trip_app/widgets/custom_app_bar.dart';
import 'package:swift_trip_app/widgets/custom_bottom_bar.dart';
import 'package:swift_trip_app/screens/app-theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentStep: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Tour Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Review your customized tour package',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildItinerary(),
            const SizedBox(height: 20),
            _buildCostBreakdown(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1),
    );
  }
}

Widget _buildItinerary() {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Itinerary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 20),
        _buildDayPlan(
          day: 'Arrival Day',
          isExpanded: true,
          children: [
            _buildTimelineItem(
              title: 'Accommodation',
              content: _buildAccommodationCard(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC6KXqejCy4AWepX8j-c0i9kjx0ML3yfH8x6OMFSMxxTB8HUYrTRpd_ubxgsg2HXfhrgUqQFg5V1gCp0przG_6LFKm_7yYxp8kbx_S-2cSM9L7KhVzUdBwa_BeZIF1OBvoROB9zGH9sWzQJqh9OFlWmVjK_DlQtU7Yn2ydYDfsGq4HMQBjJO2f9RjjiKLn7Mrn8_qNDdC5cBsjoo5MHRhAsZPCGAF-Z0htTl3SOLsuA-e72YlGBRrM-RIp-2iuW73Z3Ziuy57X0kCc',
                name: 'Mountain View Resort',
                rating: 4.5,
                reviews: 1234,
              ),
            ),
            _buildTimelineItem(
              title: 'Activities',
              content: _buildActivityCard(
                activity: 'Welcome Dinner',
                details: '7:00 PM - Local Cuisine',
              ),
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildDayPlan(
          day: 'Day 1',
          isExpanded: true,
          children: [
            _buildTimelineItem(
              title: 'Accommodation',
              content: _buildAccommodationCard(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCrJ86mX5CvZUYemYf3Cigj6bXEP5StG_GctXbijL8iVv5a_8YNrsrHS-Vg6G6c0iIwKmYSwUMCTdsucppwCvOt2M75EkCCZRsp6OlXeJsR6KuEn-wAbUo6j1uBVHLYR-67KZk6atWSzDwA-CqUZK2Y7Lt9R9TaPMVpHf4mBqB-vCnj-1Sa79E836lnRskuOYcjMUMbp22eaQ0yzpHXGHZX5vXe1jp0gDvWjl7LnLMfnnpaEKb9gkdnKOADEkmnvxMR0L0POLVEWaU',
                name: 'Comfort Inn',
                rating: 4.2,
                reviews: 876,
              ),
            ),
            _buildTimelineItem(
              title: 'Activities',
              content: Column(
                children: [
                  _buildActivityCard(
                    activity: 'City Walking Tour',
                    details: '9:00 AM - 3 hours',
                  ),
                  const SizedBox(height: 10),
                  _buildActivityCard(
                    activity: 'Museum Visit',
                    details: '2:00 PM - 2 hours',
                  ),
                ],
              ),
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildDayPlan(day: 'Day 2', isExpanded: false, children: []),
      ],
    ),
  );
}

Widget _buildDayPlan({
  required String day,
  required bool isExpanded,
  required List<Widget> children,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: AppTheme.secondaryTextColor,
          ),
        ],
      ),
      if (isExpanded) ...[const SizedBox(height: 10), ...children],
    ],
  );
}

Widget _buildTimelineItem({
  required String title,
  required Widget content,
  bool isLast = false,
}) {
  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.circle, color: AppTheme.primaryColor, size: 16),
            if (!isLast)
              Expanded(
                child: Container(width: 2, color: AppTheme.primaryColor),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              content,
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildAccommodationCard({
  required String imageUrl,
  required String name,
  required double rating,
  required int reviews,
}) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' $rating (${reviews} reviews)'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Change'),
        ),
      ],
    ),
  );
}

Widget _buildActivityCard({required String activity, required String details}) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              details,
              style: const TextStyle(color: AppTheme.secondaryTextColor),
            ),
          ],
        ),
        const Icon(Icons.edit, color: AppTheme.primaryColor),
      ],
    ),
  );
}

Widget _buildCostBreakdown() {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cost Breakdown',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 10),
        _buildCostRow('Base Package (Heritage Tours)', '\$2,800.00'),
        _buildCostRow('Arrival Day - Mountain View Resort', '\$150.00'),
        _buildCostRow('Day 1 - Comfort Inn', '\$80.00'),
        _buildCostRow('Day 2 - Luxury Palace', '\$250.00'),
        const Divider(height: 20),
        _buildCostRow('Subtotal', '\$3,280.00'),
        _buildCostRow('Taxes (10%)', '\$328.00'),
        const Divider(height: 20),
        _buildCostRow('Total', '\$3,608.00', isTotal: true),
      ],
    ),
  );
}

Widget _buildCostRow(String title, String amount, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.green : AppTheme.textColor,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.green : AppTheme.textColor,
          ),
        ),
      ],
    ),
  );
}
