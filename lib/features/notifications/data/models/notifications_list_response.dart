import 'package:json_annotation/json_annotation.dart';

import 'notification_model.dart';

part 'notifications_list_response.g.dart';


@JsonSerializable()
class PaginationModel {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}

@JsonSerializable()
class NotificationsListResponse {
  final List<NotificationModel> notifications;
  final PaginationModel pagination;

  NotificationsListResponse({
    required this.notifications,
    required this.pagination,
  });

  factory NotificationsListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsListResponseToJson(this);
}
