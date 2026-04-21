// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponseModel _$OrderResponseModelFromJson(Map<String, dynamic> json) =>
    OrderResponseModel(
      message: json['message'] as String?,
      order: json['order'] == null
          ? null
          : OrderDataModel.fromJson(json['order'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderResponseModelToJson(OrderResponseModel instance) =>
    <String, dynamic>{'message': instance.message, 'order': instance.order};

OrderDataModel _$OrderDataModelFromJson(Map<String, dynamic> json) =>
    OrderDataModel(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: json['shippingAddress'] == null
          ? null
          : ShippingAddressModel.fromJson(
              json['shippingAddress'] as Map<String, dynamic>,
            ),
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      orderStatus: json['orderStatus'] as String?,
      itemsTotal: (json['itemsTotal'] as num?)?.toInt(),
      shippingFee: (json['shippingFee'] as num?)?.toInt(),
      totalAmount: (json['totalAmount'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderDataModelToJson(OrderDataModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'items': instance.items,
      'shippingAddress': instance.shippingAddress,
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
      'orderStatus': instance.orderStatus,
      'itemsTotal': instance.itemsTotal,
      'shippingFee': instance.shippingFee,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.iV,
    };

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      product: json['product'] == null
          ? null
          : OrderItemProductModel.fromJson(
              json['product'] as Map<String, dynamic>,
            ),
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      subtotal: (json['subtotal'] as num?)?.toInt(),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
      '_id': instance.id,
    };

OrderItemProductModel _$OrderItemProductModelFromJson(
  Map<String, dynamic> json,
) => OrderItemProductModel(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  price: (json['price'] as num?)?.toInt(),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$OrderItemProductModelToJson(
  OrderItemProductModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'imageUrl': instance.imageUrl,
};

ShippingAddressModel _$ShippingAddressModelFromJson(
  Map<String, dynamic> json,
) => ShippingAddressModel(
  fullName: json['fullName'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  governorate: json['governorate'] as String?,
  postalCode: json['postalCode'] as String?,
  notes: json['notes'] as String?,
  id: json['_id'] as String?,
);

Map<String, dynamic> _$ShippingAddressModelToJson(
  ShippingAddressModel instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'phone': instance.phone,
  'address': instance.address,
  'city': instance.city,
  'governorate': instance.governorate,
  'postalCode': instance.postalCode,
  'notes': instance.notes,
  '_id': instance.id,
};
