import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/socket_service.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repo/chat_repo.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState<List<ChatMessageModel>>> {
  final SocketService _socketService;
  final ChatRepo      _chatRepo;

  final List<ChatMessageModel>   _messages      = [];
  final List<StreamSubscription> _subscriptions = [];

  ChatCubit(this._socketService, this._chatRepo)
      : super(const ChatState.initial());

  Future<void> connectToChat({
    required String token,
    required String receiverId,
  }) async {
    // ✅ Cancel subscriptions AND disconnect old socket before reinitializing
    for (final sub in _subscriptions) sub.cancel();
    _subscriptions.clear();
    _messages.clear();
    _socketService.disconnect(); // ← key fix: kills old socket before init()

    emit(const ChatState.loading());

    try {
      final history = await _chatRepo.getChatHistory(token, receiverId);
      _messages.addAll(history);
      emit(ChatState.success(List.from(_messages)));

      // ✅ Fresh stream controllers AFTER disconnect
      _socketService.init();

      _subscriptions.add(
        _socketService.onConnected.listen((_) {
          // socket is ready — nothing needed here
        }),
      );

      _subscriptions.add(
        _socketService.onMessageReceived.listen((msg) {
          _messages.add(msg);
          emit(ChatState.success(List.from(_messages)));
        }),
      );

      _subscriptions.add(
        _socketService.onMessageSent.listen((msg) {
          _messages.add(msg);
          emit(ChatState.success(List.from(_messages)));
        }),
      );

      _subscriptions.add(
        _socketService.onMessageEdited.listen((updatedMsg) {
          final index = _messages.indexWhere((m) => m.id == updatedMsg.id);
          if (index != -1) _messages[index] = updatedMsg;
          emit(ChatState.success(List.from(_messages)));
        }),
      );

      _subscriptions.add(
        _socketService.onMessageDeleted.listen((deletedMsg) {
          final index = _messages.indexWhere((m) => m.id == deletedMsg.id);
          if (index != -1) _messages[index] = deletedMsg;
          emit(ChatState.success(List.from(_messages)));
        }),
      );

      _subscriptions.add(
        _socketService.onError.listen((error) {
          final msg = error.toLowerCase();
          if (msg.contains('token') ||
              msg.contains('auth') ||
              msg.contains('unauthorized') ||
              msg.contains('expired')) {
            emit(ChatState.fail(error));
          }
        }),
      );
      _socketService.connect(token, receiverId);
    } catch (e) {
      emit(ChatState.fail(e.toString()));
    }
  }

  void emitError(String message) => emit(ChatState.fail(message));

  void sendMessage({required String receiverId, required String content}) {
    if (content.trim().isEmpty) return;
    if (!_socketService.isConnected) {
      emit(ChatState.fail('Not connected. Please wait or retry.'));
      return;
    }

    _socketService.sendMessage(receiverId: receiverId, content: content);
  }

  void editMessage({required String messageId, required String newContent}) {
    if (!_socketService.isConnected) return;
    _socketService.editMessage(messageId: messageId, newContent: newContent);
  }

  void deleteMessage(String messageId) {
    if (!_socketService.isConnected) return;
    _socketService.deleteMessage(messageId);
  }

  Future<void> uploadImage({
    required String token,
    required String receiverId,
    required File imageFile,
    String? caption,
  }) async {
    try {
      final message = await _chatRepo.uploadImage(
        token: token,
        receiverId: receiverId,
        imageFile: imageFile,
        caption: caption,
      );
      final exists = _messages.any((m) => m.id == message.id);
      if (!exists) {
        _messages.add(message);
        emit(ChatState.success(List.from(_messages)));
      }
    } catch (e) {
      emit(ChatState.fail(e.toString()));
    }
  }
  void sendTyping(String receiverId) => _socketService.sendTyping(receiverId);
  void stopTyping(String receiverId)  => _socketService.stopTyping(receiverId);
  void markAsRead(String senderId)    => _socketService.markAsRead(senderId);

  void disconnectChat() {
    for (final sub in _subscriptions) sub.cancel();
    _subscriptions.clear();
    _socketService.disconnect();
    emit(const ChatState.initial());
  }

  @override
  Future<void> close() {
    for (final sub in _subscriptions) sub.cancel();
    _socketService.disconnect();
    return super.close();
  }
}