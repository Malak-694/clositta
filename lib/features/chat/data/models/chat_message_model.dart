// lib/features/chat/data/models/chat_message_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? content;        // ← backend uses 'content' not 'message'
  final UserModel? sender;
  final UserModel? receiver;
  final String? conversationId;
  final bool? isRead;
  final bool? isEdited;
  final bool? isDeleted;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  ChatMessageModel({
    this.id,
    this.content,
    this.sender,
    this.receiver,
    this.conversationId,
    this.isRead,
    this.isEdited,
    this.isDeleted,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? role;

  UserModel({this.id, this.name, this.imageUrl, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}