class ChatRoom {
  final String id;
  final String? bookingId;
  final String? customTourId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? guideName;
  final String? guideAvatar;
  final String? tourTitle;
  final String? tourImageUrl;
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
    this.tourImageUrl,
    required this.tourStatus,
    this.tourIdText,
    this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    // Determine title, status and id wrapper
    String title = "Unknown Tour";
    String status = "PENDING";
    String tourStringId = "N/A";
    String? tourImageUrl;

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

    String? readMapStringValue(Map<String, dynamic>? map, String key) {
      final value = map?[key];
      if (value == null) return null;
      final text = value.toString().trim();
      return text.isEmpty ? null : text;
    }

    Map<String, dynamic>? asMap(dynamic value) =>
        value is Map<String, dynamic> ? value : null;

    String? readPathString(dynamic root, List<String> path) {
      dynamic current = root;
      for (final segment in path) {
        if (current is Map<String, dynamic>) {
          current = current[segment];
        } else if (current is List) {
          final index = int.tryParse(segment);
          if (index == null || index < 0 || index >= current.length) {
            return null;
          }
          current = current[index];
        } else {
          return null;
        }
      }
      if (current == null) return null;
      final text = current.toString().trim();
      return text.isEmpty ? null : text;
    }

    final booking = asMap(json['booking']);
    final customTour = asMap(json['customTour']);

    tourImageUrl =
        readPathString(json, ['booking', 'publicTour', 'package', 'coverImage']) ??
        readPathString(json, ['booking', 'privateTour', 'package', 'coverImage']) ??
        readPathString(json, ['booking', 'tourPackage', 'coverImage']) ??
        readPathString(json, ['booking', 'package', 'media', '0', 'url']) ??
        readMapStringValue(asMap(booking?['package']), 'coverImage') ??
        readMapStringValue(customTour, 'coverImage') ??
        readMapStringValue(customTour, 'thumbnail') ??
        readMapStringValue(customTour, 'image') ??
        readMapStringValue(customTour, 'imageUrl') ??
        readMapStringValue(asMap(customTour?['package']), 'coverImage') ??
        readMapStringValue(asMap(customTour?['tourPackage']), 'coverImage') ??
        readPathString(json, ['customTour', 'tourPackage', 'coverImage']) ??
        readPathString(json, ['customTour', 'tourPackage', 'thumbnail']) ??
        readPathString(json, ['customTour', 'tourPackage', 'imageUrl']);

    if (tourImageUrl == null) {
      final mediaLists = [
        customTour?['media'],
        customTour?['images'],
        asMap(customTour?['tourPackage'])?['media'],
        asMap(booking?['package'])?['media'],
      ];

      for (final media in mediaLists) {
        if (media is List && media.isNotEmpty) {
          final firstMedia = media.first;
          if (firstMedia is Map<String, dynamic>) {
            tourImageUrl =
                readMapStringValue(firstMedia, 'url') ??
                readMapStringValue(firstMedia, 'imageUrl') ??
                readMapStringValue(firstMedia, 'coverImage');
            if (tourImageUrl != null) break;
          }
        }
      }
    }

    // Improve title fallback from booking package when available.
    if (title == "Public Tour Booking") {
      title =
          readPathString(json, ['booking', 'package', 'title']) ??
          readPathString(json, ['booking', 'publicTour', 'package', 'title']) ??
          readPathString(json, ['booking', 'privateTour', 'package', 'title']) ??
          readPathString(json, ['booking', 'tourPackage', 'title']) ??
          title;
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
      tourImageUrl: tourImageUrl,
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
  final bool isAiGenerated;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.content,
    this.mediaUrl,
    required this.msgType,
    required this.chatRoomId,
    required this.senderId,
    required this.isRead,
    required this.isAiGenerated,
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
      isAiGenerated: json['isAiGenerated'] ?? false,
      createdAt: parsedDate,
    );
  }
}
