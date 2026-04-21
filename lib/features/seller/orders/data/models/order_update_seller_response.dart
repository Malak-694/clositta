import 'package:json_annotation/json_annotation.dart';

part 'order_update_seller_response.g.dart';

@JsonSerializable()
class OrderUpdateSellerResponseModel {
  String? message;
  OrderUpdateSellerOrderModel? order;

  OrderUpdateSellerResponseModel({this.message, this.order});

  factory OrderUpdateSellerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderUpdateSellerResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderUpdateSellerResponseModelToJson(this);
}

@JsonSerializable()
class OrderUpdateSellerOrderModel {
  @JsonKey(name: '_id')
  String? id;
  OrderUpdateSellerUserModel? user;
  List<OrderUpdateSellerItemModel>? items;
  OrderUpdateSellerShippingAddressModel? shippingAddress;
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

  OrderUpdateSellerOrderModel({
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

  factory OrderUpdateSellerOrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderUpdateSellerOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderUpdateSellerOrderModelToJson(this);
}

@JsonSerializable()
class OrderUpdateSellerUserModel {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? email;

  OrderUpdateSellerUserModel({this.id, this.name, this.email});

  factory OrderUpdateSellerUserModel.fromJson(Map<String, dynamic> json) =>
      _$OrderUpdateSellerUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderUpdateSellerUserModelToJson(this);
}

@JsonSerializable()
class OrderUpdateSellerItemModel {
  String? product;
  String? name;
  String? imageUrl;
  int? price;
  int? quantity;
  int? subtotal;
  @JsonKey(name: '_id')
  String? id;

  OrderUpdateSellerItemModel({
    this.product,
    this.name,
    this.imageUrl,
    this.price,
    this.quantity,
    this.subtotal,
    this.id,
  });

  factory OrderUpdateSellerItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderUpdateSellerItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderUpdateSellerItemModelToJson(this);
}

@JsonSerializable()
class OrderUpdateSellerShippingAddressModel {
  String? fullName;
  String? phone;
  String? address;
  String? city;
  String? governorate;
  String? postalCode;
  String? notes;

  OrderUpdateSellerShippingAddressModel({
    this.fullName,
    this.phone,
    this.address,
    this.city,
    this.governorate,
    this.postalCode,
    this.notes,
  });

  factory OrderUpdateSellerShippingAddressModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$OrderUpdateSellerShippingAddressModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrderUpdateSellerShippingAddressModelToJson(this);
}
