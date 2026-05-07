import 'package:json_annotation/json_annotation.dart';

part 'order_response_model.g.dart';

@JsonSerializable()
class OrderResponseModel {
  String? message;
  OrderDataModel? order;

  OrderResponseModel({this.message, this.order});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseModelToJson(this);
}

@JsonSerializable()
class OrderDataModel {
  @JsonKey(name: '_id')
  String? id;
  String? user;
  List<SubOrderModel>? subOrders;
  ShippingAddressModel? shippingAddress;
  String? paymentMethod;
  String? paymentStatus;
  int? totalAmount;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? iV;

  OrderDataModel({
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

  factory OrderDataModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataModelToJson(this);
}

@JsonSerializable()
class SubOrderModel {
  SellerModel? seller;
  List<OrderItemModel>? items;
  int? itemsTotal;
  int? shippingFee;
  int? subTotal;
  String? orderStatus;
  @JsonKey(name: '_id')
  String? id;

  SubOrderModel({
    this.seller,
    this.items,
    this.itemsTotal,
    this.shippingFee,
    this.subTotal,
    this.orderStatus,
    this.id,
  });

  factory SubOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SubOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubOrderModelToJson(this);
}

@JsonSerializable()
class SellerModel {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? email;

  SellerModel({this.id, this.name, this.email});

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerModelToJson(this);
}

@JsonSerializable()
class OrderItemModel {
  OrderItemProductModel? product;
  String? name;
  String? imageUrl;
  int? price;
  int? quantity;
  int? subtotal;
  @JsonKey(name: '_id')
  String? id;

  OrderItemModel({
    this.product,
    this.name,
    this.imageUrl,
    this.price,
    this.quantity,
    this.subtotal,
    this.id,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}

@JsonSerializable()
class OrderItemProductModel {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  int? price;
  String? imageUrl;

  OrderItemProductModel({this.id, this.name, this.price, this.imageUrl});

  factory OrderItemProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemProductModelToJson(this);
}

@JsonSerializable()
class ShippingAddressModel {
  String? fullName;
  String? phone;
  String? address;
  String? city;
  String? governorate;
  String? postalCode;
  String? notes;
  @JsonKey(name: '_id')
  String? id;

  ShippingAddressModel({
    this.fullName,
    this.phone,
    this.address,
    this.city,
    this.governorate,
    this.postalCode,
    this.notes,
    this.id,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressModelToJson(this);
}
