import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../features/chat/data/models/chat_message_model.dart';
import 'api_endpoints.dart';

class SocketService {
  IO.Socket? _socket;

  StreamController<ChatMessageModel> _onMessageReceived = StreamController.broadcast();
  StreamController<ChatMessageModel> _onMessageSent  = StreamController.broadcast();
  StreamController<ChatMessageModel> _onMessageEdited = StreamController.broadcast();
  StreamController<ChatMessageModel> _onMessageDeleted = StreamController.broadcast();
  StreamController<Map> _onTyping = StreamController.broadcast();
  StreamController<Map> _onStopTyping = StreamController.broadcast();
  StreamController<String> _onError = StreamController.broadcast();
  StreamController<String> _onUserOnline = StreamController.broadcast();
  StreamController<String>  _onUserOffline = StreamController.broadcast();
  StreamController<bool> _onConnected = StreamController.broadcast();

  Stream<ChatMessageModel> get onMessageReceived => _onMessageReceived.stream;
  Stream<ChatMessageModel> get onMessageSent => _onMessageSent.stream;
  Stream<ChatMessageModel> get onMessageEdited => _onMessageEdited.stream;
  Stream<ChatMessageModel> get onMessageDeleted => _onMessageDeleted.stream;
  Stream<Map> get onTyping => _onTyping.stream;
  Stream<Map> get onStopTyping => _onStopTyping.stream;
  Stream<String> get onError => _onError.stream;
  Stream<String> get onUserOnline => _onUserOnline.stream;
  Stream<String> get onUserOffline => _onUserOffline.stream;
  Stream<bool> get onConnected => _onConnected.stream;

  bool get isConnected => _socket?.connected ?? false;

  void init() {
    _closeControllers();
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

  void connect(String token, String receiverId) {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

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
      print('Socket connected: ${_socket?.id}');
      _socket!.emit('joinConversation', {'receiverId': receiverId});
      if (!_onConnected.isClosed) _onConnected.add(true);
    });

    _socket!.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket!.onConnectError((err) {
      print('Connect error: $err');
      if (!_onError.isClosed) _onError.add(err.toString());
    });

    _socket!.on('connect_error', (data) {
      print('Server rejected: $data');
      if (!_onError.isClosed) _onError.add(data.toString());
    });

    _socket!.on('receiveMessage', (data) {
      final msg = ChatMessageModel.fromJson(data);
      if (!_onMessageReceived.isClosed) _onMessageReceived.add(msg);
    });

    _socket!.on('messageSent', (data) {
      final msg = ChatMessageModel.fromJson(data);
      if (!_onMessageSent.isClosed) _onMessageSent.add(msg);
    });

    _socket!.on('messageEdited', (data) {
      final msg = ChatMessageModel.fromJson(data);
      if (!_onMessageEdited.isClosed) _onMessageEdited.add(msg);
    });

    _socket!.on('messageDeleted', (data) {
      final msg = ChatMessageModel.fromJson(data);
      if (!_onMessageDeleted.isClosed) _onMessageDeleted.add(msg);
    });

    _socket!.on('userTyping', (data) {
      if (!_onTyping.isClosed) _onTyping.add(data);
    });

    _socket!.on('userStopTyping', (data) {
      if (!_onStopTyping.isClosed) _onStopTyping.add(data);
    });

    _socket!.on('userOnline', (data) {
      if (!_onUserOnline.isClosed) _onUserOnline.add(data['userId']);
    });

    _socket!.on('userOffline', (data) {
      if (!_onUserOffline.isClosed) _onUserOffline.add(data['userId']);
    });

    _socket!.on('error', (data) {
      final msg = data['message']?.toString() ?? data.toString();
      if (msg.contains('token') ||
          msg.contains('auth') ||
          msg.contains('unauthorized') ||
          msg.contains('Unauthorized') ||
          msg.contains('expired')) {
        print('Auth error: $msg');
        if (!_onError.isClosed) _onError.add(msg);
      }
    });
  }

  void sendMessage({required String receiverId, required String content}) {
    if (!isConnected) {
      print('sendMessage called but socket is not connected');
      return;
    }
    _socket?.emit('sendMessage', {
      'receiverId': receiverId,
      'content': content,
    });
  }

  void editMessage({required String messageId, required String newContent}) {
    if (!isConnected) return;
    _socket?.emit('editMessage', {
      'messageId': messageId,
      'newContent': newContent,
    });
  }

  void deleteMessage(String messageId) {
    if (!isConnected) return;
    _socket?.emit('deleteMessage', {'messageId': messageId});
  }

  void sendTyping(String receiverId) {
    if (!isConnected) return;
    _socket?.emit('typing', {'receiverId': receiverId});
  }

  void stopTyping(String receiverId) {
    if (!isConnected) return;
    _socket?.emit('stopTyping', {'receiverId': receiverId});
  }

  void markAsRead(String senderId) {
    if (!isConnected) return;
    _socket?.emit('markAsRead', {'senderId': senderId});
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _closeControllers();
  }

  void _closeControllers() {
    if (!_onMessageReceived.isClosed) _onMessageReceived.close();
    if (!_onMessageSent.isClosed) _onMessageSent.close();
    if (!_onMessageEdited.isClosed) _onMessageEdited.close();
    if (!_onMessageDeleted.isClosed) _onMessageDeleted.close();
    if (!_onTyping.isClosed) _onTyping.close();
    if (!_onStopTyping.isClosed) _onStopTyping.close();
    if (!_onError.isClosed) _onError.close();
    if (!_onUserOnline.isClosed) _onUserOnline.close();
    if (!_onUserOffline.isClosed) _onUserOffline.close();
    if (!_onConnected.isClosed) _onConnected.close();
  }
}