// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_outfit_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteOutfitResponseModel _$CompleteOutfitResponseModelFromJson(
  Map<String, dynamic> json,
) => CompleteOutfitResponseModel(
  season: json['season'] as String,
  occasion: json['occasion'] as String,
  color: json['color'] as String,
  results: (json['results'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => OutfitItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$CompleteOutfitResponseModelToJson(
  CompleteOutfitResponseModel instance,
) => <String, dynamic>{
  'season': instance.season,
  'occasion': instance.occasion,
  'color': instance.color,
  'results': instance.results,
};
