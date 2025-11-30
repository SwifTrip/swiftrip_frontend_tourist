import '../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/common_button.dart';

class PlanTripScreen extends StatefulWidget {
  const PlanTripScreen({super.key});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  bool isPublicTrip = true;
  String selectedMonth = 'Anytime';
  DateTime? selectedDate;
  int adultsCount = 2;
  int childrenCount = 0;
  String selectedStyle = 'Adventure';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.background,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.background,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedMonth = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Padding(
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

            // When Section
            const Text(
              'When?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildMonthSelector(),
            const SizedBox(height: 32),

            // Travelers Section
            const Text(
              'Travelers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTravelersSection(),
            const SizedBox(height: 32),

            // Package Style Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Package Style',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'COMPARE',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPackageStyles(),
                ],
              ),
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.9),
                border: const Border(
                  top: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: CommonButton(
                text: 'Find Adventures',
                onPressed: () {
                  // TODO: Navigate to TourResultsScreen once migrated
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tour results coming soon!"))
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageStyles() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.05,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStyleCard(
          title: 'Adventure',
          description: 'Hiking, camping and outdoor activities.',
          icon: Icons.landscape,
          iconColor: Colors.blue,
          isPopular: true,
        ),
        _buildStyleCard(
          title: 'Cultural',
          description: 'Historical sites and local traditions.',
          icon: Icons.museum,
          iconColor: Colors.purple,
          isPopular: false,
        ),
      ],
    );
  }

  Widget _buildStyleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    bool isPopular = false,
  }) {
    final isSelected = selectedStyle == title;
    return GestureDetector(
      onTap: () => setState(() => selectedStyle = title),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Popular',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildTravelerRow(
            label: 'Adults',
            subtitle: 'Age 18+',
            count: adultsCount,
            icon: Icons.person,
            iconBg: Colors.blue.withValues(alpha: 0.1),
            iconColor: Colors.blue,
            onIncrement: () => setState(() => adultsCount++),
            onDecrement: () => setState(() => adultsCount > 1 ? adultsCount-- : null),
          ),
          const Divider(color: AppColors.border, height: 32),
          _buildTravelerRow(
            label: 'Children',
            subtitle: 'Age 0-17',
            count: childrenCount,
            icon: Icons.child_care,
            iconBg: Colors.orange.withValues(alpha: 0.1),
            iconColor: Colors.orange,
            onIncrement: () => setState(() => childrenCount++),
            onDecrement: () => setState(() => childrenCount > 0 ? childrenCount-- : null),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelerRow({
    required String label,
    required String subtitle,
    required int count,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove, size: 16, color: AppColors.textSecondary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32),
              ),
              SizedBox(
                width: 20,
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final months = [
      {'label': 'ANYTIME', 'value': 'Flexible'},
      {'label': 'JUN', 'value': 'Next Month'},
      {'label': 'JUL', 'value': 'Summer'},
    ];

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...months.map((m) {
            final isSelected = selectedMonth == m['value'];
            return GestureDetector(
              onTap: () => setState(() => selectedMonth = m['value']!),
              child: Container(
                width: 110,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.border,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      m['label']!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.accent : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m['value']!,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedDate != null ? AppColors.accent : AppColors.border,
                ),
              ),
              child: Icon(
                Icons.calendar_month,
                color: selectedDate != null ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ),
        ],
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
