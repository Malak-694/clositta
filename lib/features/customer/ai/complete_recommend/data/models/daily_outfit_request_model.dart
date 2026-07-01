import 'package:json_annotation/json_annotation.dart';

part 'daily_outfit_request_model.g.dart';

@JsonSerializable()
class DailyOutfitRequestModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String occasion;
  final String season;

  DailyOutfitRequestModel({
    required this.userId,
    required this.occasion,
    required this.season,
  });

  factory DailyOutfitRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DailyOutfitRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyOutfitRequestModelToJson(this);
}