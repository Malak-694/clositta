// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => NotificationPreferences(
  orderUpdates: json['orderUpdates'] as bool,
  bidUpdates: json['bidUpdates'] as bool,
  offerUpdates: json['offerUpdates'] as bool,
  lowStockAlerts: json['lowStockAlerts'] as bool,
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  NotificationPreferences instance,
) => <String, dynamic>{
  'orderUpdates': instance.orderUpdates,
  'bidUpdates': instance.bidUpdates,
  'offerUpdates': instance.offerUpdates,
  'lowStockAlerts': instance.lowStockAlerts,
};

NotificationPreferencesResponse _$NotificationPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => NotificationPreferencesResponse(
  notificationPreferences: NotificationPreferences.fromJson(
    json['notificationPreferences'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$NotificationPreferencesResponseToJson(
  NotificationPreferencesResponse instance,
) => <String, dynamic>{
  'notificationPreferences': instance.notificationPreferences,
};

UpdatePreferencesResponse _$UpdatePreferencesResponseFromJson(
  Map<String, dynamic> json,
) => UpdatePreferencesResponse(
  message: json['message'] as String?,
  notificationPreferences: json['notificationPreferences'] == null
      ? null
      : NotificationPreferences.fromJson(
          json['notificationPreferences'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UpdatePreferencesResponseToJson(
  UpdatePreferencesResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'notificationPreferences': instance.notificationPreferences,
};
