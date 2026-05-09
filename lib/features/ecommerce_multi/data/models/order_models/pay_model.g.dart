// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentInitiateRequestModel _$PaymentInitiateRequestModelFromJson(
  Map<String, dynamic> json,
) => PaymentInitiateRequestModel(orderId: json['orderId'] as String);

Map<String, dynamic> _$PaymentInitiateRequestModelToJson(
  PaymentInitiateRequestModel instance,
) => <String, dynamic>{'orderId': instance.orderId};

PaymentInitiateResponseModel _$PaymentInitiateResponseModelFromJson(
  Map<String, dynamic> json,
) => PaymentInitiateResponseModel(
  iframeUrl: json['iframeUrl'] as String?,
  paymentKey: json['paymentKey'] as String?,
);

Map<String, dynamic> _$PaymentInitiateResponseModelToJson(
  PaymentInitiateResponseModel instance,
) => <String, dynamic>{
  'iframeUrl': instance.iframeUrl,
  'paymentKey': instance.paymentKey,
};
