import 'package:json_annotation/json_annotation.dart';

part 'overview_model.g.dart';

@JsonSerializable()
class OverviewModel {
  final int totalRevenue;
  final int totalOrders;
  final int cancelledOrders;
  final int totalItemsSold;
  final int totalShippingCollected;

  OverviewModel({
    required this.totalRevenue,
    required this.totalOrders,
    required this.cancelledOrders,
    required this.totalItemsSold,
    required this.totalShippingCollected,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) =>
      _$OverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$OverviewModelToJson(this);
}