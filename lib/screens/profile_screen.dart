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
                          _buildInformationSection(),
                          const SizedBox(height: 24),
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
                backgroundColor: AppColors.surface,
                child: Icon(
                  Icons.face_rounded,
                  color: AppColors.textPrimary,
                  size: 56,
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
      ],
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
