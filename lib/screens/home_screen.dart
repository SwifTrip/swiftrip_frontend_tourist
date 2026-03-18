import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'searchTour.dart';
import 'fixed_packages_screen.dart';
import 'guide_list_screen.dart';
import 'signin.dart';
import 'profile_screen.dart';
import 'trips_screen.dart';
import 'chat/chat_hub_screen.dart';
import '../models/user_model.dart';
import '../services/token_service.dart';
import '../services/auth_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  void _onBottomNavTapped(int index) {
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
                          child: Container(color: Colors.black.withOpacity(0.2)),
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
                            painter: TrianglePainter(color: AppColors.surface.withOpacity(0.85)),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                            child: Container(
                              width: 220,
                              decoration: BoxDecoration(
                                color: AppColors.surface.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border.withOpacity(0.5)),
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
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                '${_getTimeBasedGreeting()}, ${_user?.firstName ?? 'Traveler'}!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
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
            child: PageView.builder(
              controller: _pageController,
              itemCount: 4,
              itemBuilder: (context, index) {
                final packages = [
                  {'title': 'Santorini', 'subtitle': 'Greece', 'img': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBJdkqFbopIonmv84lNk92j7slgCuqCA5JRK-XW2YqFNIGQCoQvm-NGt0n7HH2FTdTSp15p8PUHpK-8pVdhcXVTPxi4nmiNwSK557z8TD5AG92sw9CP7UFx757eWYtTrvcfmOSQfsDytLFXw6hAnCe-FEdDE3F1qMo5GCMaoD555arYp-zjaawylfBYszLLfab7UZZvvtKLY8OINgKRE1qapgVlfSnR0VHIVKr5-FNiPVWMp2T1BvtlMb7_ykXpBk639NHrbbKgTAI'},
                  {'title': 'Rome', 'subtitle': 'Italy', 'img': 'https://lh3.googleusercontent.com/aida-public/AB6AXuB3crKlLElKPhJEhQrpF-F2ae_cxNgI1yVoVobxX-wBBuigYk65wamFdpMix0UUCRW-lQQeGjwuAPLXmlte4lQPcWqJui1uLlMRKZroWFmpPh6B7f0loGu79CIYmUc7D1pWB6BEx5cuYyw729EEjUlZZMtYCGWrXv_9k_NvG7FBTjD20mScBFeAOlnssK9yh0tmhYGNvWYNHUxPy_EuuDI7sueu2N1ysJw_iiA6jIQsypItjuKJswcyG1jRfiAbVNVKDAYpiKhe8So'},
                  {'title': 'Kyoto', 'subtitle': 'Japan', 'img': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCW9Wch6_8oLPTNsWAmmljWbYR1q3GqHM06d1dTKF5d_QMkyuAirI0QWkH3kpHQESd_rg2dLUYH6SJ8f7zYYBadPhYGqO0tTouizkKPr4KA5T8V9aKd8rNJzdHLZMzn7lCQtqeGIHYfoxJCQcbYeKC7Ks-2Zw51FMaofVICBJraNE4vF8xeo8f9Z_DqcZx8fi0MOGNWn-6nCrrZ9MrWG4ZDL0dDlHsob8o3-w8L-x3MiR9wX2_1gSMn36Ok9pjxa9dGytmREmEHeb8'},
                  {'title': 'Paris', 'subtitle': 'France', 'img': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDafIA-MVsOlBEe8dt8skOTVlZfanfIGzgkui4eL3xtirNwFtoe-bUaL_BbwJBl8XxOcOLsoMZOgMneEUiRxpgld4eX97aRE88iV7VOYB41yYexXaABFZi_oHU3W5sFgu-sAeTs_LM5WVKzu1PS9do3OQwjczTJgf22yXQ_7p3vets2drbfRGAwFHzvaxIrj74XYDsfJTAvfW1aeECj3dYz7ZyYIXJ3kCluRvRGaohbmNKuYRlPdFrjxYsKjKEcziUw5OCEsxFpn2M'},
                ];
                return _buildTrendingCard(
                  index: index,
                  title: packages[index]['title']!,
                  subtitle: packages[index]['subtitle']!,
                  imageUrl: packages[index]['img']!,
                );
              },
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
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flight_takeoff,
                      size: 40,
                      color: AppColors.accent,
                    ),
                  ),
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
                  Text(
                    'Your upcoming trips will appear here.\nStart exploring tours today!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _BounceButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchTour()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Text('Find a Tour', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        child: _BounceButton(
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
    required int index,
    required String title,
    required String subtitle,
    required String imageUrl,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Parallax Image
                  Transform.translate(
                    offset: Offset(value * 60, 0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
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
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
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
      },
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
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
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
