import 'package:json_annotation/json_annotation.dart';

part 'pay_model.g.dart';

@JsonSerializable()
class PaymentInitiateRequestModel {
  PaymentInitiateRequestModel({required this.orderId});

  final String orderId;

  Map<String, dynamic> toJson() => _$PaymentInitiateRequestModelToJson(this);

  factory PaymentInitiateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInitiateRequestModelFromJson(json);
}

@JsonSerializable()
class PaymentInitiateResponseModel {
  PaymentInitiateResponseModel({this.iframeUrl, this.paymentKey});

  final String? iframeUrl;
  final String? paymentKey;

  factory PaymentInitiateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInitiateResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInitiateResponseModelToJson(this);
}
