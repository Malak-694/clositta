import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_request_model.g.dart';
@JsonSerializable()
class RatingRequestModel {
  int? rating;
  String? comment;
  RatingRequestModel(this.rating, this.comment);
  factory RatingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RatingRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RatingRequestModelToJson(this);
}
