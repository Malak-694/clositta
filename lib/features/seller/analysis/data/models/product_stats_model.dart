import 'package:json_annotation/json_annotation.dart';

part 'product_stats_model.g.dart';

@JsonSerializable()
class ProductStatsModel {
  final String productName;
  final String productImage;
  final int totalQuantitySold;
  final int totalRevenue;
  final int timesOrdered;
  final String productId;

  ProductStatsModel({
    required this.productName,
    required this.productImage,
    required this.totalQuantitySold,
    required this.totalRevenue,
    required this.timesOrdered,
    required this.productId,
  });
  factory ProductStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductStatsModelToJson(this);
}