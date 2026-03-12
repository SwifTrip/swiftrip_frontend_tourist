class ChatRoom {
  final String id;
  final String? bookingId;
  final String? customTourId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? guideName;
  final String? guideAvatar;
  final String? tourTitle;
  final String tourStatus;
  final String? tourIdText;
  final Message? lastMessage;

  ChatRoom({
    required this.id,
    this.bookingId,
    this.customTourId,
    required this.createdAt,
    required this.updatedAt,
    this.guideName,
    this.guideAvatar,
    this.tourTitle,
    required this.tourStatus,
    this.tourIdText,
    this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    // Determine title, status and id wrapper
    String title = "Unknown Tour";
    String status = "PENDING";
    String tourStringId = "N/A";

    if (json['customTour'] != null) {
      title = json['customTour']['destination'] ?? 'Custom Tour';
      status = json['customTour']['status'] ?? 'PENDING';
      tourStringId = "CT-${json['customTourId']?.substring(0, 4) ?? '0000'}".toUpperCase();
    } else if (json['booking'] != null) {
      // Logic for public booking title extraction if available
      title = "Public Tour Booking";
      status = json['booking']['status'] ?? 'PENDING';
      tourStringId = "BK-${json['bookingId']?.substring(0, 4) ?? '0000'}".toUpperCase();
    }

    // Extract Guide info
    String? guideName;
    if (json['participants'] != null && json['participants'] is List) {
      for (var p in json['participants']) {
        if (p['user'] != null && p['user']['role'] == 'AGENCY_STAFF') {
          guideName = "${p['user']['firstName'] ?? ''} ${p['user']['lastName'] ?? ''}".trim();
          if (guideName.isEmpty) guideName = "Guide";
        }
      }
    }

    // Last message preview
    Message? lastMsg;
    if (json['messages'] != null && json['messages'] is List && json['messages'].isNotEmpty) {
      lastMsg = Message.fromJson(json['messages'][0]);
    }

    return ChatRoom(
      id: json['id'],
      bookingId: json['bookingId'],
      customTourId: json['customTourId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      guideName: guideName,
      tourTitle: title,
      tourStatus: status,
      tourIdText: tourStringId,
      lastMessage: lastMsg,
    );
  }
}

class Message {
  final String id;
  final String content;
  final String? mediaUrl;
  final String msgType;
  final String chatRoomId;
  final String senderId;
  final bool isRead;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.content,
    this.mediaUrl,
    required this.msgType,
    required this.chatRoomId,
    required this.senderId,
    required this.isRead,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // Extract senderId carefully (REST returns participant object usually, Socket might just send senderId or full message)
    String extractSenderId = '';
    if (json['participant'] != null && json['participant']['userId'] != null) {
      extractSenderId = json['participant']['userId'];
    } else if (json['senderId'] != null) {
      extractSenderId = json['senderId'];
    }

    return Message(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      mediaUrl: json['mediaUrl'],
      msgType: json['msgType'] ?? 'TEXT',
      chatRoomId: json['chatRoomId'] ?? '',
      senderId: extractSenderId,
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}
