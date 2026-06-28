import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/helper/shared_key.dart';

// Background message handler (must be a top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

class NotificationHelper {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 1. Request permissions for iOS and Android 13+
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted notification permission');
    }

    // 2. Set up local notifications for foreground alerts
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logoremovebg');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle local notification tap in the foreground if needed
        _handleNotificationClick(response.payload);
      },
    );

    // Create Android Notification Channel for heads-up notifications
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // 3. Register background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 4. Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        _localNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android?.smallIcon ?? 'logoremovebg',
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });

    // 5. Handle app opened from background state via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App opened via notification: ${message.data}');
      _handleNotificationClick(message.data.toString());
    });

    // 6. Handle app opened from terminated state via notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log(
        'App launched from terminated state via notification: ${initialMessage.data}',
      );
      _handleNotificationClick(initialMessage.data.toString());
    }

    // 7. Watch for token refresh and automatically sync
    _messaging.onTokenRefresh.listen((newToken) {
      log("FCM Token Refreshed: $newToken");
      sendTokenToBackend(newToken);
    });
  }

  /// Sends the device FCM token to the Node.js backend if a user is logged in.
  static Future<void> sendTokenToBackend([String? token]) async {
    try {
      final fcmToken = token ?? await _messaging.getToken();
      if (fcmToken == null) return;

      final prefs = getIt<SharedPrefHelper>();
      final userToken = await prefs.getSecureData(SharedPrefKey.token);

      if (userToken != null && userToken.isNotEmpty) {
        final apiService = getIt<ApiService>();
        await apiService.updateFcmToken("Bearer $userToken", {
          "fcmToken": fcmToken,
        });
        log("FCM token successfully registered on backend.");
      }
    } catch (e) {
      log("Failed to register FCM token: $e");
    }
  }

  /// Helper logic to route to screen based on payload type
  static void _handleNotificationClick(String? payload) {
    if (payload == null) return;
    // Parse data properties and handle navigation using appNavigatorKey
    log("Clicked Notification Payload: $payload");
  }
}
