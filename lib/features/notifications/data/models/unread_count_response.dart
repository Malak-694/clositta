import 'package:json_annotation/json_annotation.dart';

part 'unread_count_response.g.dart';

@JsonSerializable()
class UnreadCountResponse {
  final int unreadCount;

  UnreadCountResponse({required this.unreadCount});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UnreadCountResponseToJson(this);
}