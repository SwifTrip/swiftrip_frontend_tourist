import 'package:swift_trip_app/screens/agencySelection.dart';
import '../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/common_button.dart';
import '../services/package_service.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class SearchTour extends StatefulWidget {
  const SearchTour({super.key});

  @override
  State<SearchTour> createState() => _SearchTourState();
}

class _SearchTourState extends State<SearchTour> {
  bool isPublicTrip = true;
  String selectedMonth = 'Anytime';
  DateTime? selectedDate;
  int travelers = 1;
  String selectedStyle = 'Adventure';
  String fromLocation = '';
  String toLocation = '';
  bool isLoading = false;
  List<String> locations = [];

  final PackageService _packageService = PackageService();

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final String jsonString = await rootBundle.loadString('lib/cities.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      setState(() {
        locations = List<String>.from(jsonData);
      });
    } catch (e) {
      setState(() {
        locations = [];
      });
    }
  }

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

  Future<void> _searchPackages() async {
    // Validate required fields
    if (fromLocation.isEmpty || toLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both from and to locations'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await _packageService.searchPackages(
        fromLocation: fromLocation,
        toLocation: toLocation,
        travelers: travelers,
        category: selectedStyle.toUpperCase(),
        tourType: isPublicTrip ? 'PUBLIC' : 'PRIVATE',
        // startDate: selectedDate?.toIso8601String(),
      );

      setState(() {
        isLoading = false;
      });

      if (result != null && result.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgencySelection(
              destination: toLocation,
              dates: isPublicTrip ? selectedMonth : '',
              travelers: travelers,
              isPublic: isPublicTrip,
              packages: result.data,
              pagination: result.pagination,
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to fetch tours. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showLocationPicker(BuildContext context, bool isFromLocation) {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredLocations = List.from(locations);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void filterLocations(String query) {
              setModalState(() {
                if (query.isEmpty) {
                  filteredLocations = List.from(locations);
                } else {
                  filteredLocations = locations
                      .where(
                        (location) => location.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                      )
                      .toList();
                }
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isFromLocation
                              ? 'Select From Location'
                              : 'Select Destination',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterLocations,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search location...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.accent),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location list
                  Expanded(
                    child: filteredLocations.isEmpty
                        ? Center(
                            child: Text(
                              'No locations found',
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.5),
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredLocations.length,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemBuilder: (context, index) {
                              final location = filteredLocations[index];
                              final isSelected = isFromLocation
                                  ? location == fromLocation
                                  : location == toLocation;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isFromLocation) {
                                      fromLocation = location;
                                    } else {
                                      toLocation = location;
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.accent.withOpacity(0.1)
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.accent
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: isSelected
                                            ? AppColors.accent
                                            : AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          location,
                                          style: TextStyle(
                                            color: isSelected
                                                ? AppColors.accent
                                                : AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.accent,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                  if (isPublicTrip) ...[
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
                  ],
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
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    )
                  : CommonButton(
                      text: 'Find Adventures',
                      onPressed: _searchPackages,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
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
            label: 'Group Size',
            count: travelers,
            icon: Icons.person,
            iconBg: Colors.blue.withValues(alpha: 0.1),
            iconColor: Colors.blue,
            onIncrement: () => setState(() => travelers++),
            onDecrement: () =>
                setState(() => travelers > 1 ? travelers-- : null),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelerRow({
    required String label,
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
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
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
                icon: const Icon(
                  Icons.remove,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
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
                  color: isSelected
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : AppColors.surface,
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
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textSecondary,
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
                  color: selectedDate != null
                      ? AppColors.accent
                      : AppColors.border,
                ),
              ),
              child: Icon(
                Icons.calendar_month,
                color: selectedDate != null
                    ? AppColors.accent
                    : AppColors.textSecondary,
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
            value: fromLocation,
            hint: 'Departure City',
            icon: Icons.circle_outlined,
            iconColor: Colors.blue,
            onTap: () => _showLocationPicker(context, true),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 1,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          _buildLocationField(
            label: 'TO',
            value: toLocation,
            hint: 'Arrival City',
            icon: Icons.location_on,
            iconColor: Colors.red,
            onTap: () => _showLocationPicker(context, false),
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ],
          ),
        ],
      ),
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
            alignment: isPublicTrip
                ? Alignment.centerLeft
                : Alignment.centerRight,
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
                        color: isPublicTrip
                            ? AppColors.background
                            : AppColors.textSecondary,
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
                        color: !isPublicTrip
                            ? AppColors.background
                            : AppColors.textSecondary,
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
