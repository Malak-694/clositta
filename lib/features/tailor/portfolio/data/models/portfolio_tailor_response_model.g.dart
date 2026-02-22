// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_tailor_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioTailorResponseModel _$PortfolioTailorResponseModelFromJson(
  Map<String, dynamic> json,
) => PortfolioTailorResponseModel(
  id: json['_id'] as String?,
  tailor: json['tailor'] as String?,
  title: json['title'] as String?,
  category: json['category'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  imageFileId: json['imageFileId'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  iV: (json['__v'] as num?)?.toInt(),
);

Map<String, dynamic> _$PortfolioTailorResponseModelToJson(
  PortfolioTailorResponseModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'tailor': instance.tailor,
  'title': instance.title,
  'category': instance.category,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'imageFileId': instance.imageFileId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  '__v': instance.iV,
};
