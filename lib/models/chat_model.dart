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
      final ctIdStr = json['customTourId']?.toString() ?? '0000';
      tourStringId = "CT-${ctIdStr.length > 4 ? ctIdStr.substring(0, 4) : ctIdStr}".toUpperCase();
    } else if (json['booking'] != null) {
      // Logic for public booking title extraction if available
      title = "Public Tour Booking";
      status = json['booking']['status'] ?? 'PENDING';
      final bkIdStr = json['bookingId']?.toString() ?? '0000';
      tourStringId = "BK-${bkIdStr.length > 4 ? bkIdStr.substring(0, 4) : bkIdStr}".toUpperCase();
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
      bookingId: json['bookingId']?.toString(),
      customTourId: json['customTourId']?.toString(),
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
    // Robust senderId extraction
    String extractSenderId = '';
    if (json['senderId'] != null) {
      extractSenderId = json['senderId'].toString();
    } else if (json['participant'] != null && json['participant']['userId'] != null) {
      extractSenderId = json['participant']['userId'].toString();
    } else if (json['participantId'] != null) {
      // Fallback if needed
      extractSenderId = 'PARTICIPANT_${json['participantId']}';
    }

    // Backend uses 'messageType' in socket, Prisma uses 'msgType' in some places or 'messageType' in schema
    final type = json['msgType'] ?? json['messageType'] ?? 'TEXT';
    
    // Backend uses 'timestamp' in socket, Prisma uses 'createdAt'
    final dateStr = json['createdAt'] ?? json['timestamp'];
    DateTime parsedDate;
    if (dateStr != null) {
      parsedDate = DateTime.parse(dateStr.toString());
    } else {
      parsedDate = DateTime.now();
    }

    return Message(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      mediaUrl: json['mediaUrl'],
      msgType: type,
      chatRoomId: json['chatRoomId'] ?? json['roomId'] ?? '',
      senderId: extractSenderId,
      isRead: json['isRead'] ?? false,
      createdAt: parsedDate,
    );
  }
}
