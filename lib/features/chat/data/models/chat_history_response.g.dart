// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHistoryResponseModel _$ChatHistoryResponseModelFromJson(
  Map<String, dynamic> json,
) => ChatHistoryResponseModel(
  otherUser: json['otherUser'] == null
      ? null
      : UserModel.fromJson(json['otherUser'] as Map<String, dynamic>),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: json['pagination'] == null
      ? null
      : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatHistoryResponseModelToJson(
  ChatHistoryResponseModel instance,
) => <String, dynamic>{
  'otherUser': instance.otherUser,
  'messages': instance.messages,
  'pagination': instance.pagination,
};

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pages: (json['pages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'pages': instance.pages,
    };
