// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteCartResponseModel _$DeleteCartResponseModelFromJson(
  Map<String, dynamic> json,
) => DeleteCartResponseModel(
  message: json['message'] as String?,
  cart: json['cart'] == null
      ? null
      : CartResponseModel.fromJson(json['cart'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeleteCartResponseModelToJson(
  DeleteCartResponseModel instance,
) => <String, dynamic>{'message': instance.message, 'cart': instance.cart};
