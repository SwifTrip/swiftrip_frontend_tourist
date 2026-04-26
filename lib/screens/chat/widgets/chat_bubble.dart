import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../models/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final String? guideAvatar;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.guideAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.border,
              backgroundImage: guideAvatar != null
                  ? NetworkImage(guideAvatar!)
                  : const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCzKIJritHt8R1Ry9INksc5nKG9a6qEWeLEHUV8L022NPnTwNpdhB6pxn8q3F_EWRswUVFyGeODfMqoty990Vs0sKlmbyPUgD4FjoETAl4KFRhH57jwlu8VIcQEmg3DV9ZpUFLAv3oKs03QhINDVBHCm63GS1XjHtfUy_sP8rXQlNaONgvqTBqszhO3Zbg9ytU9DmcPQuF5mkeitYRiWAkdJ7abAkozEnYXxF3sMmbmi1W_7kcTPmgfMTvkyxgFFBe1kM0MCMiygCwq'),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && message.isAiGenerated) ...[
                  Container(
                    margin: const EdgeInsets.only(left: 4, bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.deepPurple.withOpacity(0.18)),
                    ),
                    child: Text(
                      'AI',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.accent : AppColors.surface,
                    border: isMe ? null : Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isMe ? 0.1 : 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(message.createdAt),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (isMe) ...[
                        _buildStatusIcon(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isMe) const SizedBox(width: 24), // Balance spacing with avatar side
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    final bool isTemp = message.id.startsWith('temp_');
    
    if (isTemp) {
      return Icon(
        Icons.access_time_rounded,
        size: 12,
        color: AppColors.textSecondary.withOpacity(0.5),
      );
    }
    
    return Icon(
      message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
      size: 14,
      color: message.isRead ? AppColors.accent : AppColors.textSecondary.withOpacity(0.5),
    );
  }
}

class ChatDateSeparator extends StatelessWidget {
  final DateTime date;

  const ChatDateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        DateFormat('MMM d, yyyy').format(date).toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
