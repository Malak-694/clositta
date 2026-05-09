import 'package:json_annotation/json_annotation.dart';

part 'avg_order_model.g.dart';

@JsonSerializable()
class AvgOrderValueModel {
  final int avgOrderValue;
  final int avgWithShipping;

  AvgOrderValueModel ({required this.avgOrderValue, required this.avgWithShipping});

  factory AvgOrderValueModel.fromJson(Map<String, dynamic> json) =>
      _$AvgOrderValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvgOrderValueModelToJson(this);
}
