import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/api_config.dart';
import '../models/chat_model.dart';
import 'token_service.dart';

class ChatService {
  IO.Socket? socket;
  Function(Message)? onMessageReceived;

  // Initialize Socket Connection and wait for it to be ready
  Future<void> connect() async {
    if (socket != null && socket!.connected) return;

    final Completer<void> completer = Completer<void>();
    final token = await TokenService.getToken();
    if (token == null) return;

    print('Attempting to connect to socket: ${ApiConfig.chatSocket}');
    socket = IO.io(ApiConfig.chatSocket, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });

    socket!.onConnect((_) {
      print('Socket connected: ${socket!.id}');
      if (!completer.isCompleted) completer.complete();
    });

    socket!.onConnectError((err) {
      print('Socket connection error: $err');
      if (!completer.isCompleted) completer.completeError(err);
    });

    socket!.on('connect_timeout', (_) {
      print('Socket connection timeout');
      if (!completer.isCompleted) completer.completeError('Timeout');
    });

    socket!.onDisconnect((_) {
      print('Socket disconnected');
    });

    // Listen for incoming messages
    socket!.on('receive_message', (data) {
      print('Socket received message packet: $data');
      if (onMessageReceived != null && data != null) {
        try {
          final message = Message.fromJson(data);
          onMessageReceived!(message);
        } catch (e) {
          print('Error parsing incoming socket message: $e');
        }
      }
    });

    socket!.connect();
    
    // Wait for connection or error
    return completer.future;
  }

  // Join a specific room
  void joinRoom(String roomId) {
    if (socket != null) {
      socket!.emit('join_room', roomId);
    }
  }

  // Send a message via Socket
  void sendMessage(String roomId, String content, {String msgType = 'TEXT'}) {
    if (socket != null) {
      socket!.emit('send_message', {
        'roomId': roomId,
        'content': content,
        'msgType': msgType,
      });
    }
  }

  // Disconnect Socket
  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }

  // --- REST ENDPOINTS ---

  // Get all chat rooms for the tourist
  Future<List<ChatRoom>> getRooms() async {
    final token = await TokenService.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse(ApiConfig.myChatRooms),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ChatRoom.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chat rooms');
    }
  }

  // Get messages for a specific room
  Future<List<Message>> getMessages(String roomId) async {
    final token = await TokenService.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse(ApiConfig.chatMessages(roomId)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
