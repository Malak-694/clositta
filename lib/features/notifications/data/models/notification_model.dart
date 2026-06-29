import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';


@JsonSerializable()
class NotificationData {
  final String? bidId;
  final String? offerId;
  final String? notificationId;
  final String? orderId;
  final String? productId;

  NotificationData({
    this.bidId,
    this.offerId,
    this.notificationId,
    this.orderId,
    this.productId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: '_id')
  final String id;
  final String recipient;
  final String type;
  final String title;
  final String body;
  final NotificationData? data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.recipient,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}


