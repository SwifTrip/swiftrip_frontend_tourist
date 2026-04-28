import 'package:swift_trip_app/screens/agencySelection.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/common_button.dart';
import '../services/package_service.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:ui';

class SearchTour extends StatefulWidget {
  const SearchTour({super.key});

  @override
  State<SearchTour> createState() => _SearchTourState();
}

class _SearchTourState extends State<SearchTour> {
  bool isPublicTrip = true;
  DateTime? selectedDate;
  int travelers = 1;
  String selectedStyle = 'Adventure';
  String fromLocation = '';
  String toLocation = '';
  bool isLoading = false;
  List<String> locations = [];

  final PackageService _packageService = PackageService();

  String? _buildStartDateForSearch() {
    if (!isPublicTrip || selectedDate == null) return null;
    final year = selectedDate!.year.toString().padLeft(4, '0');
    final month = selectedDate!.month.toString().padLeft(2, '0');
    final day = selectedDate!.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

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
        startDate: _buildStartDateForSearch(),
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
                dates: isPublicTrip
                    ? (selectedDate != null
                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                        : '')
                    : '',
              publicSearchDate: isPublicTrip ? selectedDate : null,
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
                  Text(
                    'Where to?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
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
                    'Start Date (on or after)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  _buildDateSelector(),
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

  Widget _buildTripTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BounceButton(
              onTap: () => setState(() => isPublicTrip = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isPublicTrip ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isPublicTrip ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
                ),
                child: Center(
                  child: Text(
                    'Public Tour',
                    style: GoogleFonts.plusJakartaSans(
                      color: isPublicTrip ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _BounceButton(
              onTap: () => setState(() => isPublicTrip = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isPublicTrip ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: !isPublicTrip ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
                ),
                child: Center(
                  child: Text(
                    'Private Tour',
                    style: GoogleFonts.plusJakartaSans(
                      color: !isPublicTrip ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          _buildLocationField(
            label: 'FROM',
            value: fromLocation,
            hint: 'Departure City',
            icon: Icons.trip_origin_rounded,
            iconColor: Colors.blue,
            onTap: () => _showLocationPicker(context, true),
          ),
          Container(
            padding: const EdgeInsets.only(left: 32),
            child: Column(
              children: List.generate(3, (index) => Container(
                width: 2,
                height: 6,
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
              )),
            ),
          ),
          _buildLocationField(
            label: 'TO',
            value: toLocation,
            hint: 'Arrival City',
            icon: Icons.location_on_rounded,
            iconColor: Colors.redAccent,
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
    return _BounceButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? (hint ?? 'Select City') : value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: value.isEmpty ? AppColors.textSecondary.withOpacity(0.3) : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageStyles() {
    return Row(
      children: [
        Expanded(
          child: _buildStyleCard(
            title: 'Adventure',
            description: 'Outdoor thrills',
            icon: Icons.landscape_rounded,
            iconColor: Colors.blue,
            isPopular: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStyleCard(
            title: 'Cultural',
            description: 'Local traditions',
            icon: Icons.museum_rounded,
            iconColor: Colors.purple,
            isPopular: false,
          ),
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
    return _BounceButton(
      onTap: () => setState(() => selectedStyle = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.accent : AppColors.border, width: isSelected ? 2 : 1),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.accent.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Text(description, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.textSecondary)),
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

  Widget _buildDateSelector() {
    final display = selectedDate != null
      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
      : 'Select start date';

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedDate != null ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: selectedDate != null ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              display,
              style: TextStyle(
                color: selectedDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// Boing Physics Button
class _BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _BounceButton({required this.child, this.onTap});

  @override
  State<_BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<_BounceButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
       _controller.reverse();
       if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
