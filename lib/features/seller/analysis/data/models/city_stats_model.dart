import 'package:json_annotation/json_annotation.dart';

part 'city_stats_model.g.dart';

@JsonSerializable()
class CityStatsModel {
  final int orders;
  final int revenue;
  final String city;

  
    CityStatsModel({
    required this.orders,
    required this.revenue,
    required this.city,
  });

  factory CityStatsModel.fromJson(Map<String, dynamic> json) =>
      _$CityStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityStatsModelToJson(this);
}