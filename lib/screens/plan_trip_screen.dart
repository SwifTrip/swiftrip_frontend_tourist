import 'package:swift_trip_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PlanTripScreen extends StatefulWidget {
  const PlanTripScreen({super.key});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  bool isPublicTrip = true;

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
          'Plan Your Trip',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Type Toggle
            _buildTripTypeToggle(),
            const SizedBox(height: 32),

            // Where to Section
            const Text(
              'Where to?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildLocationInputs(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInputs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildLocationField(
            label: 'FROM',
            value: 'San Francisco, CA',
            icon: Icons.circle_outlined,
            iconColor: Colors.blue,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: List.generate(4, (index) => Container(
                  width: 1,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  color: AppColors.textSecondary.withOpacity(0.3),
                )),
              ),
            ),
          ),
          _buildLocationField(
            label: 'TO',
            value: '',
            hint: 'Search Destination',
            icon: Icons.location_on,
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required String label,
    required String value,
    String? hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: value.isNotEmpty
                  ? Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      hint ?? '',
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTripTypeToggle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            alignment: isPublicTrip ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.44,
              height: 42,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isPublicTrip = true),
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'Public Trip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPublicTrip ? AppColors.background : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isPublicTrip = false),
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'Private Trip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !isPublicTrip ? AppColors.background : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
