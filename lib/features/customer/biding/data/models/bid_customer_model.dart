import 'package:json_annotation/json_annotation.dart';

part 'bid_customer_model.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String phone;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}



@JsonSerializable()
class BidResponse {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'customer')
  final String customerId;  // Change from Customer to String

  final String requestDescription;
  final String imageUrl;
  final double? price;
  final String? time;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(name: '__v')
  final int version;

  BidResponse({
    required this.id,
    required this.customerId,  // Updated parameter
    required this.requestDescription,
    required this.imageUrl,
    this.price,
    this.time,
    this.status = 'open',
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory BidResponse.fromJson(Map<String, dynamic> json) =>
      _$BidResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BidResponseToJson(this);
}