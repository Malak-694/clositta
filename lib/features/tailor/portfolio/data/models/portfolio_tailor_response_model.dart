import 'package:json_annotation/json_annotation.dart';
part 'portfolio_tailor_response_model.g.dart';
@JsonSerializable()
class PortfolioTailorResponseModel {
  @JsonKey(name: '_id')
  String? id;
  String? tailor;
  String? title;
  String? category;
  String? description;
  String? imageUrl;
  String? imageFileId;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? iV;
  PortfolioTailorResponseModel({
    this.id,
    this.tailor,
    this.title,
    this.category,
    this.description,
    this.imageUrl,
    this.imageFileId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });
  factory PortfolioTailorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioTailorResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PortfolioTailorResponseModelToJson(this);

}
