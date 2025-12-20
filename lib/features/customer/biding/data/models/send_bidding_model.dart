import 'package:json_annotation/json_annotation.dart';

part 'send_bidding_model.g.dart';

@JsonSerializable()
class SendBiddingModel {
  @JsonKey(name: 'requestDescription')
  final String description;
  final double? price;
  final String? time;
  final String imageUrl;

  SendBiddingModel({
    required this.description,
    this.price,
    this.time,
    required this.imageUrl,
  });

  factory SendBiddingModel.fromJson(Map<String, dynamic> json) =>
      _$SendBiddingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendBiddingModelToJson(this);
}