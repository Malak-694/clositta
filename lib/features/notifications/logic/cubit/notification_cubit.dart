import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/notifications/data/models/notification_model.dart';
import 'package:chicora/features/notifications/data/repo/notification_repo.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _repo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  // Local list so we can update it without re-fetching
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  // Plain int field — readable without watching state
  int unreadCount = 0;

  NotificationCubit(this._repo) : super(const NotificationState.initial());

  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  String _parseError(Object e) {
    final msg = e.toString();
    return msg.contains("Exception:") ? msg.split("Exception: ")[1] : msg;
  }

  // ── Get notifications list ──────────────────────────────
  Future<void> getNotifications({int page = 1, int limit = 20}) async {
    emit(const NotificationState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const NotificationState.fail("Authentication token not found"));
        return;
      }
      final result = await _repo.getNotifications(
          token: token, page: page, limit: limit);
      _notifications = result.notifications;
      emit(NotificationState.success(result));
    } catch (e) {
      emit(NotificationState.fail(_parseError(e)));
    }
  }

  // ── Get unread count ────────────────────────────────────
  Future<void> getUnreadCount() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return;
      final result = await _repo.getUnreadCount(token);
      unreadCount = result.unreadCount;
      // re-emit current state so context.watch triggers a rebuild
      final current = state;
      current.maybeWhen(
        success: (_) => emit(NotificationState.success(result)),
        orElse: () => emit(NotificationState.success(result)),
      );
    } catch (_) {}
  }

  // ── Mark single notification as read ───────────────────
  Future<void> markAsRead(String notificationId) async {
    emit(const NotificationState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const NotificationState.fail("Authentication token not found"));
        return;
      }
      final result = await _repo.markAsRead(
          token: token, notificationId: notificationId);
      // Update local list
      _notifications = _notifications.map((n) {
        if (n.id == notificationId) {
          return NotificationModel(
            id: n.id,
            recipient: n.recipient,
            type: n.type,
            title: n.title,
            body: n.body,
            data: n.data,
            isRead: true,
            createdAt: n.createdAt,
            updatedAt: n.updatedAt,
          );
        }
        return n;
      }).toList();
      emit(NotificationState.success(result));
    } catch (e) {
      emit(NotificationState.fail(_parseError(e)));
    }
  }

  // ── Mark all notifications as read ─────────────────────
  Future<void> markAllAsRead() async {
    emit(const NotificationState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const NotificationState.fail("Authentication token not found"));
        return;
      }
      final result = await _repo.markAllAsRead(token);
      // Mark all local items as read
      _notifications =
          _notifications.map((n) => NotificationModel(
            id: n.id,
            recipient: n.recipient,
            type: n.type,
            title: n.title,
            body: n.body,
            data: n.data,
            isRead: true,
            createdAt: n.createdAt,
            updatedAt: n.updatedAt,
          )).toList();
      emit(NotificationState.success(result));
    } catch (e) {
      emit(NotificationState.fail(_parseError(e)));
    }
  }

  // ── Delete notification ─────────────────────────────────
  Future<void> deleteNotification(String notificationId) async {
    emit(const NotificationState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const NotificationState.fail("Authentication token not found"));
        return;
      }
      final result = await _repo.deleteNotification(
          token: token, notificationId: notificationId);
      // Remove from local list
      _notifications.removeWhere((n) => n.id == notificationId);
      emit(NotificationState.success(result));
    } catch (e) {
      emit(NotificationState.fail(_parseError(e)));
    }
  }

  // ── Get notification preferences ───────────────────────
  Future<void> getNotificationPreferences() async {
    emit(const NotificationState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const NotificationState.fail("Authentication token not found"));
        return;
      }
      final result = await _repo.getNotificationPreferences(token);
      emit(NotificationState.success(result));
    } catch (e) {
      emit(NotificationState.fail(_parseError(e)));
    }
  }

  // ── Update notification preferences ────────────────────
  Future<void> updateNotificationPreferences({
    bool? orderUpdates,
    bool? bidUpdates,
    bool? offerUpdates,
    bool? lowStockAlerts,
  }) async {
    emit(const NotificationState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const NotificationState.fail("Authentication token not found"));
        return;
      }
      final result = await _repo.updateNotificationPreferences(
        token: token,
        orderUpdates: orderUpdates,
        bidUpdates: bidUpdates,
        offerUpdates: offerUpdates,
        lowStockAlerts: lowStockAlerts,
      );
      emit(NotificationState.success(result));
    } catch (e) {
      emit(NotificationState.fail(_parseError(e)));
    }
  }
}