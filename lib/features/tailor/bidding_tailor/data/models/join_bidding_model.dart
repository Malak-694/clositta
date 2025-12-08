import 'package:json_annotation/json_annotation.dart';

part 'join_bidding_model.g.dart';
@JsonSerializable()
class JoinBiddingRequest {
  int? price;
  int? timeInDays;
  String? message;

  JoinBiddingRequest({this.price, this.timeInDays, this.message});
  factory JoinBiddingRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinBiddingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$JoinBiddingRequestToJson(this);
}
@JsonSerializable()
class JoinBiddingResponse {
  String? message;

  JoinBiddingResponse({this.message});
  factory JoinBiddingResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinBiddingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JoinBiddingResponseToJson(this);
}