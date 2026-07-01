// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_outfit_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteOutfitRequestModel _$CompleteOutfitRequestModelFromJson(
  Map<String, dynamic> json,
) => CompleteOutfitRequestModel(
  occasion: json['occasion'] as String,
  season: json['season'] as String,
  color: json['color'] as String,
  gender: json['gender'] as String,
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  limits: json['limits'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$CompleteOutfitRequestModelToJson(
  CompleteOutfitRequestModel instance,
) => <String, dynamic>{
  'occasion': instance.occasion,
  'season': instance.season,
  'color': instance.color,
  'gender': instance.gender,
  'categories': instance.categories,
  'limits': instance.limits,
};
