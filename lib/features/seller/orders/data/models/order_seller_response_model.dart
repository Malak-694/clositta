import 'package:json_annotation/json_annotation.dart';

part 'order_seller_response_model.g.dart';

@JsonSerializable()
class OrderSellerResponseModel {
  @JsonKey(name: '_id')
  String? id;
  UserSummarySellerViewModel? user;
  List<OrderItemWithPopulatedProductModel>? items;
  ShippingAddressSellerOrderModel? shippingAddress;
  String? paymentMethod;
  String? paymentStatus;
  String? orderStatus;
  int? itemsTotal;
  int? shippingFee;
  int? totalAmount;
  String? cancelReason;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? iV;

  OrderSellerResponseModel({
    this.id,
    this.user,
    this.items,
    this.shippingAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.orderStatus,
    this.itemsTotal,
    this.shippingFee,
    this.totalAmount,
    this.cancelReason,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory OrderSellerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderSellerResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSellerResponseModelToJson(this);
}

@JsonSerializable()
class UserSummarySellerViewModel {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? email;
  String? phone;

  UserSummarySellerViewModel({this.id, this.name, this.email, this.phone});

  factory UserSummarySellerViewModel.fromJson(Map<String, dynamic> json) =>
      _$UserSummarySellerViewModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSummarySellerViewModelToJson(this);
}

@JsonSerializable()
class OrderItemWithPopulatedProductModel {
  OrderItemProductSellerModel? product;
  String? name;
  String? imageUrl;
  int? price;
  int? quantity;
  int? subtotal;
  @JsonKey(name: '_id')
  String? id;

  OrderItemWithPopulatedProductModel({
    this.product,
    this.name,
    this.imageUrl,
    this.price,
    this.quantity,
    this.subtotal,
    this.id,
  });

  factory OrderItemWithPopulatedProductModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$OrderItemWithPopulatedProductModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrderItemWithPopulatedProductModelToJson(this);
}

@JsonSerializable()
class OrderItemProductSellerModel {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? imageUrl;
  int? price;

  OrderItemProductSellerModel({this.id, this.name, this.imageUrl, this.price});

  factory OrderItemProductSellerModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemProductSellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemProductSellerModelToJson(this);
}

@JsonSerializable()
class ShippingAddressSellerOrderModel {
  String? fullName;
  String? phone;
  String? address;
  String? city;
  String? governorate;
  String? postalCode;
  String? notes;

  ShippingAddressSellerOrderModel({
    this.fullName,
    this.phone,
    this.address,
    this.city,
    this.governorate,
    this.postalCode,
    this.notes,
  });

  factory ShippingAddressSellerOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressSellerOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressSellerOrderModelToJson(this);
}
