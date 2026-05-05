import 'package:json_annotation/json_annotation.dart';

part 'top_customer_model.g.dart';

@JsonSerializable()
class TopCustomerModel {
  final int totalSpent;
  final int totalOrders;
  final String customerId;
  final String name;
  final String email;

  TopCustomerModel({
    required this.totalSpent,
    required this.totalOrders,
    required this.customerId,
    required this.name,
    required this.email,
  });

  factory TopCustomerModel.fromJson(Map<String, dynamic> json) =>
      _$TopCustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopCustomerModelToJson(this);
}
