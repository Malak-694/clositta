import 'package:json_annotation/json_annotation.dart';
import 'chat_message_model.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel {
  final LastMessageModel? lastMessage;
  final int?              unreadCount;
  final UserModel?        otherUser;   // ✅ directly from API response

  ConversationModel({
    this.lastMessage,
    this.unreadCount,
    this.otherUser,
  });

  String?   get lastMessageContent => lastMessage?.content;
  DateTime? get lastMessageAt      => lastMessage?.createdAt;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}

@JsonSerializable()
class LastMessageModel {
  final String?   content;
  final String?   sender;
  final String?   receiver;
  final bool?     isRead;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  LastMessageModel({
    this.content,
    this.sender,
    this.receiver,
    this.isRead,
    this.createdAt,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) =>
      _$LastMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageModelToJson(this);
}