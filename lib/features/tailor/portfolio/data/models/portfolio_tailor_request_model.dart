import 'package:json_annotation/json_annotation.dart';
part 'portfolio_tailor_request_model.g.dart';

@JsonSerializable()
class PortfolioTailorRequestModel {
  final String title;
  final String category;
  final String description;

  PortfolioTailorRequestModel({
    required this.title,
    required this.category,
    required this.description,
  });

  factory PortfolioTailorRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioTailorRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$PortfolioTailorRequestModelToJson(this);
}