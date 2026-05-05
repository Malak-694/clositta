import 'package:json_annotation/json_annotation.dart';

part 'order_update_seller_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class OrderUpdateSellerRequestModel {
  String? orderStatus;
  String? paymentStatus;

  OrderUpdateSellerRequestModel({this.orderStatus, this.paymentStatus});

  factory OrderUpdateSellerRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderUpdateSellerRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderUpdateSellerRequestModelToJson(this);
}
