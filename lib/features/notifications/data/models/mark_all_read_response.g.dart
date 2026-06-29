// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_all_read_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkAllReadResponse _$MarkAllReadResponseFromJson(Map<String, dynamic> json) =>
    MarkAllReadResponse(
      message: json['message'] as String?,
      modifiedCount: (json['modifiedCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MarkAllReadResponseToJson(
  MarkAllReadResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'modifiedCount': instance.modifiedCount,
};
