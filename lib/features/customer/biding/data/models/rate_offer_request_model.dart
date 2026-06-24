import 'package:json_annotation/json_annotation.dart';

part 'rate_offer_request_model.g.dart';

@JsonSerializable()
class RateOfferRequestModel {
  final int rating;
  final String? comment;

  RateOfferRequestModel({required this.rating, this.comment});

  factory RateOfferRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RateOfferRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RateOfferRequestModelToJson(this);
}