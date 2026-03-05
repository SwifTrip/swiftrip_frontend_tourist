import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class TripsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const TripsScreen({super.key, required this.onBack});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  BookingsData? _bookingsData;
  bool _isLoadingBookings = false;
  String? _bookingsError;
  String _selectedTripsTab = 'UPCOMING';
  String _selectedTypeFilter = 'ALL';
  DateTime? _selectedStartDate;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  void _switchTripsTab(String tab) {
    if (_selectedTripsTab == tab) return;
    setState(() {
      _selectedTripsTab = tab;
      _bookingsData = null;
      _selectedTypeFilter = 'ALL';
      _selectedStartDate = null;
    });
    _fetchBookings(forceRefresh: true);
  }

  Future<void> _fetchBookings({bool forceRefresh = false}) async {
    if (_isLoadingBookings) return;

    setState(() {
      _isLoadingBookings = true;
      _bookingsError = null;
      if (forceRefresh) {
        _bookingsData = null;
      }
    });

    try {
      final bookingService = BookingService();
      final response =
          await bookingService.getUserBookings(when: _selectedTripsTab);

      if (mounted) {
        setState(() {
          _isLoadingBookings = false;
          if (response != null && response.success) {
            _bookingsData = response.data;
          } else {
            _bookingsError = 'Failed to load bookings';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBookings = false;
          _bookingsError = 'Error: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.9),
            border: Border(
              bottom: BorderSide(
                color: AppColors.border.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'My Trips',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // Upcoming / Past Tab Switcher
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _buildTabButton('Upcoming', 'UPCOMING'),
              _buildTabButton('Past', 'PAST'),
            ],
          ),
        ),

        // Filters Row: Date + Tour Type
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              // Date filter button
              GestureDetector(
                onTap: () async {
                  final now = DateTime.now();
                  DateTime initialDate = _selectedStartDate ?? now;
                  DateTime firstDate;
                  DateTime lastDate;

                  if (_selectedTripsTab == 'UPCOMING') {
                    firstDate = DateTime(now.year, now.month, now.day);
                    lastDate = DateTime(2030);
                    if (initialDate.isBefore(firstDate)) {
                      initialDate = firstDate;
                    }
                  } else {
                    firstDate = DateTime(2020);
                    final todayStart = DateTime(now.year, now.month, now.day);
                    lastDate = todayStart.subtract(const Duration(days: 1));
                    if (initialDate.isAfter(lastDate)) {
                      initialDate = lastDate;
                    }
                  }

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.accent,
                            onSurface: AppColors.textPrimary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    setState(() {
                      _selectedStartDate = picked;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: _selectedStartDate != null
                        ? AppColors.accent.withOpacity(0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedStartDate != null
                          ? AppColors.accent
                          : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: _selectedStartDate != null
                            ? AppColors.accent
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedStartDate != null
                            ? '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}'
                            : 'Start Date',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selectedStartDate != null
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (_selectedStartDate != null) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStartDate = null;
                            });
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Tour type popup filter
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value != _selectedTypeFilter) {
                    setState(() {
                      _selectedTypeFilter = value;
                    });
                  }
                },
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                offset: const Offset(0, 36),
                itemBuilder: (context) => [
                  _buildPopupItem('All', 'ALL'),
                  _buildPopupItem('Public', 'PUBLIC'),
                  _buildPopupItem('Private', 'PRIVATE'),
                ],
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: _selectedTypeFilter != 'ALL'
                        ? AppColors.accent.withOpacity(0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedTypeFilter != 'ALL'
                          ? AppColors.accent
                          : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        size: 16,
                        color: _selectedTypeFilter != 'ALL'
                            ? AppColors.accent
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedTypeFilter == 'ALL'
                            ? 'All'
                            : _selectedTypeFilter == 'PUBLIC'
                                ? 'Public'
                                : 'Private',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selectedTypeFilter != 'ALL'
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: _selectedTypeFilter != 'ALL'
                            ? AppColors.accent
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Trips List
        Expanded(child: _buildListContent()),
      ],
    );
  }

  // ── Tab button ──────────────────────────────────────────────────────────────

  Widget _buildTabButton(String label, String value) {
    final bool isActive = _selectedTripsTab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchTripsTab(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ── Popup menu item ─────────────────────────────────────────────────────────

  PopupMenuItem<String> _buildPopupItem(String label, String value) {
    final bool isSelected = _selectedTypeFilter == value;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_rounded : Icons.radio_button_unchecked,
            size: 18,
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.accent : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── List content ────────────────────────────────────────────────────────────

  Widget _buildListContent() {
    if (_isLoadingBookings) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (_bookingsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              _bookingsError!,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchBookings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    if (_bookingsData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.luggage_outlined,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring and book your first trip!',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    // Apply type filter
    List<dynamic> bookings;
    if (_selectedTypeFilter == 'PUBLIC') {
      bookings = List<dynamic>.from(_bookingsData!.publicTours);
    } else if (_selectedTypeFilter == 'PRIVATE') {
      bookings = List<dynamic>.from(_bookingsData!.privateTours);
    } else {
      bookings = List<dynamic>.from(_bookingsData!.getAllBookings());
    }

    // Apply date filter
    if (_selectedStartDate != null) {
      final filterDate = DateTime(
        _selectedStartDate!.year,
        _selectedStartDate!.month,
        _selectedStartDate!.day,
      );
      bookings = bookings.where((b) {
        DateTime? tripDate;
        if (b is PublicTourBooking && b.departureDate != null) {
          tripDate = DateTime(b.departureDate!.year, b.departureDate!.month,
              b.departureDate!.day);
        } else if (b is PrivateTourBooking && b.startDate != null) {
          tripDate =
              DateTime(b.startDate!.year, b.startDate!.month, b.startDate!.day);
        }
        return tripDate != null && !tripDate.isBefore(filterDate);
      }).toList();
    }

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No trips found',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      key: ValueKey(
          'list_${_selectedTripsTab}_${_selectedTypeFilter}_${_selectedStartDate?.millisecondsSinceEpoch}'),
      onRefresh: _fetchBookings,
      color: AppColors.accent,
      child: ListView.builder(
        key: ValueKey(
            'lv_${_selectedTripsTab}_${_selectedTypeFilter}_${_selectedStartDate?.millisecondsSinceEpoch}'),
        padding: const EdgeInsets.only(
            left: 16, right: 16, top: 8, bottom: 100),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildBookingCard(bookings[index]),
          );
        },
      ),
    );
  }

  // ── Card builders ───────────────────────────────────────────────────────────

  Widget _buildBookingCard(dynamic booking) {
    if (booking is PublicTourBooking) return _buildPublicTourCard(booking);
    if (booking is PrivateTourBooking) return _buildPrivateTourCard(booking);
    return const SizedBox.shrink();
  }

  Widget _buildPublicTourCard(PublicTourBooking booking) {
    final daysUntil = booking.departureDate?.difference(DateTime.now()).inDays;
    final countdown = (daysUntil != null && daysUntil > 0) ? '$daysUntil Days' : 'Today';

    Color statusColor;
    switch (booking.status.toUpperCase()) {
      case 'CONFIRMED':
        statusColor = Colors.greenAccent;
        break;
      case 'PENDING':
        statusColor = Colors.amberAccent;
        break;
      case 'CANCELLED':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.blueAccent;
    }

    return _buildTripCard(
      title: booking.package?.title ?? 'Public Tour',
      provider: booking.company?.name ?? '',
      date: booking.departureDate != null && booking.arrivalDate != null
          ? '${_formatDate(booking.departureDate!)} - ${_formatDate(booking.arrivalDate!)}'
          : 'Date TBD',
      countdown: countdown,
      statusColor: statusColor,
      imageUrl: booking.package?.coverImage ?? '',
      additionalInfo:
          '${booking.seats} seat(s) • PKR ${booking.totalAmount}',
    );
  }

  Widget _buildPrivateTourCard(PrivateTourBooking booking) {
    final daysUntil = booking.startDate?.difference(DateTime.now()).inDays;
    final countdown = (daysUntil != null && daysUntil > 0) ? '$daysUntil Days' : 'Today';

    Color statusColor;
    switch (booking.status.toUpperCase()) {
      case 'CONFIRMED':
      case 'ACCEPTED':
        statusColor = Colors.greenAccent;
        break;
      case 'PENDING':
        statusColor = Colors.amberAccent;
        break;
      case 'CANCELLED':
      case 'REJECTED':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.blueAccent;
    }

    return _buildTripCard(
      title: 'Custom Tour (${booking.duration} days)',
      provider: booking.company?.name ?? '',
      date: booking.startDate != null && booking.endDate != null
          ? '${_formatDate(booking.startDate!)} - ${_formatDate(booking.endDate!)}'
          : 'Date TBD',
      countdown: countdown,
      statusColor: statusColor,
      imageUrl: '',
      additionalInfo:
          '${booking.travelerCount} traveler(s)${booking.totalPrice != null ? ' • PKR ${booking.totalPrice}' : ''}',
    );
  }

  Widget _buildTripCard({
    required String title,
    required String provider,
    required String date,
    required String countdown,
    required Color statusColor,
    required String imageUrl,
    String? additionalInfo,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.background,
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: imageUrl.isEmpty
                ? const Icon(Icons.landscape,
                    color: AppColors.textSecondary, size: 40)
                : null,
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  provider,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                if (additionalInfo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    additionalInfo,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DATE',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600)),
                        Text(date,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('STARTS IN',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600)),
                        Text(countdown,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent)),
                      ],
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

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
