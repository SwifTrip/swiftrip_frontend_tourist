import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../config/api_config.dart';
import '../widgets/custom_bottom_nav.dart';
import 'fixed_packages_screen.dart';
import 'guide_list_screen.dart';
import 'plan_trip_screen.dart';
import 'signin.dart';
import 'profile_screen.dart';
import 'trips_screen.dart';
import 'chat/chat_hub_screen.dart';
import '../models/user_model.dart';
import '../services/token_service.dart';
import '../services/auth_service.dart';
import '../services/package_service.dart';
import '../services/booking_service.dart';
import '../models/search_result.dart';
import '../models/booking_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swift_trip_app/screens/package_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isProfileOverlayVisible = false;
  UserModel? _user;
  late PageController _pageController;

  final PackageService _packageService = PackageService();
  final BookingService _bookingService = BookingService();

  List<TourPackageResult> _trendingPackages = [];
  bool _isLoadingPackages = true;

  List<dynamic> _upcomingTrips = [];
  bool _isLoadingUpcoming = true;

  Color _accentForIndex(int index, bool isDark) {
    const lightPalette = [
      Color(0xFFEA580C),
      Color(0xFFF97316),
      Color(0xFFFB923C),
      Color(0xFFC2410C),
      Color(0xFFB45309),
    ];
    const darkPalette = [
      Color(0xFFFFA94D),
      Color(0xFFFF922B),
      Color(0xFFFFB566),
      Color(0xFFFF7B22),
      Color(0xFFFFC078),
    ];

    final palette = isDark ? darkPalette : lightPalette;
    return palette[index % palette.length];
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchTrendingPackages();
    _fetchUpcomingTrips();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _resolvePackageImageUrl(String? rawUrl) {
    const fallback = 'https://placehold.co/600x400?text=No+Image';
    if (rawUrl == null || rawUrl.trim().isEmpty) return fallback;

    String url = rawUrl.trim();

    if (url.startsWith('/uploads')) {
      url = '${ApiConfig.chatSocket}$url';
    } else if (url.startsWith('uploads/')) {
      url = '${ApiConfig.chatSocket}/$url';
    } else if (!url.startsWith('http')) {
      url = '${ApiConfig.chatSocket}/${url.replaceFirst(RegExp(r'^/+'), '')}';
    }

    if (kIsWeb && url.startsWith('http')) {
      return '${ApiConfig.chatSocket}/proxy-image?url=${Uri.encodeComponent(url)}';
    }

    return url;
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> _loadUserData() async {
    final user = await TokenService.getUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _navigateToPackageDetails(TourPackageResult pkg) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const CircularProgressIndicator(color: AppColors.accent),
        ),
      ),
    );

    try {
      final response = await _packageService.getPackageDetailsWithItinerary(
        pkg.id,
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (response != null && response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailsScreen(
              travelers: 1,
              isPublic: pkg.isPublic,
              customizeItinerary: response.data,
              fixedStartDate: pkg.nextDeparture != null
                  ? DateTime.parse(pkg.nextDeparture!['departureDate'])
                  : null,
              publicScheduleId: pkg.nextDeparture != null
                  ? pkg.nextDeparture!['id']
                  : null,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load package details')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading package: ${e.toString()}')),
        );
      }
    }
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Where to?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: const TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search destinations...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: AppColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Popular Categories',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildSearchChip('Mountains'),
                  _buildSearchChip('Historical'),
                  _buildSearchChip('Family'),
                  _buildSearchChip('Adventure'),
                  _buildSearchChip('Cultural'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _fetchTrendingPackages() async {
    setState(() => _isLoadingPackages = true);
    try {
      final result = await _packageService.getTrendingPackages(limit: 8);

      if (mounted) {
        if (result != null && result.data.isNotEmpty) {
          setState(() {
            _trendingPackages = result.data;
            _isLoadingPackages = false;
          });
          return;
        }

        // Fallback for environments where trending endpoint may not be available yet.
        final fallback = await _packageService.searchPackages(
          tourType: 'PUBLIC',
        );
        if (fallback != null && fallback.data.isNotEmpty) {
          setState(() {
            _trendingPackages = fallback.data.take(5).toList();
            _isLoadingPackages = false;
          });
          return;
        }

        // Final fallback: fetch all active packages and prefer public ones.
        final broadFallback = await _packageService.searchPackages();
        final preferred =
            broadFallback?.data.where((pkg) => pkg.isPublic).toList() ?? [];

        setState(() {
          _trendingPackages = preferred.isNotEmpty
              ? preferred.take(5).toList()
              : (broadFallback?.data.take(5).toList() ?? []);
          _isLoadingPackages = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingPackages = false);
    }
  }

  Future<void> _fetchUpcomingTrips() async {
    setState(() => _isLoadingUpcoming = true);
    try {
      final ongoingResponse = await _bookingService.getUserBookings(
        when: 'ONGOING',
      );
      final upcomingResponse = await _bookingService.getUserBookings(
        when: 'UPCOMING',
      );

      List<dynamic> combined = [];
      if (ongoingResponse != null && ongoingResponse.success) {
        combined.addAll(ongoingResponse.data.getAllBookings());
      }
      if (upcomingResponse != null && upcomingResponse.success) {
        combined.addAll(upcomingResponse.data.getAllBookings());
      }

      if (mounted) {
        setState(() {
          _upcomingTrips = combined;
          _isLoadingUpcoming = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingUpcoming = false);
    }
  }

  void _onBottomNavTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PlanTripScreen(initialIsPublic: true),
        ),
      );
      return;
    }

    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Social events are coming soon.')),
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_currentIndex) {
      case 4:
        content = TripsScreen(
          key: const ValueKey('trips'),
          onBack: () => setState(() => _currentIndex = 0),
        );
        break;
      case 3:
        content = ChatHubScreen(
          key: const ValueKey('chats'),
          onExplore: () => setState(() => _currentIndex = 0),
        );
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
            AnimatedOpacity(
              opacity: _isProfileOverlayVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: _isProfileOverlayVisible
                  ? Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isProfileOverlayVisible = false;
                          });
                        },
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Profile Overlay Card
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              top: _isProfileOverlayVisible ? 60 : 40,
              right: 16,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isProfileOverlayVisible ? 1.0 : 0.0,
                child: _isProfileOverlayVisible
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Triangle
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: CustomPaint(
                              size: const Size(20, 10),
                              painter: TrianglePainter(
                                color: AppColors.surface.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 15.0,
                                sigmaY: 15.0,
                              ),
                              child: Container(
                                width: 220,
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(
                                    alpha: 0.85,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.border.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                child: _user != null
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Signed in as',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _user?.email ?? 'Loading...',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            onTap: () async {
                                              setState(() {
                                                _isProfileOverlayVisible =
                                                    false;
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
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            onTap: () async {
                                              setState(() {
                                                _isProfileOverlayVisible =
                                                    false;
                                              });

                                              // Clear token and user data
                                              await TokenService.removeToken();
                                              await TokenService.removeUser();

                                              // Call backend logout endpoint
                                              final authService = AuthService();
                                              await authService.logout();

                                              if (context.mounted) {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Signin(),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Not signed in',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Login to continue',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .textPrimary,
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
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: AppColors.accent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _isProfileOverlayVisible =
                                                    false;
                                              });
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Signin(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headlineColor = isDark ? Colors.white : AppColors.textPrimary;
    final mutedColor = isDark
        ? Colors.white.withValues(alpha: 0.75)
        : AppColors.textSecondary;
    final surfaceColor = isDark ? const Color(0xFF1B283D) : AppColors.surface;
    final borderColor = isDark ? const Color(0xFF334155) : AppColors.border;
    final heroGradients = isDark
        ? const [Color(0xFF4A1D0D), Color(0xFF7C2D12), Color(0xFF9A3412)]
        : const [Color(0xFFFFEDD5), Color(0xFFFFF7ED), Color(0xFFFFE4CC)];

    final List<Map<String, dynamic>> moments = [
      {
        'name': 'Sara',
        'place': 'Hunza Vibes',
        'icon': Icons.landscape_rounded,
        'tone': 0,
      },
      {
        'name': 'Hamza',
        'place': 'Skardu Sunset',
        'icon': Icons.wb_twilight_rounded,
        'tone': 1,
      },
      {
        'name': 'Aina',
        'place': 'Murree Trail',
        'icon': Icons.terrain_rounded,
        'tone': 2,
      },
      {
        'name': 'Rayan',
        'place': 'Neelum Camp',
        'icon': Icons.local_fire_department_rounded,
        'tone': 3,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 104),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: isDark ? 0.14 : 0.82),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white24 : AppColors.border,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'lib/assets/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SwifTrip',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: headlineColor,
                        ),
                      ),
                      Text(
                        'Explore | Plan your next trip',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: mutedColor,
                        ),
                      ),
                    ],
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFFFFA94D), const Color(0xFFFF922B)]
                            : [
                                const Color(0xFFEA580C),
                                const Color(0xFFF97316),
                              ],
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

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: heroGradients,
                ),
                border: Border.all(color: borderColor.withValues(alpha: 0.65)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getTimeBasedGreeting()}, ${_user?.firstName ?? 'Traveler'}!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: headlineColor,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your travel social feed is live. Plan with AI and share moments instantly.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: mutedColor,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildStatPill(
                        icon: Icons.local_fire_department_rounded,
                        label: 'Trending',
                        value: _trendingPackages.length.toString(),
                        accentColor: _accentForIndex(0, isDark),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _buildStatPill(
                        icon: Icons.card_travel_rounded,
                        label: 'Trips',
                        value: _upcomingTrips.length.toString(),
                        accentColor: _accentForIndex(1, isDark),
                        isDark: isDark,
                      ),
                      const Spacer(),
                      _BounceButton(
                        onTap: _openAiPlannerSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'AI Plan',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Search + quick AI
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showSearchModal(context),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.16 : 0.05,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(Icons.search, color: mutedColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Search destinations, people, stories...',
                              style: GoogleFonts.plusJakartaSans(
                                color: mutedColor,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _BounceButton(
                  onTap: () => _openAiPlannerSheet(
                    initialPrompt:
                        '3-day budget-friendly itinerary near mountains',
                  ),
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Community moments
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Community Moments',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: headlineColor,
                  ),
                ),
                Text(
                  'Share yours',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOrange,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 96,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: moments.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = moments[index];
                return _buildMomentCard(
                  icon: item['icon'] as IconData,
                  name: item['name']!,
                  place: item['place']!,
                  accentColor: _accentForIndex(item['tone'] as int, isDark),
                  isDark: isDark,
                );
              },
            ),
          ),

          // AI assistant strip
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.smart_toy_rounded,
                        size: 18,
                        color: _accentForIndex(2, isDark),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SwifTrip AI Concierge',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          color: headlineColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ask for itineraries, budget splits, packing lists, and route suggestions.',
                    style: GoogleFonts.plusJakartaSans(
                      color: mutedColor,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildAiQuickChip(
                        'Weekend escape',
                        isDark,
                        icon: Icons.bedtime_rounded,
                        color: _accentForIndex(0, isDark),
                      ),
                      _buildAiQuickChip(
                        'Family with kids',
                        isDark,
                        icon: Icons.family_restroom_rounded,
                        color: _accentForIndex(1, isDark),
                      ),
                      _buildAiQuickChip(
                        'Adventure + food',
                        isDark,
                        icon: Icons.ramen_dining_rounded,
                        color: _accentForIndex(2, isDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Categories
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryItem(
                  icon: Icons.edit_note,
                  label: 'Custom Tour',
                  accentColor: _accentForIndex(0, isDark),
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PlanTripScreen(initialIsPublic: false),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildCategoryItem(
                  icon: Icons.explore_outlined,
                  label: 'Fixed Packages',
                  accentColor: _accentForIndex(3, isDark),
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
                  accentColor: _accentForIndex(4, isDark),
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
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending Packages',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: headlineColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Trending Packages List
          SizedBox(
            height: 224,
            child: _isLoadingPackages
                ? _buildTrendingShimmer()
                : _trendingPackages.isEmpty
                ? _buildEmptyTrendingState()
                : PageView.builder(
                    controller: _pageController,
                    itemCount: _trendingPackages.length,
                    itemBuilder: (context, index) {
                      final pkg = _trendingPackages[index];
                      return _buildTrendingCard(
                        index: index,
                        pkg: pkg,
                        onTap: () => _navigateToPackageDetails(pkg),
                      );
                    },
                  ),
          ),
          _buildTrendingIndicators(isDark),

          // Upcoming Trips Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 12),
            child: Text(
              'My Current Trips',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: headlineColor,
              ),
            ),
          ),

          // Upcoming Trips List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _isLoadingUpcoming
                ? _buildUpcomingShimmer()
                : _upcomingTrips.isEmpty
                ? _buildEmptyTripsState()
                : Column(
                    children: _upcomingTrips
                        .map(
                          (trip) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildUpcomingTripCard(booking: trip),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required String value,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isDark ? 0.22 : 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.34 : 0.26),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: accentColor),
          const SizedBox(width: 6),
          Text(
            '$label $value',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentCard({
    required IconData icon,
    required String name,
    required String place,
    required Color accentColor,
    required bool isDark,
  }) {
    return _BounceButton(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name shared a new moment from $place'),
            duration: const Duration(milliseconds: 1200),
          ),
        );
      },
      child: Container(
        width: 132,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B283D) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accentColor.withValues(alpha: isDark ? 0.38 : 0.28),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: accentColor),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              place,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.72)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiQuickChip(
    String prompt,
    bool isDark, {
    required IconData icon,
    required Color color,
  }) {
    return _BounceButton(
      onTap: () => _openAiPlannerSheet(initialPrompt: prompt),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.2 : 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.45 : 0.28),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
            Text(
              prompt,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAiPlannerSheet({String initialPrompt = ''}) {
    final controller = TextEditingController(text: initialPrompt);
    String? generatedPlan;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.72,
              maxChildSize: 0.92,
              minChildSize: 0.58,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white30 : Colors.black12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.primaryOrange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI Itinerary Creator',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tell AI your vibe, budget, duration, and interests.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: controller,
                        maxLines: 4,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Example: 4-day social + food trip in northern areas under 80k budget',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF1B283D)
                              : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            [
                                  'Nature + photography',
                                  'Family friendly',
                                  'Luxury + chill',
                                  'Adventure packed',
                                ]
                                .map(
                                  (chip) => _BounceButton(
                                    onTap: () {
                                      controller.text = chip;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Text(
                                        chip,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: isDark
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 14),
                      _BounceButton(
                        onTap: () {
                          final prompt = controller.text.trim();
                          if (prompt.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please describe your desired trip.',
                                ),
                              ),
                            );
                            return;
                          }
                          setModalState(() {
                            generatedPlan =
                                'AI Suggestion:\n- Day 1: Local cultural walk + cafe hopping\n- Day 2: Nature excursion + sunset viewpoint\n- Day 3: Adventure activity + social nightlife\n\nTip: Open Custom Tour to personalize this plan fully.';
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: AppColors.premiumActionGradient,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Generate My Itinerary',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (generatedPlan != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1B283D)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            generatedPlan!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              height: 1.45,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.92)
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _BounceButton(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                builder: (context) => const PlanTripScreen(
                                  initialIsPublic: false,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : const Color(0xFFFFEDD5),
                            ),
                            child: Center(
                              child: Text(
                                'Continue in Custom Tour',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textOrange,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required Color accentColor,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: _BounceButton(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isActive
                  ? accentColor
                  : accentColor.withValues(alpha: isDark ? 0.16 : 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? accentColor
                    : accentColor.withValues(alpha: isDark ? 0.4 : 0.24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
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
                  color: isActive ? Colors.white : accentColor,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isActive
                        ? Colors.white
                        : (isDark ? Colors.white : AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingIndicators(bool isDark) {
    if (_isLoadingPackages || _trendingPackages.length <= 1) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, _) {
          final current = _pageController.hasClients
              ? (_pageController.page ?? 0.0)
              : 0.0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_trendingPackages.length, (index) {
              final distance = (current - index).abs();
              final isActive = distance < 0.5;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 7,
                width: isActive ? 20 : 7,
                decoration: BoxDecoration(
                  color: isActive
                      ? _accentForIndex(index, isDark)
                      : (isDark ? Colors.white30 : Colors.black26),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildTrendingCard({
    required int index,
    required TourPackageResult pkg,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
        }
        return Transform.scale(
          scale: 1 - (value.abs() * 0.05).clamp(0.0, 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: _BounceButton(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Parallax Image
                    Hero(
                      tag: 'package_${pkg.id}',
                      child: Transform.translate(
                        offset: Offset(value * 60, 0),
                        child: Image.network(
                          _resolvePackageImageUrl(pkg.coverImage),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: AppColors.surface,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: AppColors.textSecondary,
                                    size: 40,
                                  ),
                                ),
                              ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                    // Text Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pkg.title,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${pkg.duration} Days | ${pkg.currency} ${pkg.basePrice}',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: PageView.builder(
        // Removed controller to prevent "ScrollController attached to multiple scroll views" error
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTrendingState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.travel_explore_rounded,
              size: 34,
              color: AppColors.accent,
            ),
            const SizedBox(height: 10),
            Text(
              'No trending packages right now',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pull to refresh or check again after agencies publish schedules.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            _BounceButton(
              onTap: _fetchTrendingPackages,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Reload',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          2,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTripsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flight_takeoff, size: 40, color: AppColors.accent),
          const SizedBox(height: 16),
          Text(
            'No incoming adventures',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your upcoming trips will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          _BounceButton(
            onTap: () => setState(() => _currentIndex = 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Find a Tour',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTripCard({required dynamic booking}) {
    String title = "Tour";
    String date = "Date TBD";
    String imageUrl = "";
    String type = "PRIVATE";

    final now = DateTime.now();
    bool isOngoing = false;

    if (booking is PublicTourBooking) {
      title = booking.package?.title ?? "Public Tour";
      date = booking.departureDate != null
          ? "${booking.departureDate!.day}/${booking.departureDate!.month}/${booking.departureDate!.year}"
          : "TBD";
      imageUrl = booking.package?.coverImage ?? "";
      type = "PUBLIC";

      if (booking.departureDate != null && booking.arrivalDate != null) {
        isOngoing =
            now.isAfter(booking.departureDate!) &&
            now.isBefore(booking.arrivalDate!);
      }
    } else if (booking is PrivateTourBooking) {
      title = booking.package?.title ?? "Private Tour";
      date = booking.departureDate != null
          ? "${booking.departureDate!.day}/${booking.departureDate!.month}/${booking.departureDate!.year}"
          : "TBD";
      imageUrl = booking.package?.coverImage ?? "";
      type = "PRIVATE";

      if (booking.departureDate != null && booking.arrivalDate != null) {
        isOngoing =
            now.isAfter(booking.departureDate!) &&
            now.isBefore(booking.arrivalDate!);
      }
    }

    return _BounceButton(
      onTap: () => Navigator.pushNamed(
        context,
        '/tripDetails',
        arguments: {'bookingId': booking.id, 'type': type},
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 64,
                        height: 64,
                        color: AppColors.background,
                        child: const Icon(
                          Icons.broken_image_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: AppColors.background,
                      child: const Icon(
                        Icons.landscape,
                        color: AppColors.textSecondary,
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
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_note_rounded,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          date,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (isOngoing
                                      ? Colors.redAccent
                                      : AppColors.textEmerald)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color:
                                (isOngoing
                                        ? Colors.redAccent
                                        : AppColors.textEmerald)
                                    .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          isOngoing ? 'LIVE' : 'CONFIRMED',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isOngoing
                                ? Colors.redAccent
                                : AppColors.textEmerald,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
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

class _BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _BounceButton({required this.child, this.onTap});

  @override
  State<_BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<_BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.93,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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
