import 'package:json_annotation/json_annotation.dart';

part 'complete_outfit_request_model.g.dart';

@JsonSerializable()
class CompleteOutfitRequestModel {
  final String occasion;
  final String season;
  final String color;
  final String gender;
  final List<String> categories;
  final Map<String, dynamic> limits;

  CompleteOutfitRequestModel({
    required this.occasion,
    required this.season,
    required this.color,
    required this.gender,
    this.categories = const [],
    this.limits = const {},
  });

  factory CompleteOutfitRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CompleteOutfitRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteOutfitRequestModelToJson(this);
}