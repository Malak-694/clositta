import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../features/chat/data/models/chat_message_model.dart';
import 'api_endpoints.dart';

class SocketService {
  IO.Socket? _socket;

  StreamController<ChatMessageModel> _onMessageReceived = StreamController.broadcast();
  StreamController<ChatMessageModel> _onMessageSent     = StreamController.broadcast();
  StreamController<ChatMessageModel> _onMessageEdited   = StreamController.broadcast();
  StreamController<ChatMessageModel> _onMessageDeleted  = StreamController.broadcast();
  StreamController<Map>          _onTyping          = StreamController.broadcast();
  StreamController<Map>          _onStopTyping      = StreamController.broadcast();
  StreamController<String>       _onError           = StreamController.broadcast();
  StreamController<String>       _onUserOnline      = StreamController.broadcast();
  StreamController<String>       _onUserOffline     = StreamController.broadcast();
  StreamController<bool>         _onConnected       = StreamController.broadcast();

  Stream<ChatMessageModel> get onMessageReceived => _onMessageReceived.stream;
  Stream<ChatMessageModel> get onMessageSent     => _onMessageSent.stream;
  Stream<ChatMessageModel> get onMessageEdited   => _onMessageEdited.stream;
  Stream<ChatMessageModel> get onMessageDeleted  => _onMessageDeleted.stream;
  Stream<Map>          get onTyping          => _onTyping.stream;
  Stream<Map>          get onStopTyping      => _onStopTyping.stream;
  Stream<String>       get onError           => _onError.stream;
  Stream<String>       get onUserOnline      => _onUserOnline.stream;
  Stream<String>       get onUserOffline     => _onUserOffline.stream;
  Stream<bool>         get onConnected       => _onConnected.stream;

  bool get isConnected => _socket?.connected ?? false;

  // ✅ Step 1 — call this FIRST to get fresh stream controllers
  void init() {
    _onMessageReceived = StreamController.broadcast();
    _onMessageSent     = StreamController.broadcast();
    _onMessageEdited   = StreamController.broadcast();
    _onMessageDeleted  = StreamController.broadcast();
    _onTyping          = StreamController.broadcast();
    _onStopTyping      = StreamController.broadcast();
    _onError           = StreamController.broadcast();
    _onUserOnline      = StreamController.broadcast();
    _onUserOffline     = StreamController.broadcast();
    _onConnected       = StreamController.broadcast();
  }

  // ✅ Step 2 — call this AFTER subscribing in cubit
  void connect(String token, String receiverId) {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket = null;
    }

    print('🔑 Connecting with token: $token');

    _socket = IO.io(
      ApiEndpoints.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('✅ Socket connected: ${_socket?.id}');
      _socket!.emit('joinConversation', {'receiverId': receiverId});
      _onConnected.add(true);
    });


    _socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    _socket!.on('disconnect', (reason) {
      print('❌ Disconnect reason: $reason');
    });

    _socket!.onConnectError((err) {
      print('🔴 Connect error: $err');
      _onError.add(err.toString());
    });

    _socket!.onConnectTimeout((_) {
      print('⏱️ Connection timeout');
      _onError.add('Connection timed out');
    });

    _socket!.on('connect_error', (data) {
      print('🔴 Server rejected: $data');
    });

    _socket!.on('receiveMessage', (data) {
      print('📩 Message received: $data');
      final msg = ChatMessageModel.fromJson(data);
      _onMessageReceived.add(msg);
    });

    _socket!.on('messageSent', (data) {
      print('📤 Message sent confirmed: $data');
      final msg = ChatMessageModel.fromJson(data);
      _onMessageSent.add(msg);
    });

    _socket!.on('messageEdited', (data) {
      print('✏️ Message edited: $data');
      final msg = ChatMessageModel.fromJson(data);
      _onMessageEdited.add(msg);
    });

    _socket!.on('messageDeleted', (data) {
      print('🗑️ Message deleted: $data');
      final msg = ChatMessageModel.fromJson(data);
      _onMessageDeleted.add(msg);
    });

    _socket!.on('userTyping', (data) {
      print('⌨️ User typing: $data');
      _onTyping.add(data);
    });

    _socket!.on('userStopTyping', (data) {
      print('⌨️ User stop typing: $data');
      _onStopTyping.add(data);
    });

    _socket!.on('userOnline', (data) {
      print('🟢 User online: $data');
      _onUserOnline.add(data['userId']);
    });

    _socket!.on('userOffline', (data) {
      print('🔴 User offline: $data');
      _onUserOffline.add(data['userId']);
    });

    _socket!.on('error', (data) {
      print('🔴 Server error event: $data');
      final msg = data['message']?.toString() ?? data.toString();
      if (msg.contains('token') ||
          msg.contains('auth') ||
          msg.contains('unauthorized') ||
          msg.contains('Unauthorized') ||
          msg.contains('expired')) {
        _onError.add(msg);
      } else {
        print('⚠️ Non-fatal error ignored: $msg');
      }
    });
  }

// In socket_service.dart
  void sendMessage({required String receiverId, required String content}) {
    print('📤 Emitting sendMessage receiverId: $receiverId');
    print('📤 Emitting sendMessage content: $content');
    _socket?.emit('sendMessage', {
      'receiverId': receiverId,
      'content': content,
    });
  }

  void editMessage({required String messageId, required String newContent}) {
    _socket?.emit('editMessage', {
      'messageId': messageId,
      'newContent': newContent,
    });
  }

  void deleteMessage(String messageId) {
    _socket?.emit('deleteMessage', {'messageId': messageId});
  }

  void sendTyping(String receiverId) {
    _socket?.emit('typing', {'receiverId': receiverId});
  }

  void stopTyping(String receiverId) {
    _socket?.emit('stopTyping', {'receiverId': receiverId});
  }

  void markAsRead(String senderId) {
    _socket?.emit('markAsRead', {'senderId': senderId});
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _onMessageReceived.close();
    _onMessageSent.close();
    _onMessageEdited.close();
    _onMessageDeleted.close();
    _onTyping.close();
    _onStopTyping.close();
    _onError.close();
    _onUserOnline.close();
    _onUserOffline.close();
    _onConnected.close();
  }
}