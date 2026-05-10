import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../data/models/conversation_model.dart';
import '../../data/repo/conversations_repo.dart';
import 'conversations_state.dart';

class ConversationsCubit
    extends Cubit<ConversationsState<List<ConversationModel>>> {
  final ConversationsRepo _repo;

  ConversationsCubit(this._repo )
      : super(const ConversationsState.initial());

  Future<void> loadConversations() async {
    emit(const ConversationsState.loading());
    try {
      final prefs = getIt<SharedPrefHelper>();
      final token = await prefs.getSecureData('token');

      if (token == null) {
        emit(const ConversationsState.fail('Session expired, please login again'));
        return;
      }

      final conversations = await _repo.getMyConversations(token);
      emit(ConversationsState.success(conversations));
    } catch (e) {
      emit(ConversationsState.fail(e.toString()));
    }
  }

  int unreadCount = 0;

  Future<void> loadUnreadCount() async {
    try {
      final prefs = getIt<SharedPrefHelper>();
      final token = await prefs.getSecureData('token');
      if (token == null) return;

      unreadCount = await _repo.getUnreadCount(token);
      emit(state);   // ← re-emit current state to trigger BlocBuilder rebuild
    } catch (_) {}
  }
}