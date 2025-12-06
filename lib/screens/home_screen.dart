
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'searchTour.dart';
import 'fixed_packages_screen.dart';
import 'guide_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar / Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.explore, size: 30, color: AppColors.accent), // Orange icon
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
                          Container(
                            width: 48,
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.notifications_outlined, size: 28),
                              color: AppColors.textPrimary,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Greeting
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Text(
                        'Good morning, Alex!',
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
                          color: AppColors.surface, // Forest Green
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.search,
                                color: AppColors.textSecondary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Where to?',
                                  hintStyle:
                                      TextStyle(color: AppColors.textSecondary, fontSize: 16),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                style: const TextStyle(
                                    color: AppColors.textPrimary, fontSize: 16),
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
                                color: AppColors.accent, // Orange
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Trending Packages List
                    SizedBox(
                      height: 224, // h-56
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

  Widget _buildCategoryItem(
      {required IconData icon,
      required String label,
      required bool isActive,
      VoidCallback? onTap}) {
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
                  color: isActive ? AppColors.textPrimary : AppColors.textPrimary,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isActive ? AppColors.textPrimary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingCard(
      {required String title,
      required String subtitle,
      required String imageUrl}) {
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
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.6),
            ],
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

  Widget _buildUpcomingTripCard(
      {required String title, required String date, required String imageUrl}) {
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
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
