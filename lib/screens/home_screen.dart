import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'searchTour.dart';
import 'fixed_packages_screen.dart';
import 'guide_list_screen.dart';
import 'Signin.dart';
import 'profile_screen.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import '../services/token_service.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedTripTab = 0; // 0: Upcoming, 1: Current, 2: Previous
  bool _isProfileOverlayVisible = false;
  UserModel? _user;
  BookingsData? _bookingsData;
  bool _isLoadingBookings = false;
  String? _bookingsError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await TokenService.getUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Load bookings when user navigates to trips tab
    if (index == 4 && _bookingsData == null && !_isLoadingBookings) {
      _fetchBookings();
    }
  }

  Future<void> _fetchBookings() async {
    if (_isLoadingBookings) return;

    setState(() {
      _isLoadingBookings = true;
      _bookingsError = null;
    });

    try {
      final bookingService = BookingService();
      final response = await bookingService.getUserBookings();

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
    Widget content;
    switch (_currentIndex) {
      case 4:
        content = _buildTripsContent();
        break;
      case 0:
      default:
        content = _buildExploreContent();
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            content,
            // Profile Overlay Backdrop
            if (_isProfileOverlayVisible == true)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isProfileOverlayVisible = false;
                    });
                  },
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),

            // Profile Overlay Card
            if (_isProfileOverlayVisible == true)
              Positioned(
                top: 60,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Triangle
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: CustomPaint(
                        size: const Size(20, 10),
                        painter: TrianglePainter(color: AppColors.surface),
                      ),
                    ),
                    Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: AppColors.border),
                      ),
                      child: _user != null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Signed in as',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _user?.email ?? 'Loading...',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.border,
                                ),
                                ListTile(
                                  dense: true,
                                  title: Text(
                                    'Profile',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      _isProfileOverlayVisible = false;
                                    });
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfileScreen(),
                                      ),
                                    );
                                    _loadUserData();
                                  },
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.border,
                                ),
                                ListTile(
                                  dense: true,
                                  title: Text(
                                    'Logout',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      _isProfileOverlayVisible = false;
                                    });

                                    // Clear token and user data
                                    await TokenService.removeToken();
                                    await TokenService.removeUser();

                                    // Call backend logout endpoint
                                    final authService = AuthService();
                                    await authService.logout();

                                    if (context.mounted) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const Signin(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Not signed in',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Login to continue',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.border,
                                ),
                                ListTile(
                                  dense: true,
                                  title: Text(
                                    'Login',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isProfileOverlayVisible = false;
                                    });
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const Signin(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),

            // Custom Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNav(
                currentIndex: _currentIndex,
                onTap: _onBottomNavTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar / Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.explore, size: 30, color: AppColors.accent),
                Expanded(
                  child: Text(
                    'SwiftTrip',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isProfileOverlayVisible = !(_isProfileOverlayVisible);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.tealAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCzKIJritHt8R1Ry9INksc5nKG9a6qEWeLEHUV8L022NPnTwNpdhB6pxn8q3F_EWRswUVFyGeODfMqoty990Vs0sKlmbyPUgD4FjoETAl4KFRhH57jwlu8VIcQEmg3DV9ZpUFLAv3oKs03QhINDVBHCm63GS1XjHtfUy_sP8rXQlNaONgvqTBqszhO3Zbg9ytU9DmcPQuF5mkeitYRiWAkdJ7abAkozEnYXxF3sMmbmi1W_7kcTPmgfMTvkyxgFFBe1kM0MCMiygCwq',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Greeting
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'Good morning, ${_user?.firstName ?? 'Traveler'}!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Where to?',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),

          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryItem(
                  icon: Icons.edit_note,
                  label: 'Custom Tour',
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchTour(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildCategoryItem(
                  icon: Icons.explore_outlined,
                  label: 'Fixed Packages',
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FixedPackagesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildCategoryItem(
                  icon: Icons.person_pin_circle_outlined,
                  label: 'Hire a Guide',
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GuideListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Trending Packages Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending Packages',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Trending Packages List
          SizedBox(
            height: 224,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _buildTrendingCard(
                  title: 'Santorini',
                  subtitle: 'Greece',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBJdkqFbopIonmv84lNk92j7slgCuqCA5JRK-XW2YqFNIGQCoQvm-NGt0n7HH2FTdTSp15p8PUHpK-8pVdhcXVTPxi4nmiNwSK557z8TD5AG92sw9CP7UFx757eWYtTrvcfmOSQfsDytLFXw6hAnCe-FEdDE3F1qMo5GCMaoD555arYp-zjaawylfBYszLLfab7UZZvvtKLY8OINgKRE1qapgVlfSnR0VHIVKr5-FNiPVWMp2T1BvtlMb7_ykXpBk639NHrbbKgTAI',
                ),
                const SizedBox(width: 16),
                _buildTrendingCard(
                  title: 'Rome',
                  subtitle: 'Italy',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB3crKlLElKPhJEhQrpF-F2ae_cxNgI1yVoVobxX-wBBuigYk65wamFdpMix0UUCRW-lQQeGjwuAPLXmlte4lQPcWqJui1uLlMRKZroWFmpPh6B7f0loGu79CIYmUc7D1pWB6BEx5cuYyw729EEjUlZZMtYCGWrXv_9k_NvG7FBTjD20mScBFeAOlnssK9yh0tmhYGNvWYNHUxPy_EuuDI7sueu2N1ysJw_iiA6jIQsypItjuKJswcyG1jRfiAbVNVKDAYpiKhe8So',
                ),
                const SizedBox(width: 16),
                _buildTrendingCard(
                  title: 'Kyoto',
                  subtitle: 'Japan',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCW9Wch6_8oLPTNsWAmmljWbYR1q3GqHM06d1dTKF5d_QMkyuAirI0QWkH3kpHQESd_rg2dLUYH6SJ8f7zYYBadPhYGqO0tTouizkKPr4KA5T8V9aKd8rNJzdHLZMzn7lCQtqeGIHYfoxJCQcbYeKC7Ks-2Zw51FMaofVICBJraNE4vF8xeo8f9Z_DqcZx8fi0MOGNWn-6nCrrZ9MrWG4ZDL0dDlHsob8o3-w8L-x3MiR9wX2_1gSMn36Ok9pjxa9dGytmREmEHeb8',
                ),
                const SizedBox(width: 16),
                _buildTrendingCard(
                  title: 'Paris',
                  subtitle: 'France',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDafIA-MVsOlBEe8dt8skOTVlZfanfIGzgkui4eL3xtirNwFtoe-bUaL_BbwJBl8XxOcOLsoMZOgMneEUiRxpgld4eX97aRE88iV7VOYB41yYexXaABFZi_oHU3W5sFgu-sAeTs_LM5WVKzu1PS9do3OQwjczTJgf22yXQ_7p3vets2drbfRGAwFHzvaxIrj74XYDsfJTAvfW1aeECj3dYz7ZyYIXJ3kCluRvRGaohbmNKuYRlPdFrjxYsKjKEcziUw5OCEsxFpn2M',
                ),
              ],
            ),
          ),

          // Upcoming Trips Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
            child: Text(
              'My Upcoming Trips',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Upcoming Trips List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildUpcomingTripCard(
                  title: 'Adventure in the Alps',
                  date: 'Sep 15 - Sep 22, 2024',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD3v-eQ0bCf7AUA2yHx5z7vx97CP8VtbiJpcuNL3sk2X0Qju0GZ5z67d-jsbDXC27uizBSJnxB05l47amJtOBgPX5Ly1ZFDKZxzuGjUDgsWWLcUQgGJg-Q9qTYE6UEkaCHPdv-2fnGQpCIrSB8Rpy5tPxGeJigHQm__PAP3E1bdMY-SNzpKO_OOzwY6wyUHl1QTnp-tbp6CmKDe7KWTsAZ1uBbg6H6sVO7FsGPY6VamL5m3lOJ5b9-znjmrgmCdg9kIQpvjufQiVDw',
                ),
                const SizedBox(height: 12),
                _buildUpcomingTripCard(
                  title: 'Bali Beach Retreat',
                  date: 'Nov 01 - Nov 08, 2024',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAmyJq2tgg9i4YHCjmJY8cKiJPm7N-d4bYpvisZD1LE-qyVHVgm-Ixtoc91-PLQA86xp9nup98PtQYynYvIwOQi1GEI4x5JsZIT9ToyFdCxKk1s16EC02aZZeBvYMOQ70A0dThQaetf93ippgYO3BJ2L0VF6RIiVzGrO18nqjgS0Rt2xOaOPoDjgEz7FHLWtNy2zoHqTT3SJt1mANE_IvWWxZc_CjJbSEc_Bz80-qS6K3WpjlY00xX9BbkdQwsnpTnw6Iqv7-SPAos',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripsContent() {
    return Column(
      children: [
        // Sticky Header
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
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
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
              const SizedBox(width: 40), // Balance the back button
            ],
          ),
        ),

        // Tab Selector
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTripTabItem('Upcoming', 0),
                _buildTripTabItem('Current', 1),
                _buildTripTabItem('Previous', 2),
              ],
            ),
          ),
        ),

        // Trips List
        Expanded(child: _buildTripsListContent()),
      ],
    );
  }

  Widget _buildTripCard({
    required String title,
    required String provider,
    required String date,
    required String countdown,
    required String status,
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
          // Trip Image
          Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.background,
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? const Icon(
                    Icons.landscape,
                    color: AppColors.textSecondary,
                    size: 40,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Trip Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
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
                        Text(
                          'DATE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          date,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'STARTS IN',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          countdown,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
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

  Widget _buildTripsListContent() {
    // Show loading indicator
    if (_isLoadingBookings) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    // Show error message
    if (_bookingsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              _bookingsError!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchBookings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // No bookings data
    if (_bookingsData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.luggage_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring and book your first trip!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Filter bookings based on selected tab
    final filteredBookings = _getFilteredBookings();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${_getTabLabel()} trips',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchBookings,
      color: AppColors.accent,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 8 : 0, bottom: 16),
            child: _buildBookingCard(booking),
          );
        },
      ),
    );
  }

  String _getTabLabel() {
    switch (_selectedTripTab) {
      case 0:
        return 'upcoming';
      case 1:
        return 'current';
      case 2:
        return 'previous';
      default:
        return '';
    }
  }

  List<dynamic> _getFilteredBookings() {
    if (_bookingsData == null) return [];

    final now = DateTime.now();
    final allBookings = _bookingsData!.getAllBookings();

    return allBookings.where((booking) {
      DateTime? startDate;
      DateTime? endDate;

      if (booking is PublicTourBooking) {
        startDate = booking.departureDate;
        endDate = booking.arrivalDate;
      } else if (booking is PrivateTourBooking) {
        startDate = booking.startDate;
        endDate = booking.endDate;
      }

      if (startDate == null || endDate == null) return false;

      // Filter by tab
      switch (_selectedTripTab) {
        case 0: // Upcoming
          return startDate.isAfter(now);
        case 1: // Current
          return startDate.isBefore(now) && endDate.isAfter(now);
        case 2: // Previous
          return endDate.isBefore(now);
        default:
          return false;
      }
    }).toList();
  }

  Widget _buildBookingCard(dynamic booking) {
    if (booking is PublicTourBooking) {
      return _buildPublicTourCard(booking);
    } else if (booking is PrivateTourBooking) {
      return _buildPrivateTourCard(booking);
    }
    return const SizedBox.shrink();
  }

  Widget _buildPublicTourCard(PublicTourBooking booking) {
    final daysUntil = booking.departureDate.difference(DateTime.now()).inDays;
    final countdown = daysUntil > 0 ? '$daysUntil Days' : 'Today';

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
      title: booking.package.title,
      provider: booking.company.name,
      date:
          '${_formatDate(booking.departureDate)} - ${_formatDate(booking.arrivalDate)}',
      countdown: countdown,
      status: booking.status,
      statusColor: statusColor,
      imageUrl: booking.package.coverImage ?? '',
      additionalInfo: '${booking.seats} seat(s) • PKR ${booking.totalAmount}',
    );
  }

  Widget _buildPrivateTourCard(PrivateTourBooking booking) {
    final daysUntil = booking.startDate.difference(DateTime.now()).inDays;
    final countdown = daysUntil > 0 ? '$daysUntil Days' : 'Today';

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
      provider: booking.company.name,
      date:
          '${_formatDate(booking.startDate)} - ${_formatDate(booking.endDate)}',
      countdown: countdown,
      status: booking.status,
      statusColor: statusColor,
      imageUrl: '',
      additionalInfo:
          '${booking.travelerCount} traveler(s)${booking.totalPrice != null ? ' • PKR ${booking.totalPrice}' : ''}',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  Widget _buildTripTabItem(String label, int index) {
    final bool isActive = _selectedTripTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTripTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isActive ? AppColors.accent : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isActive ? Colors.white : AppColors.textPrimary,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isActive ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingCard({
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return Container(
      width: 160, // w-40
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
            stops: const [0.6, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTripCard({
    required String title,
    required String date,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
