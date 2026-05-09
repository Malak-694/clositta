import 'package:json_annotation/json_annotation.dart';

part 'order_request_model.g.dart';

@JsonSerializable()
class OrderRequestModel {
  /// Sent as [paymentMethod] in the place-order API body.
  static const String paymentCredit = 'credit';

  /// Cash on delivery — sent as [paymentMethod].
  static const String paymentCashOnDelivery = 'cash_on_delivery';

  String? fullName;
  String? phone;
  String? address;
  String? city;
  String? governorate;
  String? postalCode;
  String? notes;
  String? paymentMethod;

  OrderRequestModel({
    this.fullName,
    this.phone,
    this.address,
    this.city,
    this.governorate,
    this.postalCode,
    this.notes,
    this.paymentMethod,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRequestModelToJson(this);
}
