import 'package:json_annotation/json_annotation.dart';


part 'offer_model.g.dart';


@JsonSerializable()
class Tailor {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String phone;

  Tailor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Tailor.fromJson(Map<String, dynamic> json) =>
      _$TailorFromJson(json);

  Map<String, dynamic> toJson() => _$TailorToJson(this);
}

@JsonSerializable()
class OfferResponse {
  @JsonKey(name: '_id')
  final String id;
  final String bid;
  final Tailor tailor;
  final int price;
  final int timeInDays;
  final String message;

  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(name: '__v')
  final int version;

  OfferResponse({
    required this.id,
    required this.bid,
    required this.tailor,
    required this.price,
    required this.timeInDays,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferResponseToJson(this);
}
