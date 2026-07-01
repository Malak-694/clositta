import 'package:json_annotation/json_annotation.dart';

import 'daily_outfit_response_model.dart';

part 'complete_outfit_response_model.g.dart';

@JsonSerializable()
class CompleteOutfitResponseModel {
  final String season;
  final String occasion;
  final String color;
  final Map<String, List<OutfitItemModel>> results;

  CompleteOutfitResponseModel({
    required this.season,
    required this.occasion,
    required this.color,
    required this.results,
  });

  factory CompleteOutfitResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CompleteOutfitResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteOutfitResponseModelToJson(this);

  List<Map<String, OutfitItemModel>> buildOutfits() => results.buildOutfits();
}