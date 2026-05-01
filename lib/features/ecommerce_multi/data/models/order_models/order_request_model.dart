import 'package:json_annotation/json_annotation.dart';

part 'order_request_model.g.dart';

@JsonSerializable()
class OrderRequestModel {
  String? fullName;
  String? phone;
  String? address;
  String? city;
  String? governorate;
  String? postalCode;
  String? notes;

  OrderRequestModel({
    this.fullName,
    this.phone,
    this.address,
    this.city,
    this.governorate,
    this.postalCode,
    this.notes,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRequestModelToJson(this);
}
