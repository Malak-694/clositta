import 'package:json_annotation/json_annotation.dart';

part 'mark_all_read_response.g.dart';

@JsonSerializable()
class MarkAllReadResponse {
  final String? message;
  final int? modifiedCount;

  MarkAllReadResponse({this.message, this.modifiedCount});

  factory MarkAllReadResponse.fromJson(Map<String, dynamic> json) =>
      _$MarkAllReadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MarkAllReadResponseToJson(this);
}