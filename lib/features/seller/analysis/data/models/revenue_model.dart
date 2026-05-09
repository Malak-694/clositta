import 'package:json_annotation/json_annotation.dart';

part 'revenue_model.g.dart';

@JsonSerializable()
class RevenuePeriodModel {
  final int revenue;
  final int orders;
  final int year;

  // month version
  final int? month;
  final String? monthName;

  // week version
  final int? week;
  final String? label;

  RevenuePeriodModel({
    required this.revenue,
    required this.orders,
    required this.year,
    this.month,
    this.monthName,
    this.week,
    this.label,
  });

  factory RevenuePeriodModel.fromJson(Map<String, dynamic> json) =>
      _$RevenuePeriodModelFromJson(json);

  Map<String, dynamic> toJson() => _$RevenuePeriodModelToJson(this);
}