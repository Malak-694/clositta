// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      lastMessage: json['lastMessage'] == null
          ? null
          : LastMessageModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>,
            ),
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      otherUser: json['otherUser'] == null
          ? null
          : UserModel.fromJson(json['otherUser'] as Map<String, dynamic>),
      lastMessageType: json['lastMessageType'] as String?,
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'otherUser': instance.otherUser,
      'lastMessageType': instance.lastMessageType,
    };

LastMessageModel _$LastMessageModelFromJson(Map<String, dynamic> json) =>
    LastMessageModel(
      content: json['content'] as String?,
      sender: json['sender'] as String?,
      receiver: json['receiver'] as String?,
      isRead: json['isRead'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LastMessageModelToJson(LastMessageModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
