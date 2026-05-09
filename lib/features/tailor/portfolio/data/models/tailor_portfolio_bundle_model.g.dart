// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tailor_portfolio_bundle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TailorPortfolioBundleModel _$TailorPortfolioBundleModelFromJson(
  Map<String, dynamic> json,
) => TailorPortfolioBundleModel(
  tailor: PortfolioTailorUserModel.fromJson(
    json['tailor'] as Map<String, dynamic>,
  ),
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => PortfolioTailorResponseModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$TailorPortfolioBundleModelToJson(
  TailorPortfolioBundleModel instance,
) => <String, dynamic>{
  'tailor': instance.tailor.toJson(),
  'items': instance.items.map((e) => e.toJson()).toList(),
};
