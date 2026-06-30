// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'closet_item_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClosetItemResponseModel _$ClosetItemResponseModelFromJson(
  Map<String, dynamic> json,
) => ClosetItemResponseModel(
  id: json['_id'] as String?,
  user: json['user'] as String?,
  name: json['name'] as String?,
  category: json['category'] as String?,
  season: json['season'] as String?,
  occasion: json['occasion'] as String?,
  color: json['color'] as String?,
  imageUrl: json['imageUrl'] as String?,
  imageFileId: json['imageFileId'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  v: (json['__v'] as num?)?.toInt(),
);

Map<String, dynamic> _$ClosetItemResponseModelToJson(
  ClosetItemResponseModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'user': instance.user,
  'name': instance.name,
  'category': instance.category,
  'season': instance.season,
  'occasion': instance.occasion,
  'color': instance.color,
  'imageUrl': instance.imageUrl,
  'imageFileId': instance.imageFileId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  '__v': instance.v,
};
