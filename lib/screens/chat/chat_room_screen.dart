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
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    // 1. Get current user ID to distinguish sender/receiver bubbles
    final user = await TokenService.getUser();
    _currentUserId = user?.id;

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

    // 3. Connect Socket and Join Room
    await _chatService.connect();
    _chatService.joinRoom(widget.room.id);

    // 4. Listen for incoming messages
    _chatService.onMessageReceived = (message) {
      if (message.chatRoomId == widget.room.id) {
        setState(() {
          _messages.add(message);
        });
        _scrollToBottom();
      }
    };
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
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        msgType: 'TEXT',
        chatRoomId: widget.room.id,
        senderId: _currentUserId ?? '',
        isRead: false,
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
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message.senderId == _currentUserId;
        
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
