import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../services/chat_service.dart';
import '../../services/booking_service.dart';
import '../../models/chat_model.dart';
import '../../models/booking_model.dart';
import 'widgets/chat_empty_state.dart';
import 'widgets/chat_list_card.dart';

class ChatHubScreen extends StatefulWidget {
  final VoidCallback onExplore;
  const ChatHubScreen({super.key, required this.onExplore});

  @override
  State<ChatHubScreen> createState() => _ChatHubScreenState();
}

class _ChatHubScreenState extends State<ChatHubScreen> {
  final ChatService _chatService = ChatService();
  final BookingService _bookingService = BookingService();
  bool _isLoading = true;
  String? _error;
  List<ChatRoom> _allRooms = [];
  Map<String, String> _bookingImageById = {};
  String _activeTab = 'ACTIVE';

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final roomsFuture = _chatService.getRooms();
      final ongoingFuture = _bookingService.getUserBookings(when: 'ONGOING');
      final upcomingFuture = _bookingService.getUserBookings(when: 'UPCOMING');

      final rooms = await roomsFuture;
      final ongoing = await ongoingFuture;
      final upcoming = await upcomingFuture;

      final bookingImageById = <String, String>{};

      void addFromResponse(BookingsResponse? response) {
        if (response == null || !response.success) return;

        for (final booking in response.data.publicTours) {
          final image = booking.package?.coverImage?.trim();
          if (image != null && image.isNotEmpty) {
            bookingImageById[booking.id.toString()] = image;
          }
        }
        for (final booking in response.data.privateTours) {
          final image = booking.package?.coverImage?.trim();
          if (image != null && image.isNotEmpty) {
            bookingImageById[booking.id.toString()] = image;
          }
        }
      }

      addFromResponse(ongoing);
      addFromResponse(upcoming);

      if (mounted) {
        setState(() {
          _allRooms = rooms;
          _bookingImageById = bookingImageById;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load chats';
          _isLoading = false;
        });
      }
    }
  }

  List<ChatRoom> _getFilteredRooms() {
    return _allRooms.where((room) {
      final status = room.tourStatus.toUpperCase();
      if (_activeTab == 'ACTIVE') {
        return ['IN_PROGRESS', 'CONFIRMED'].contains(status) || _allRooms.length < 3;
      } else if (_activeTab == 'COMPLETED') {
        return ['COMPLETED', 'CANCELLED'].contains(status);
      } else {
        return ['PENDING', 'ACCEPTED', 'STARTING_SOON'].contains(status);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    'My Tour Chats',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.search, color: AppColors.textPrimary, size: 24),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('Active', 'ACTIVE'),
                _buildTab('Completed', 'COMPLETED'),
                _buildTab('Upcoming', 'UPCOMING'),
              ],
            ),
          ),

          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String value) {
    final bool isActive = _activeTab == value;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.accent : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: AppColors.textSecondary)),
            TextButton(
              onPressed: _fetchRooms,
              child: const Text('Retry', style: TextStyle(color: AppColors.accent)),
            )
          ],
        ),
      );
    }

    final filteredRooms = _getFilteredRooms();

    if (_allRooms.isEmpty) {
      return ChatEmptyState(onExplore: widget.onExplore);
    }

    if (filteredRooms.isEmpty) {
      return Center(
        child: Text('No $_activeTab chats found.', style: const TextStyle(color: AppColors.textSecondary)),
      );
    }

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: _fetchRooms,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100, top: 8),
        itemCount: filteredRooms.length,
        itemBuilder: (context, index) {
          final room = filteredRooms[index];
          return ChatListCard(
            room: room,
            fallbackTourImageUrl: room.bookingId != null
                ? _bookingImageById[room.bookingId!]
                : null,
            onReturn: _fetchRooms,
          );
        },
      ),
    );
  }
}
