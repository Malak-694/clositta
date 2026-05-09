// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioItem _$PortfolioItemFromJson(Map<String, dynamic> json) =>
    PortfolioItem(
      id: json['_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      imageFileId: json['imageFileId'] as String,
      tailor: TailorInfo.fromJson(json['tailor'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$PortfolioItemToJson(PortfolioItem instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'imageFileId': instance.imageFileId,
      'tailor': instance.tailor,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

TailorInfo _$TailorInfoFromJson(Map<String, dynamic> json) => TailorInfo(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$TailorInfoToJson(TailorInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
