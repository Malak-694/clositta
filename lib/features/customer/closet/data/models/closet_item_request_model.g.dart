// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'closet_item_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClosetItemRequestModel _$ClosetItemRequestModelFromJson(
  Map<String, dynamic> json,
) => ClosetItemRequestModel(
  image: json['image'] as String?,
  name: json['name'] as String,
  category: json['category'] as String,
  season: json['season'] as String,
  occasion: json['occasion'] as String,
  color: json['color'] as String,
);

Map<String, dynamic> _$ClosetItemRequestModelToJson(
  ClosetItemRequestModel instance,
) => <String, dynamic>{
  'image': instance.image,
  'name': instance.name,
  'category': instance.category,
  'season': instance.season,
  'occasion': instance.occasion,
  'color': instance.color,
};
