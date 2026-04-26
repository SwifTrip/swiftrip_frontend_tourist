import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/chat_model.dart';
import '../../services/chat_service.dart';
import '../../services/token_service.dart';

import 'widgets/chat_room_header.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_bar.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomScreen({super.key, required this.room});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> _messages = [];
  bool _isLoading = true;
  bool _aiTyping = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    // 1. Get current user ID to distinguish sender/receiver bubbles
    final user = await TokenService.getUser();
    _currentUserId = user?.id.toString();

    // 2. Fetch history via REST
    try {
      final history = await _chatService.getMessages(widget.room.id);
      if (mounted) {
        setState(() {
          _messages = history;
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }

    // 4. Connect Socket and Join Room
    try {
      await _chatService.connect();
      _chatService.joinRoom(widget.room.id);
      
      // 5. Listen for incoming messages
      _chatService.onMessageReceived = (message) {
        if (message.chatRoomId == widget.room.id) {
          if (mounted) {
            setState(() {
              _messages.add(message);
              _aiTyping = false;
            });
            _scrollToBottom();
          }
        }
      };

      _chatService.onAiTyping = (roomId, isTyping) {
        if (roomId == widget.room.id && mounted) {
          setState(() {
            _aiTyping = isTyping;
          });
          if (isTyping) _scrollToBottom();
        }
      };
    } catch (e) {
      print('Chat Socket Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Working offline. Real-time messages may be delayed.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _chatService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    _chatService.sendMessage(widget.room.id, text);

    // Optimistically add to UI
    setState(() {
      _messages.add(Message(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        content: text,
        msgType: 'TEXT',
        chatRoomId: widget.room.id,
        senderId: _currentUserId ?? '',
        isRead: false,
        isAiGenerated: false,
        createdAt: DateTime.now(),
      ));
    });

    _msgController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChatRoomHeader(room: widget.room),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                : _buildMessageList(),
          ),
          ChatInputBar(
            controller: _msgController,
            onSend: _sendMessage,
            hintText: 'Message ${widget.room.guideName?.split(" ").first ?? "Guide"}...',
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final int extra = _aiTyping ? 1 : 0;
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + extra,
      itemBuilder: (context, index) {
        if (_aiTyping && index == _messages.length) {
          return Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const SizedBox(
                    height: 14,
                    width: 42,
                    child: _TypingDots(),
                  ),
                ),
              ],
            ),
          );
        }

        final message = _messages[index];
        final isMe =
            message.id.startsWith('temp_') || message.senderId == _currentUserId;
        
        bool showDate = false;
        if (index == 0) {
          showDate = true;
        } else {
          final prevMessage = _messages[index - 1];
          showDate = message.createdAt.day != prevMessage.createdAt.day ||
                     message.createdAt.month != prevMessage.createdAt.month ||
                     message.createdAt.year != prevMessage.createdAt.year;
        }

        return Column(
          children: [
            if (showDate) ChatDateSeparator(date: message.createdAt),
            ChatBubble(
              message: message,
              isMe: isMe,
              guideAvatar: widget.room.guideAvatar,
            ),
          ],
        );
      },
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        double o1 = (t < 0.33) ? 1 : 0.3;
        double o2 = (t >= 0.33 && t < 0.66) ? 1 : 0.3;
        double o3 = (t >= 0.66) ? 1 : 0.3;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: o1,
              child: _dot(),
            ),
            const SizedBox(width: 6),
            Opacity(
              opacity: o2,
              child: _dot(),
            ),
            const SizedBox(width: 6),
            Opacity(
              opacity: o3,
              child: _dot(),
            ),
          ],
        );
      },
    );
  }

  Widget _dot() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}
