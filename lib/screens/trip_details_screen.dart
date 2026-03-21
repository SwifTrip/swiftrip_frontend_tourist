import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import 'package:shimmer/shimmer.dart';

class TripDetailsScreen extends StatefulWidget {
  final int bookingId;
  final String type;

  const TripDetailsScreen({
    super.key,
    required this.bookingId,
    required this.type,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final BookingService _bookingService = BookingService();
  dynamic _booking;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails();
  }

  Future<void> _fetchBookingDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _bookingService.getBookingDetails(widget.bookingId, widget.type);
      if (mounted) {
        setState(() {
          _booking = data;
          _isLoading = false;
          if (_booking == null) {
            _error = "Trip details not found";
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = "Error: ${e.toString()}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _isLoading 
              ? _buildShimmerLoading() 
              : _error != null 
                  ? _buildErrorState() 
                  : _buildMainContent(),
          
          // Custom Back Button (Floating)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final title = _booking is PublicTourBooking 
        ? _booking.package?.title ?? "Public Tour" 
        : _booking.package?.title ?? "Private Tour";
    
    final imageUrl = _booking is PublicTourBooking 
        ? _booking.package?.coverImage ?? "" 
        : _booking.package?.coverImage ?? "";
    
    final date = _booking.departureDate != null 
        ? "${_booking.departureDate!.day}/${_booking.departureDate!.month}/${_booking.departureDate!.year}" 
        : "Date TBD";
    
    final status = _booking.status.toUpperCase();
    final company = _booking.company?.name ?? "SwifTrip Partner";

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Hero Image Header
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Hero(
                tag: 'trip_${widget.bookingId}',
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 400,
                          color: AppColors.surface,
                          child: const Center(child: Icon(Icons.broken_image, size: 50, color: AppColors.textSecondary)),
                        ),
                      )
                    : Container(
                        height: 400,
                        color: AppColors.surface,
                        child: const Center(child: Icon(Icons.landscape, size: 50, color: AppColors.textSecondary)),
                      ),
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                      AppColors.background.withOpacity(0.8),
                      AppColors.background,
                    ],
                    stops: const [0.0, 0.5, 0.9, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent.withOpacity(0.5)),
                      ),
                      child: Text(
                        widget.type,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Body Content
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              _buildStatusCard(status, company),
              const SizedBox(height: 24),
              _buildDetailsGrid(date),
              const SizedBox(height: 32),
              _buildSectionTitle("Itinerary Overview"),
              const SizedBox(height: 16),
              _buildItinerarySummary(),
              const SizedBox(height: 100), // Space for bottom actions
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String status, String company) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.textEmerald.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user_rounded, color: AppColors.textEmerald, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textEmerald,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Provided by $company",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(String date) {
    return Row(
      children: [
        _buildInfoItem(Icons.calendar_today_rounded, "Date", date),
        const SizedBox(width: 16),
        _buildInfoItem(Icons.confirmation_num_rounded, "Booking ID", "#${widget.bookingId}"),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accent, size: 20),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildItinerarySummary() {
    // If we had itinerary details in the booking model, we'd loop through them here.
    // For now, we'll show a high-level summary.
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildItineraryRow("1", "Arrival & Hotel Check-in", true),
          _buildItineraryRow("2", "Full Day Sightseeing", false),
          _buildItineraryRow("3", "Departure", false),
        ],
      ),
    );
  }

  Widget _buildItineraryRow(String day, String title, bool isFirst) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isFirst ? AppColors.accent : AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isFirst ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (day != "3")
                Container(width: 2, height: 20, color: AppColors.border),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(height: 400, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))))),
                    const SizedBox(width: 16),
                    Expanded(child: Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
          const SizedBox(height: 24),
          Text(_error!, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _fetchBookingDetails,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }
}
