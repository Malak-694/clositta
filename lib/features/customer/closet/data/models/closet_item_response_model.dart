import 'package:json_annotation/json_annotation.dart';

part 'closet_item_response_model.g.dart';

@JsonSerializable()
class ClosetItemResponseModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? user;
  final String? name;
  final String? category;
  final String? season;
  final String? color;
  final String? imageUrl;
  final String? imageFileId;
  final String? createdAt;
  final String? updatedAt;
  @JsonKey(name: '__v')
  final int? v;

  ClosetItemResponseModel({
    this.id,
    this.user,
    this.name,
    this.category,
    this.season,
    this.color,
    this.imageUrl,
    this.imageFileId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ClosetItemResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ClosetItemResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClosetItemResponseModelToJson(this);
}
