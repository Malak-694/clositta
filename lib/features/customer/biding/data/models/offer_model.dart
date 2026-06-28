import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';

@JsonSerializable()
class Tailor {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? email;
  final String? phone;

  Tailor({this.id, this.name, this.email, this.phone});

  factory Tailor.fromJson(Map<String, dynamic> json) => _$TailorFromJson(json);
  Map<String, dynamic> toJson() => _$TailorToJson(this);
}

// ── BidNested (bid populated inside offer response) ──────
@JsonSerializable()
class BidNested {
  @JsonKey(name: '_id')
  final String? id;
  final String? customer;
  final String? requestDescription;
  final String? imageUrl;
  final double? price;
  final String? time;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BidNested({
    this.id,
    this.customer,
    this.requestDescription,
    this.imageUrl,
    this.price,
    this.time,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BidNested.fromJson(Map<String, dynamic> json) =>
      _$BidNestedFromJson(json);
  Map<String, dynamic> toJson() => _$BidNestedToJson(this);
}

// ── OfferRating ──────────────────────────────────────────
@JsonSerializable()
class OfferRating {
  final String? user;
  final int? rating;
  final String? comment;

  @JsonKey(name: '_id')
  final String? id;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  OfferRating({
    this.user,
    this.rating,
    this.comment,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory OfferRating.fromJson(Map<String, dynamic> json) =>
      _$OfferRatingFromJson(json);
  Map<String, dynamic> toJson() => _$OfferRatingToJson(this);
}

// ── OfferResponse ────────────────────────────────────────
@JsonSerializable()
class OfferResponse {
  @JsonKey(name: '_id')
  final String? id;

  // bid can be a String ID (tailor flow) or a full BidNested object (customer flow)
  // We store the resolved ID separately for easy map keying
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? bidId;

  @JsonKey(name: 'bid')
  final BidNested? bid;

  final Tailor? tailor;
  final int? price;
  final int? timeInDays;
  final String? message;
  final String? status;
  final String? workStatus;
  final DateTime? deadline;
  final List<OfferRating>? ratings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @JsonKey(name: '__v')
  final int? version;

  OfferResponse({
    this.id,
    this.bidId,
    this.bid,
    this.tailor,
    this.price,
    this.timeInDays,
    this.message,
    this.status,
    this.workStatus,
    this.deadline,
    this.ratings,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  bool get isAccepted => status == "accepted";

  /// Works whether bid is a plain String ID or a full nested object
  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['bid'];

    // If bid is a plain string ID (tailor endpoints return it this way),
    // wrap it into a minimal map so BidNested.fromJson doesn't crash
    if (raw is String) {
      json = {...json, 'bid': <String, dynamic>{'_id': raw}};
    }

    return _$OfferResponseFromJson(json);
  }

  String? get resolvedBidId => bid?.id;

  Map<String, dynamic> toJson() => _$OfferResponseToJson(this);
}