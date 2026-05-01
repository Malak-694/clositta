import 'package:json_annotation/json_annotation.dart';

part 'cancel_order_request_model.g.dart';

@JsonSerializable()
class CancelOrderRequestModel {
  String? reason;

  CancelOrderRequestModel({this.reason});

  factory CancelOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CancelOrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CancelOrderRequestModelToJson(this);
}
