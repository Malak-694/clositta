import '../../../../core/networking/api_service.dart';
import '../models/conversation_model.dart';

class ConversationsRepo {
  final ApiService _apiService;

  ConversationsRepo(this._apiService);

  Future<List<ConversationModel>> getMyConversations(String token) async {
    return await _apiService.getMyConversations('Bearer $token');
  }
}