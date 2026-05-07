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
  String? user;
  List<OrderUpdateSellerSubOrderModel>? subOrders;
  OrderUpdateSellerShippingAddressModel? shippingAddress;
  String? paymentMethod;
  String? paymentStatus;
  int? totalAmount;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? iV;

  OrderUpdateSellerOrderModel({
    this.id,
    this.user,
    this.subOrders,
    this.shippingAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory OrderUpdateSellerOrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderUpdateSellerOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderUpdateSellerOrderModelToJson(this);
}

@JsonSerializable()
class OrderUpdateSellerSubOrderModel {
  String? seller;
  List<OrderUpdateSellerItemModel>? items;
  int? itemsTotal;
  int? shippingFee;
  int? subTotal;
  String? orderStatus;
  @JsonKey(name: '_id')
  String? id;
  String? cancelReason;

  OrderUpdateSellerSubOrderModel({
    this.seller,
    this.items,
    this.itemsTotal,
    this.shippingFee,
    this.subTotal,
    this.orderStatus,
    this.id,
    this.cancelReason,
  });

  factory OrderUpdateSellerSubOrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderUpdateSellerSubOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderUpdateSellerSubOrderModelToJson(this);
}

@JsonSerializable()
class OrderUpdateSellerItemModel {
  @JsonKey(fromJson: _productIdFromJson, toJson: _productIdToJson)
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

String? _productIdFromJson(dynamic value) {
  if (value is String) return value;
  if (value is Map<String, dynamic>) return value['_id'] as String?;
  return null;
}

dynamic _productIdToJson(String? value) => value;

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
