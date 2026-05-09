// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponseModel _$CartResponseModelFromJson(Map<String, dynamic> json) =>
    CartResponseModel(
      cId: json['_id'] as String?,
      user: json['user'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      subOrders: (json['subOrders'] as List<dynamic>?)
          ?.map((e) => CartSubOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CartResponseModelToJson(CartResponseModel instance) =>
    <String, dynamic>{
      '_id': instance.cId,
      'user': instance.user,
      'items': instance.items,
      'subOrders': instance.subOrders,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.iV,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  product: json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num?)?.toInt(),
  priceAtAddTime: (json['priceAtAddTime'] as num?)?.toInt(),
  subtotal: (json['subtotal'] as num?)?.toInt(),
  iId: json['_id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'product': instance.product,
  'quantity': instance.quantity,
  'priceAtAddTime': instance.priceAtAddTime,
  'subtotal': instance.subtotal,
  '_id': instance.iId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

CartSubOrder _$CartSubOrderFromJson(Map<String, dynamic> json) => CartSubOrder(
  sellerName: json['sellerName'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList(),
  subTotal: (json['subTotal'] as num?)?.toInt(),
);

Map<String, dynamic> _$CartSubOrderToJson(CartSubOrder instance) =>
    <String, dynamic>{
      'sellerName': instance.sellerName,
      'items': instance.items,
      'subTotal': instance.subTotal,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  pId: json['_id'] as String?,
  seller: json['seller'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toInt(),
  stock: (json['stock'] as num?)?.toInt(),
  category: json['category'] as String?,
  type: json['type'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  '_id': instance.pId,
  'seller': instance.seller,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'stock': instance.stock,
  'category': instance.category,
  'type': instance.type,
  'imageUrl': instance.imageUrl,
};
