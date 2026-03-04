import 'package:json_annotation/json_annotation.dart';
part 'cart_request_model.g.dart';
@JsonSerializable()
class CartRequestModel {
  String? productId;
  int? quantity;

  CartRequestModel({this.productId, this.quantity});

  factory CartRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CartRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartRequestModelToJson(this);
}