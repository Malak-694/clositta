import 'package:json_annotation/json_annotation.dart';

part 'cart_response_model.g.dart';

@JsonSerializable()
class CartResponseModel {
  @JsonKey(name: '_id')
  String? cId;
  String? user;
  List<Item>? items;
  List<CartSubOrder>? subOrders;
  int? totalAmount;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? iV;

  CartResponseModel({
    this.cId,
    this.user,
    this.items,
    this.subOrders,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CartResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseModelToJson(this);
}

@JsonSerializable()
class Item {
  Product? product;
  int? quantity;
  int? priceAtAddTime;
  int? subtotal;
  @JsonKey(name: '_id')
  String? iId;
  String? createdAt;
  String? updatedAt;

  Item({
    this.product,
    this.quantity,
    this.priceAtAddTime,
    this.subtotal,
    this.iId,
    this.createdAt,
    this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class CartSubOrder {
  String? sellerName;
  List<Item>? items;
  int? subTotal;

  CartSubOrder({this.sellerName, this.items, this.subTotal});

  factory CartSubOrder.fromJson(Map<String, dynamic> json) =>
      _$CartSubOrderFromJson(json);

  Map<String, dynamic> toJson() => _$CartSubOrderToJson(this);
}

@JsonSerializable()
class Product {
  @JsonKey(name: '_id')
  String? pId;
  String? seller;
  String? name;
  String? description;
  int? price;
  int? stock;
  String? category;
  String? type;
  String? imageUrl;

  Product({
    this.pId,
    this.seller,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.category,
    this.type,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
