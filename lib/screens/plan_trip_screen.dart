import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/package_service.dart';
import '../theme/app_colors.dart';
import '../widgets/common_button.dart';
import 'agencySelection.dart';

class PlanTripScreen extends StatefulWidget {
  final bool initialIsPublic;

  const PlanTripScreen({super.key, this.initialIsPublic = true});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  final PackageService _packageService = PackageService();

  late bool _isPublicTrip;
  DateTime? _selectedDate;
  int _travelers = 2;
  String _selectedStyle = 'ADVENTURE';
  String _fromLocation = '';
  String _toLocation = '';
  bool _isLoading = false;
  bool _isLoadingSuggestions = true;
  List<String> _locations = [];
  List<String> _suggestedDestinations = [];
  List<String> _suggestedFromLocations = [];
  List<String> _suggestedStyles = [];

  static const List<String> _styles = [
    'ADVENTURE',
    'FAMILY',
    'ROMANTIC',
    'CULTURAL',
    'RELIGIOUS',
  ];

  @override
  void initState() {
    super.initState();
    _isPublicTrip = widget.initialIsPublic;
    _loadCities();
    _loadPlanningSuggestions();
  }

  String? _buildStartDateForSearch() {
    if (!_isPublicTrip || _selectedDate == null) return null;
    final year = _selectedDate!.year.toString().padLeft(4, '0');
    final month = _selectedDate!.month.toString().padLeft(2, '0');
    final day = _selectedDate!.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _loadCities() async {
    try {
      final jsonString = await rootBundle.loadString('lib/cities.json');
      final jsonData = jsonDecode(jsonString) as List<dynamic>;
      if (!mounted) return;
      setState(() {
        _locations = List<String>.from(jsonData);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _locations = [];
      });
    }
  }

  Future<void> _loadPlanningSuggestions() async {
    try {
      final data = await _packageService.getPlanningSuggestions(limit: 8);
      if (!mounted) return;

      setState(() {
        _suggestedDestinations = ((data?['destinations'] as List?) ?? [])
            .map((item) => item.toString())
            .where((item) => item.trim().isNotEmpty)
            .toList();
        _suggestedFromLocations = ((data?['fromLocations'] as List?) ?? [])
            .map((item) => item.toString())
            .where((item) => item.trim().isNotEmpty)
            .toList();
        _suggestedStyles = ((data?['styles'] as List?) ?? [])
            .map((item) => item.toString().toUpperCase())
            .where((item) => item.trim().isNotEmpty)
            .toList();
        _isLoadingSuggestions = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingSuggestions = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );

    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _searchPackages() async {
    if (_fromLocation.isEmpty || _toLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both from and destination.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _packageService.searchPackages(
        fromLocation: _fromLocation,
        toLocation: _toLocation,
        travelers: _travelers,
        category: _selectedStyle,
        tourType: _isPublicTrip ? 'PUBLIC' : 'PRIVATE',
        startDate: _buildStartDateForSearch(),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result != null && result.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgencySelection(
              destination: _toLocation,
              dates: _isPublicTrip && _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : '',
              publicSearchDate: _isPublicTrip ? _selectedDate : null,
              travelers: _travelers,
              isPublic: _isPublicTrip,
              packages: result.data,
              pagination: result.pagination,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No matching tours found right now.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not search tours. Please try again.'),
        ),
      );
    }
  }

  void _showLocationPicker(bool isFromLocation) {
    final searchController = TextEditingController();
    List<String> filteredLocations = List.from(_locations);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void filterLocations(String query) {
              setModalState(() {
                if (query.isEmpty) {
                  filteredLocations = List.from(_locations);
                } else {
                  filteredLocations = _locations
                      .where(
                        (location) => location.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                      )
                      .toList();
                }
              });
            }

            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.76,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Text(
                            isFromLocation ? 'From Location' : 'Destination',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        onChanged: filterLocations,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search city',
                          hintStyle: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: filteredLocations.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final city = filteredLocations[index];
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: AppColors.surface,
                            title: Text(
                              city,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            onTap: () {
                              setState(() {
                                if (isFromLocation) {
                                  _fromLocation = city;
                                } else {
                                  _toLocation = city;
                                }
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plan a Trip',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Public or private, build your ideal itinerary.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF7C2D12), Color(0xFF431407)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFFFEDD5), Color(0xFFFFF7ED)],
                        ),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Type',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _tripTypeCard(
                            title: 'Public Tour',
                            subtitle: 'Scheduled departures',
                            icon: Icons.groups_rounded,
                            active: _isPublicTrip,
                            color: const Color(0xFFEA580C),
                            onTap: () => setState(() => _isPublicTrip = true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _tripTypeCard(
                            title: 'Private Tour',
                            subtitle: 'Fully customized',
                            icon: Icons.verified_user_rounded,
                            active: !_isPublicTrip,
                            color: const Color(0xFFC2410C),
                            onTap: () => setState(() => _isPublicTrip = false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _buildSuggestionsPanel(isDark),
              const SizedBox(height: 16),
              _inputTile(
                icon: Icons.my_location_rounded,
                iconColor: AppColors.accentTeal,
                title: 'From',
                value: _fromLocation.isEmpty
                    ? 'Select departure city'
                    : _fromLocation,
                onTap: () => _showLocationPicker(true),
              ),
              const SizedBox(height: 10),
              _inputTile(
                icon: Icons.location_on_rounded,
                iconColor: AppColors.accentBlue,
                title: 'To',
                value: _toLocation.isEmpty ? 'Select destination' : _toLocation,
                onTap: () => _showLocationPicker(false),
              ),
              const SizedBox(height: 10),
              if (_isPublicTrip) ...[
                _inputTile(
                  icon: Icons.calendar_month_rounded,
                  iconColor: AppColors.accentViolet,
                  title: 'Start Date',
                  value: _selectedDate == null
                      ? 'Select your preferred departure date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  onTap: _selectDate,
                ),
                const SizedBox(height: 10),
              ],
              _travelersCard(),
              const SizedBox(height: 12),
              Text(
                'Travel Style',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _styles.map((style) {
                  final selected = _selectedStyle == style;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedStyle = style),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFEA580C).withValues(alpha: 0.14)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFEA580C)
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        style[0] + style.substring(1).toLowerCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? const Color(0xFFEA580C)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              _searchCta(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tripTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool active,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.14) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? color : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: active ? color : AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _travelersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.accentRose.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.group_rounded,
              size: 19,
              color: AppColors.accentRose,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travelers',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_travelers ${_travelers == 1 ? 'Person' : 'People'}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          _stepButton(
            icon: Icons.remove_rounded,
            onTap: _travelers > 1 ? () => setState(() => _travelers--) : null,
          ),
          const SizedBox(width: 8),
          _stepButton(
            icon: Icons.add_rounded,
            onTap: _travelers < 20 ? () => setState(() => _travelers++) : null,
          ),
        ],
      ),
    );
  }

  Widget _stepButton({required IconData icon, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: onTap == null
              ? AppColors.border.withValues(alpha: 0.5)
              : const Color(0xFFEA580C).withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? AppColors.textSecondary
              : const Color(0xFFEA580C),
        ),
      ),
    );
  }

  Widget _searchCta() {
    return CommonButton(
      text: _isPublicTrip ? 'Find Public Tours' : 'Find Private Tours',
      onPressed: _isLoading ? null : _searchPackages,
      isEnabled: !_isLoading,
      isLoading: _isLoading,
      borderRadius: 14,
      height: 52,
      fontSize: 14,
    );
  }

  Widget _buildSuggestionsPanel(bool isDark) {
    if (_isLoadingSuggestions) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Text(
              'Loading live suggestions...',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    if (_suggestedDestinations.isEmpty &&
        _suggestedFromLocations.isEmpty &&
        _suggestedStyles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                size: 16,
                color: isDark
                    ? const Color(0xFFFFA94D)
                    : const Color(0xFFEA580C),
              ),
              const SizedBox(width: 6),
              Text(
                'Popular Right Now',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          if (_suggestedDestinations.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildSuggestionChips(
              label: 'Top destinations',
              items: _suggestedDestinations,
              chipColor: AppColors.accentBlue,
              onTap: (item) => setState(() => _toLocation = item),
            ),
          ],
          if (_suggestedFromLocations.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildSuggestionChips(
              label: 'Popular origins',
              items: _suggestedFromLocations,
              chipColor: AppColors.accentTeal,
              onTap: (item) => setState(() => _fromLocation = item),
            ),
          ],
          if (_suggestedStyles.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildSuggestionChips(
              label: 'Hot styles',
              items: _suggestedStyles,
              chipColor: AppColors.accentViolet,
              onTap: (item) => setState(() => _selectedStyle = item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionChips({
    required String label,
    required List<String> items,
    required Color chipColor,
    required void Function(String item) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return GestureDetector(
              onTap: () => onTap(item),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: chipColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: chipColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  item,
                  style: GoogleFonts.plusJakartaSans(
                    color: chipColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
