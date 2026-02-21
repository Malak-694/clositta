import 'package:freezed_annotation/freezed_annotation.dart';
part 'rating_response_model.g.dart';

@JsonSerializable()
class RatingResponseModel {
  String? message;
  int? averageRating;
  int? totalRatings;
  Map<String, int>? ratingDistribution;

  RatingResponseModel({
    this.message,
    this.averageRating,
    this.totalRatings,
    this.ratingDistribution,
  });
  factory RatingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RatingResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RatingResponseModelToJson(this);
}
