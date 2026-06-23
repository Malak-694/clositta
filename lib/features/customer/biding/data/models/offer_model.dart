import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';

@JsonSerializable()
class Tailor {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? email;
  final String? phone;

  Tailor({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory Tailor.fromJson(Map<String, dynamic> json) =>
      _$TailorFromJson(json);

  Map<String, dynamic> toJson() => _$TailorToJson(this);
}

@JsonSerializable()
class OfferResponse {
  @JsonKey(name: '_id')
  final String? id;
  final String? bid;
  final Tailor? tailor;
  final int? price;
  final int? timeInDays;
  final String? message;
  final String? status;
  final String? workStatus;   // 👈 in_progress / completed / accepted
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @JsonKey(name: '__v')
  final int? version;

  OfferResponse({
    this.id,
    this.bid,
    this.tailor,
    this.price,
    this.timeInDays,
    this.message,
    this.status,
    this.workStatus,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  bool get isAccepted => status == "accepted";

  factory OfferResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferResponseToJson(this);
}