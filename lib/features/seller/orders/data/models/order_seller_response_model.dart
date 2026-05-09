import 'package:json_annotation/json_annotation.dart';

part 'order_seller_response_model.g.dart';

@JsonSerializable()
class OrderSellerResponseModel {
  @JsonKey(name: '_id')
  String? id;
  String? orderId;
  UserSummarySellerViewModel? user;
  UserSummarySellerViewModel? customer;
  SellerSubOrderModel? subOrder;
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
    this.orderId,
    this.user,
    this.customer,
    this.subOrder,
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

  String? get resolvedOrderId => orderId ?? id;
  String? get resolvedSubOrderId => subOrder?.id;
  UserSummarySellerViewModel? get resolvedCustomer => customer ?? user;
  String? get resolvedOrderStatus => subOrder?.orderStatus ?? orderStatus;
  int? get resolvedTotalAmount => subOrder?.subTotal ?? totalAmount;
  List<OrderItemWithPopulatedProductModel>? get resolvedItems =>
      subOrder?.items ?? items;

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
class SellerSubOrderModel {
  String? seller;
  List<OrderItemWithPopulatedProductModel>? items;
  int? itemsTotal;
  int? shippingFee;
  int? subTotal;
  String? orderStatus;
  @JsonKey(name: '_id')
  String? id;
  String? cancelReason;

  SellerSubOrderModel({
    this.seller,
    this.items,
    this.itemsTotal,
    this.shippingFee,
    this.subTotal,
    this.orderStatus,
    this.id,
    this.cancelReason,
  });

  factory SellerSubOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SellerSubOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerSubOrderModelToJson(this);
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
