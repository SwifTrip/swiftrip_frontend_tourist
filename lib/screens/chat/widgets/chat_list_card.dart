import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../models/chat_model.dart';
import '../chat_room_screen.dart';

class ChatListCard extends StatelessWidget {
  final ChatRoom room;
  final VoidCallback onReturn;

  const ChatListCard({super.key, required this.room, required this.onReturn});

  @override
  Widget build(BuildContext context) {
    // Generate badge colors
    Color badgeBg = const Color(0xFFD1FAE5); // emerald-100
    Color badgeText = const Color(0xFF047857); // emerald-700
    String displayStatus = room.tourStatus;

    if (['STARTING_SOON', 'PENDING'].contains(room.tourStatus.toUpperCase())) {
      badgeBg = const Color(0xFFFFEDD5); // orange-100
      badgeText = const Color(0xFFC2410C); // orange-700
      if(room.tourStatus.toUpperCase() == 'PENDING') displayStatus = 'STARTING SOON';
    } else if (room.tourStatus.toUpperCase() == 'IN_PROGRESS' || room.tourStatus.toUpperCase() == 'CONFIRMED') {
      badgeBg = const Color(0xFFD1FAE5); // emerald-100
      badgeText = const Color(0xFF047857); // emerald-700
      if(room.tourStatus.toUpperCase() == 'CONFIRMED') displayStatus = 'CONFIRMED';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(room: room),
          ),
        ).then((_) => onReturn()); // Refresh on back
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            // Tour Image Thumbnail
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDLs7lfb9VOU5yniZsEzrmydmGdfJvAgsKbVVu0EFpJySdRgVltuTSv4Osn5qClGELA5Sqawqe0yobsYgDwQFf9T56TmGaX57zI10vz3xWdy93ExDpTv6T5PvKK0tv4ieSqCNrTaWgY0pU_y3RCRyrgdoW21LVFL56CKyCfLgYJk6SgzSdVJtedhjbe_zMDAwx0VZkENocAoyLgrQTpG2Xp3tsPN22QTk67wEhMFFCOc4TmLPEqWgf-SlQzIZYFu589baYMOlXeeknj'), // Sample Image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          room.tourTitle ?? 'Unknown Tour',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          displayStatus.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Guide: ${room.guideName ?? "Unassigned"}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${room.tourIdText} • ${_formatDate(room.createdAt)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
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
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
