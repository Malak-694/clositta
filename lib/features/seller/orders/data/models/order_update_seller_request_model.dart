import 'package:json_annotation/json_annotation.dart';

part 'order_update_seller_request_model.g.dart';

@JsonSerializable(createToJson: false)
class OrderUpdateSellerRequestModel {
  String? orderStatus;

  OrderUpdateSellerRequestModel({this.orderStatus});

  factory OrderUpdateSellerRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderUpdateSellerRequestModelFromJson(json);

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    if (orderStatus != null) m['orderStatus'] = orderStatus;
    return m;
  }
}
