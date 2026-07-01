// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_outfit_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyOutfitRequestModel _$DailyOutfitRequestModelFromJson(
  Map<String, dynamic> json,
) => DailyOutfitRequestModel(
  userId: json['user_id'] as String,
  occasion: json['occasion'] as String,
  season: json['season'] as String,
);

Map<String, dynamic> _$DailyOutfitRequestModelToJson(
  DailyOutfitRequestModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'occasion': instance.occasion,
  'season': instance.season,
};
