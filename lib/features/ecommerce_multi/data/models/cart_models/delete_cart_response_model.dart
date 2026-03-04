import 'package:chicora/features/ecommerce_multi/data/models/cart_models/cart_response_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'delete_cart_response_model.g.dart';
@JsonSerializable()
class DeleteCartResponseModel {
  String? message;
  CartResponseModel? cart;

  DeleteCartResponseModel({this.message, this.cart});
  factory DeleteCartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteCartResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteCartResponseModelToJson(this);
}
