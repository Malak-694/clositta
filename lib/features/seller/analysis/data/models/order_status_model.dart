import 'package:json_annotation/json_annotation.dart';

part 'order_status_model.g.dart';

@JsonSerializable()
class OrderStatusBreakdownModel {
  final int count;
  final String status;

  OrderStatusBreakdownModel({
    required this.count,
    required this.status,
  });

  factory OrderStatusBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusBreakdownModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusBreakdownModelToJson(this); 
}