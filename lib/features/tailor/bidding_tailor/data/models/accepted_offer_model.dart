import 'package:json_annotation/json_annotation.dart';

part 'accepted_offer_model.g.dart';

@JsonSerializable()
class AcceptedOfferCustomer {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String phone;

  AcceptedOfferCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory AcceptedOfferCustomer.fromJson(Map<String, dynamic> json) =>
      _$AcceptedOfferCustomerFromJson(json);
  Map<String, dynamic> toJson() => _$AcceptedOfferCustomerToJson(this);
}

@JsonSerializable()
class AcceptedOfferBid {
  @JsonKey(name: '_id')
  final String id;
  final String requestDescription;
  final AcceptedOfferCustomer customer;
  final String? imageUrl;
  final double? price;

  AcceptedOfferBid({
    required this.id,
    required this.requestDescription,
    required this.customer,
    this.imageUrl,
    this.price,
  });

  factory AcceptedOfferBid.fromJson(Map<String, dynamic> json) =>
      _$AcceptedOfferBidFromJson(json);
  Map<String, dynamic> toJson() => _$AcceptedOfferBidToJson(this);
}

@JsonSerializable()
class AcceptedOfferResponse {
  @JsonKey(name: '_id')
  final String id;
  final AcceptedOfferBid bid;
  final int price;
  final int timeInDays;
  final String message;
  final String status;
  final String? workStatus;
  final DateTime? deadline;
  final int? daysRemaining;
  final bool? isOverdue;
  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(name: '__v')
  final int version;

  AcceptedOfferResponse({
    required this.id,
    required this.bid,
    required this.price,
    required this.timeInDays,
    required this.message,
    this.status = 'accepted',
    this.workStatus,
    this.deadline,
    this.daysRemaining,
    this.isOverdue,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory AcceptedOfferResponse.fromJson(Map<String, dynamic> json) =>
      _$AcceptedOfferResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AcceptedOfferResponseToJson(this);
}