// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['_id'] as String?,
      content: json['content'] as String?,
      sender: json['sender'] == null
          ? null
          : UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: json['receiver'] == null
          ? null
          : UserModel.fromJson(json['receiver'] as Map<String, dynamic>),
      conversationId: json['conversationId'] as String?,
      isRead: json['isRead'] as bool?,
      isEdited: json['isEdited'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'conversationId': instance.conversationId,
      'isRead': instance.isRead,
      'isEdited': instance.isEdited,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  imageUrl: json['imageUrl'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'role': instance.role,
};
