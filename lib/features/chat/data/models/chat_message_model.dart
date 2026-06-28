import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

UserModel? _userFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return UserModel(id: value);
  if (value is Map<String, dynamic>) return UserModel.fromJson(value);
  return null;
}

@JsonSerializable()
class ChatMessageModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? content;
  final String? imageUrl;
  final String? messageType;

  @JsonKey(fromJson: _userFromJson)
  final UserModel? sender;

  @JsonKey(fromJson: _userFromJson)
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
    this.imageUrl,
    this.messageType,
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