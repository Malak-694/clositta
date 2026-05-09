// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_tailor_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioTailorUserModel _$PortfolioTailorUserModelFromJson(
  Map<String, dynamic> json,
) => PortfolioTailorUserModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  imageUrl: json['imageUrl'] as String?,
  location: json['location'] as String?,
  mapsUrl: json['mapsUrl'] as String?,
);

Map<String, dynamic> _$PortfolioTailorUserModelToJson(
  PortfolioTailorUserModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'imageUrl': instance.imageUrl,
  'location': instance.location,
  'mapsUrl': instance.mapsUrl,
};
