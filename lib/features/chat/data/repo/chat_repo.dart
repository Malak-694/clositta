import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/networking/api_service.dart';
import '../models/chat_message_model.dart';

class ChatRepo {
  final ApiService _apiService;

  ChatRepo(this._apiService);

  Future<List<ChatMessageModel>> getChatHistory(String token, String userId) async {
    final response = await _apiService.getChatHistory('Bearer $token', userId);
    return response.messages ?? [];
  }

  Future<ChatMessageModel> uploadImage({
    required String token,
    required String receiverId,
    required File imageFile,
    String? caption,
  }) async {
    final multipartFile = await MultipartFile.fromFile(
      imageFile.path,
      filename: imageFile.path.split('/').last,
    );

    return await _apiService.uploadChatImage(
      'Bearer $token',
      receiverId,
      multipartFile,
      caption: caption,
    );
  }
}