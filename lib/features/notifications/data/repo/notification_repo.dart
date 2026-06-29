import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/notifications/data/models/notification_model.dart';

import '../models/mark_all_read_response.dart';
import '../models/notification_preferences.dart';
import '../models/notifications_list_response.dart';
import '../models/unread_count_response.dart';

class NotificationRepo {
  final ApiService apiService;

  NotificationRepo({required this.apiService});

  // GET /api/auth/notification-preferences
  Future<NotificationPreferencesResponse> getNotificationPreferences(
      String token) async {
    try {
      return await apiService.getNotificationPreferences("Bearer $token");
    } catch (e) {
      throw Exception("Failed to get notification preferences: $e");
    }
  }

  // PUT /api/auth/notification-preferences
  Future<UpdatePreferencesResponse> updateNotificationPreferences({
    required String token,
    bool? orderUpdates,
    bool? bidUpdates,
    bool? offerUpdates,
    bool? lowStockAlerts,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (orderUpdates != null) body['orderUpdates'] = orderUpdates;
      if (bidUpdates != null) body['bidUpdates'] = bidUpdates;
      if (offerUpdates != null) body['offerUpdates'] = offerUpdates;
      if (lowStockAlerts != null) body['lowStockAlerts'] = lowStockAlerts;

      return await apiService.updateNotificationPreferences(
          "Bearer $token", body);
    } catch (e) {
      throw Exception("Failed to update notification preferences: $e");
    }
  }

  // GET /api/notifications
  Future<NotificationsListResponse> getNotifications({
    required String token,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await apiService.getNotifications(
        "Bearer $token",
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw Exception("Failed to get notifications: $e");
    }
  }

  // GET /api/notifications/unread-count
  Future<UnreadCountResponse> getUnreadCount(String token) async {
    try {
      return await apiService.getUnreadNotificationsCount("Bearer $token");
    } catch (e) {
      throw Exception("Failed to get unread count: $e");
    }
  }

  // PATCH /api/notifications/:id/read
  Future<MessageModel> markAsRead({
    required String token,
    required String notificationId,
  }) async {
    try {
      return await apiService.markNotificationAsRead(
          "Bearer $token", notificationId);
    } catch (e) {
      throw Exception("Failed to mark notification as read: $e");
    }
  }

  // PATCH /api/notifications/read-all
  Future<MarkAllReadResponse> markAllAsRead(String token) async {
    try {
      return await apiService.markAllNotificationsAsRead("Bearer $token");
    } catch (e) {
      throw Exception("Failed to mark all notifications as read: $e");
    }
  }

  // DELETE /api/notifications/:id
  Future<MessageModel> deleteNotification({
    required String token,
    required String notificationId,
  }) async {
    try {
      return await apiService.deleteNotification(
          "Bearer $token", notificationId);
    } catch (e) {
      throw Exception("Failed to delete notification: $e");
    }
  }
}