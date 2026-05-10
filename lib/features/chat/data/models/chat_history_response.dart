import 'package:json_annotation/json_annotation.dart';
import 'chat_message_model.dart';

part 'chat_history_response.g.dart';

@JsonSerializable()
class ChatHistoryResponseModel {
  final UserModel?             otherUser;
  final List<ChatMessageModel>? messages;
  final PaginationModel?       pagination;

  ChatHistoryResponseModel({
    this.otherUser,
    this.messages,
    this.pagination,
  });

  factory ChatHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHistoryResponseModelToJson(this);
}

@JsonSerializable()
class PaginationModel {
  final int? total;
  final int? page;
  final int? pages;

  PaginationModel({this.total, this.page, this.pages});

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}