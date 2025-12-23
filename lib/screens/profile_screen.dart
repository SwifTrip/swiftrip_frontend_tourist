import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/user_model.dart';
import '../services/token_service.dart';
import '../services/user_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    
    // Load local user data first
    final localUser = await TokenService.getUser();
    if (localUser != null) {
      setState(() {
        _user = localUser;
        _isLoading = false;
      });
    }

    // Refresh from backend to get most recent info
    if (localUser != null) {
      try {
        final result = await _userService.getUserProfile(localUser.id);
        if (result['success'] == true) {
          final updatedUser = result['user'] as UserModel;
          await TokenService.saveUser(updatedUser);
          if (mounted) {
            setState(() {
              _user = updatedUser;
            });
          }
        }
      } catch (e) {
        debugPrint('Failed to refresh profile: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading && _user == null
            ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
            : Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        children: [
                          _buildProfileHeader(),
                          const SizedBox(height: 32),
                          _buildStatsGrid(),
                          const SizedBox(height: 32),
                          _buildInformationSection(),
                          const SizedBox(height: 24),
                          _buildSettingsSection(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'My Profile',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
            onPressed: () async {
              if (_user == null) return;
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: _user!),
                ),
              );
              if (result == true) {
                _loadProfileData();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.accent, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const CircleAvatar(
                radius: 56,
                backgroundImage: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCzKIJritHt8R1Ry9INksc5nKG9a6qEWeLEHUV8L022NPnTwNpdhB6pxn8q3F_EWRswUVFyGeODfMqoty990Vs0sKlmbyPUgD4FjoETAl4KFRhH57jwlu8VIcQEmg3DV9ZpUFLAv3oKs03QhINDVBHCm63GS1XjHtfUy_sP8rXQlNaONgvqTBqszhO3Zbg9ytU9DmcPQuF5mkeitYRiWAkdJ7abAkozEnYXxF3sMmbmi1W_7kcTPmgfMTvkyxgFFBe1kM0MCMiygCwq',
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _user?.fullName ?? 'Loading...',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _user?.email ?? '',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, color: Colors.blueAccent, size: 14),
              const SizedBox(width: 6),
              Text(
                'Verified Traveler',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('12', 'Trips')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('45', 'Reviews')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('3', 'Upcoming')),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'PERSONAL INFORMATION',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.badge_outlined,
                iconColor: Colors.blue,
                title: 'Contact Details',
                subtitle: 'Phone, email, address',
              ),
              const Divider(height: 1, color: AppColors.border),
              _buildListTile(
                icon: Icons.credit_card,
                iconColor: Colors.green,
                title: 'Payment Methods',
                subtitle: 'Visa ending in 4242',
              ),
              const Divider(height: 1, color: AppColors.border),
              _buildListTile(
                icon: Icons.tune,
                iconColor: Colors.purple,
                title: 'Preferences',
                subtitle: 'Dietary, currency, language',
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'SETTINGS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.settings_outlined,
                iconColor: Colors.grey,
                title: 'App Settings',
                subtitle: 'Notifications, Security',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
      onTap: () {},
      shape: isLast ? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ) : null,
    );
  }
}
