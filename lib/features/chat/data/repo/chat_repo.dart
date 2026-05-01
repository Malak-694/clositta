import '../../../../core/networking/api_service.dart';
import '../models/chat_message_model.dart';

class ChatRepo {
  final ApiService _apiService;

  ChatRepo(this._apiService);

  Future<List<ChatMessageModel>> getChatHistory(String token, String userId) async {
    final response = await _apiService.getChatHistory('Bearer $token', userId);
    return response.messages ?? [];
  }
}