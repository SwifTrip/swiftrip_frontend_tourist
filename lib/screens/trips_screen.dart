import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../config/api_config.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui';
import '../widgets/common_button.dart';

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

  String _resolveImageUrl(String? rawUrl) {
    const fallback = 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop';
    if (rawUrl == null || rawUrl.trim().isEmpty) return fallback;

    String url = rawUrl.trim();

    if (url.startsWith('/uploads')) {
      url = '${ApiConfig.chatSocket}$url';
    } else if (url.startsWith('uploads/')) {
      url = '${ApiConfig.chatSocket}/$url';
    } else if (!url.startsWith('http')) {
      url = '${ApiConfig.chatSocket}/${url.replaceFirst(RegExp(r'^/+'), '')}';
    }

    // Always proxy S3/AWS URLs to avoid CORS
    if (url.contains('amazonaws.com') || url.contains('.s3')) {
      return '${ApiConfig.chatSocket}/proxy-image?url=${Uri.encodeComponent(url)}';
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Body with Background elements if any
        Expanded(
          child: Stack(
            children: [
              // Content Area
              Positioned.fill(
                child: _buildAnimatedContent(),
              ),
              
              // Sticky Glassmorphism Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Header
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.7),
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.border.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              _BounceButton(
                                onTap: widget.onBack,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surface.withOpacity(0.8),
                                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
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
                      ),
                    ),

                    // Upcoming / Past Tab Switcher Area
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: AppColors.background.withOpacity(0.7),
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border.withOpacity(0.5)),
                                ),
                                child: Row(
                                  children: [
                                    _buildTabButton('Upcoming', 'UPCOMING'),
                                    _buildTabButton('Ongoing', 'ONGOING'),
                                    _buildTabButton('Past', 'PAST'),
                                  ],
                                ),
                              ),

                              // Quick Filters
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    _buildDateFilter(),
                                    const Spacer(),
                                    _buildTypeFilter(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(_selectedTripsTab),
        padding: const EdgeInsets.only(top: 170), // Push down below sticky header
        child: _buildListContent(),
      ),
    );
  }

  Widget _buildDateFilter() {
    return _BounceButton(
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
                colorScheme: const ColorScheme.light(
                  primary: AppColors.accent,
                  onSurface: AppColors.textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          setState(() => _selectedStartDate = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _selectedStartDate != null ? AppColors.accent.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedStartDate != null ? AppColors.accent : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_rounded, size: 14, color: _selectedStartDate != null ? AppColors.accent : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              _selectedStartDate != null ? '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}' : 'Date',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _selectedStartDate != null ? AppColors.accent : AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return PopupMenuButton<String>(
      onSelected: (val) => setState(() => _selectedTypeFilter = val),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
      itemBuilder: (context) => [
        _buildPopupItem('All', 'ALL'),
        _buildPopupItem('Public', 'PUBLIC'),
        _buildPopupItem('Private', 'PRIVATE'),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _selectedTypeFilter != 'ALL' ? AppColors.accent.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _selectedTypeFilter != 'ALL' ? AppColors.accent : AppColors.border, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune_rounded, size: 16, color: _selectedTypeFilter != 'ALL' ? AppColors.accent : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              _selectedTypeFilter == 'ALL' ? 'Type' : _selectedTypeFilter,
              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _selectedTypeFilter != 'ALL' ? AppColors.accent : AppColors.textSecondary),
            ),
          ],
        ),
      ),
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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(height: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            ),
          ),
        ),
      );
    }

    if (_bookingsError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.redAccent),
              ),
              const SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                _bookingsError!,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              CommonButton(
                text: 'Try Again',
                onPressed: _fetchBookings,
                width: 160,
              ),
            ],
          ),
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
        } else if (b is PrivateTourBooking && b.departureDate != null) {
          tripDate = DateTime(b.departureDate!.year, b.departureDate!.month,
              b.departureDate!.day);
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
    final now = DateTime.now();
    String countdown;
    if (_selectedTripsTab == 'ONGOING') {
      countdown = 'ONGOING';
    } else {
      final daysUntil = booking.departureDate?.difference(now).inDays;
      countdown = (daysUntil != null && daysUntil > 0) ? '$daysUntil Days' : 'Today';
    }

    Color statusColor;
    switch (booking.status.toUpperCase()) {
      case 'CONFIRMED':
        statusColor = AppColors.textEmerald;
        break;
      case 'PENDING':
        statusColor = AppColors.textOrange;
        break;
      case 'CANCELLED':
        statusColor = Colors.red.shade800;
        break;
      default:
        statusColor = Colors.blue.shade800;
    }

    final pubInfo = '${booking.seats} seat(s)';
    final pubPrice = booking.totalAmount;
    final pubAdditional = pubPrice.isNotEmpty ? '$pubInfo • PKR $pubPrice' : pubInfo;
    return _buildTripCard(
      title: booking.package?.title ?? 'Public Tour',
      provider: booking.company?.name ?? '',
      routeText: (booking.package?.fromLocation != null && booking.package?.toLocation != null)
          ? '${booking.package?.fromLocation} → ${booking.package?.toLocation}'
          : (booking.package?.fromLocation ?? booking.package?.toLocation ?? ''),
      date: booking.departureDate != null && booking.arrivalDate != null
          ? '${_formatDate(booking.departureDate!)} - ${_formatDate(booking.arrivalDate!)}'
          : 'Date TBD',
      countdown: countdown,
      statusColor: statusColor,
      imageUrl: _resolveImageUrl(booking.package?.coverImage),
      onTap: () => Navigator.pushNamed(this.context, '/tripDetails', arguments: {
        'bookingId': booking.id,
        'type': booking.type,
      }),
      additionalInfo: pubAdditional,
    );
  }

  Widget _buildPrivateTourCard(PrivateTourBooking booking) {
    final now = DateTime.now();
    String countdown;
    if (_selectedTripsTab == 'ONGOING') {
      countdown = 'ONGOING';
    } else {
      final daysUntil = booking.departureDate?.difference(now).inDays;
      countdown = (daysUntil != null && daysUntil > 0) ? '$daysUntil Days' : 'Today';
    }

    Color statusColor;
    switch (booking.status.toUpperCase()) {
      case 'CONFIRMED':
      case 'ACCEPTED':
        statusColor = AppColors.textEmerald;
        break;
      case 'PENDING':
        statusColor = AppColors.textOrange;
        break;
      case 'CANCELLED':
      case 'REJECTED':
        statusColor = Colors.red.shade800;
        break;
      default:
        statusColor = Colors.blue.shade800;
    }

    final privCount = booking.seats ?? booking.travelerCount;
    final privPrice = booking.totalPrice ?? booking.totalAmount;
    final privInfo = '$privCount seat(s)';
    final privAdditional = (privPrice != null && privPrice.isNotEmpty) ? '$privInfo • PKR $privPrice' : privInfo;

    return _buildTripCard(
      title: booking.package?.title ?? 'Private Tour',
      provider: booking.company?.name ?? '',
      routeText: (booking.package?.fromLocation != null && booking.package?.toLocation != null)
          ? '${booking.package?.fromLocation} → ${booking.package?.toLocation}'
          : (booking.package?.fromLocation ?? booking.package?.toLocation ?? ''),
      date: booking.departureDate != null && booking.arrivalDate != null
          ? '${_formatDate(booking.departureDate!)} - ${_formatDate(booking.arrivalDate!)}'
          : 'Date TBD',
      countdown: countdown,
      statusColor: statusColor,
      imageUrl: _resolveImageUrl(booking.package?.coverImage),
      onTap: () => Navigator.pushNamed(this.context, '/tripDetails', arguments: {
        'bookingId': booking.id,
        'type': booking.type,
      }),
        additionalInfo: privAdditional,
    );
  }

  Widget _buildTripCard({
    required String title,
    required String provider,
    String? routeText,
    required String date,
    required String countdown,
    required Color statusColor,
    required String imageUrl,
    String? additionalInfo,
    VoidCallback? onTap,
  }) {
    return _BounceButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Immersive Image
            Container(
              width: 90,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.background,
                image: imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: imageUrl.isEmpty ? const Icon(Icons.terrain_rounded, color: AppColors.textSecondary, size: 30) : null,
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: statusColor.withOpacity(0.3))),
                        child: Text(
                          (countdown == 'Today' || countdown == 'ONGOING') ? 'LIVE' : countdown.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                      ),
                    ],
                  ),
                  if (routeText != null && routeText.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      routeText,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    provider,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.background.withOpacity(0.5), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border.withOpacity(0.3))),
                    child: Row(
                      children: [
                        const Icon(Icons.event_available_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

// Reuse the Boing Animation widget
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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