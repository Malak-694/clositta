import 'package:json_annotation/json_annotation.dart';

part 'portfolio_tailor_user_model.g.dart';

/// Populated tailor summary on portfolio payloads (browse, detail, login profile fields overlap).
@JsonSerializable(explicitToJson: true)
class PortfolioTailorUserModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final String? location;
  final String? mapsUrl;

  const PortfolioTailorUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.imageUrl,
    this.location,
    this.mapsUrl,
  });

  factory PortfolioTailorUserModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioTailorUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioTailorUserModelToJson(this);
}
