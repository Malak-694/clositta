import 'package:json_annotation/json_annotation.dart';
import 'package:chicora/features/tailor/portfolio/data/models/portfolio_tailor_response_model.dart';
import 'package:chicora/features/tailor/portfolio/data/models/portfolio_tailor_user_model.dart';

part 'tailor_portfolio_bundle_model.g.dart';

/// GET /portfolio/my and GET /portfolio/tailor/:tailorId envelope.
@JsonSerializable(explicitToJson: true)
class TailorPortfolioBundleModel {
  final PortfolioTailorUserModel tailor;
  final List<PortfolioTailorResponseModel> items;

  const TailorPortfolioBundleModel({
    required this.tailor,
    required this.items,
  });

  factory TailorPortfolioBundleModel.fromJson(Map<String, dynamic> json) =>
      _$TailorPortfolioBundleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TailorPortfolioBundleModelToJson(this);
}
