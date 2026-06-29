import 'package:json_annotation/json_annotation.dart';

part 'notification_preferences.g.dart';

@JsonSerializable()
class NotificationPreferences {
  final bool orderUpdates;
  final bool bidUpdates;
  final bool offerUpdates;
  final bool lowStockAlerts;

  NotificationPreferences({
    required this.orderUpdates,
    required this.bidUpdates,
    required this.offerUpdates,
    required this.lowStockAlerts,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);
}

@JsonSerializable()
class NotificationPreferencesResponse {
  final NotificationPreferences notificationPreferences;

  NotificationPreferencesResponse({required this.notificationPreferences});

  factory NotificationPreferencesResponse.fromJson(
      Map<String, dynamic> json) =>
      _$NotificationPreferencesResponseFromJson(json);
  Map<String, dynamic> toJson() =>
      _$NotificationPreferencesResponseToJson(this);
}

@JsonSerializable()
class UpdatePreferencesResponse {
  final String? message;
  final NotificationPreferences? notificationPreferences;

  UpdatePreferencesResponse({this.message, this.notificationPreferences});

  factory UpdatePreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatePreferencesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePreferencesResponseToJson(this);
}
