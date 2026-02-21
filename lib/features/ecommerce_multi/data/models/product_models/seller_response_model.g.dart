// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerModel _$SellerModelFromJson(Map<String, dynamic> json) => SellerModel(
  sId: json['_id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$SellerModelToJson(SellerModel instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'name': instance.name,
      'email': instance.email,
    };
