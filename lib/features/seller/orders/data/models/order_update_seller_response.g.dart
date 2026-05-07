// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_update_seller_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderUpdateSellerResponseModel _$OrderUpdateSellerResponseModelFromJson(
  Map<String, dynamic> json,
) => OrderUpdateSellerResponseModel(
  message: json['message'] as String?,
  order: json['order'] == null
      ? null
      : OrderUpdateSellerOrderModel.fromJson(
          json['order'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$OrderUpdateSellerResponseModelToJson(
  OrderUpdateSellerResponseModel instance,
) => <String, dynamic>{'message': instance.message, 'order': instance.order};

OrderUpdateSellerOrderModel _$OrderUpdateSellerOrderModelFromJson(
  Map<String, dynamic> json,
) => OrderUpdateSellerOrderModel(
  id: json['_id'] as String?,
  user: json['user'] as String?,
  subOrders: (json['subOrders'] as List<dynamic>?)
      ?.map(
        (e) =>
            OrderUpdateSellerSubOrderModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  shippingAddress: json['shippingAddress'] == null
      ? null
      : OrderUpdateSellerShippingAddressModel.fromJson(
          json['shippingAddress'] as Map<String, dynamic>,
        ),
  paymentMethod: json['paymentMethod'] as String?,
  paymentStatus: json['paymentStatus'] as String?,
  totalAmount: (json['totalAmount'] as num?)?.toInt(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  iV: (json['__v'] as num?)?.toInt(),
);

Map<String, dynamic> _$OrderUpdateSellerOrderModelToJson(
  OrderUpdateSellerOrderModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'user': instance.user,
  'subOrders': instance.subOrders,
  'shippingAddress': instance.shippingAddress,
  'paymentMethod': instance.paymentMethod,
  'paymentStatus': instance.paymentStatus,
  'totalAmount': instance.totalAmount,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  '__v': instance.iV,
};

OrderUpdateSellerSubOrderModel _$OrderUpdateSellerSubOrderModelFromJson(
  Map<String, dynamic> json,
) => OrderUpdateSellerSubOrderModel(
  seller: json['seller'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map(
        (e) => OrderUpdateSellerItemModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  itemsTotal: (json['itemsTotal'] as num?)?.toInt(),
  shippingFee: (json['shippingFee'] as num?)?.toInt(),
  subTotal: (json['subTotal'] as num?)?.toInt(),
  orderStatus: json['orderStatus'] as String?,
  id: json['_id'] as String?,
  cancelReason: json['cancelReason'] as String?,
);

Map<String, dynamic> _$OrderUpdateSellerSubOrderModelToJson(
  OrderUpdateSellerSubOrderModel instance,
) => <String, dynamic>{
  'seller': instance.seller,
  'items': instance.items,
  'itemsTotal': instance.itemsTotal,
  'shippingFee': instance.shippingFee,
  'subTotal': instance.subTotal,
  'orderStatus': instance.orderStatus,
  '_id': instance.id,
  'cancelReason': instance.cancelReason,
};

OrderUpdateSellerItemModel _$OrderUpdateSellerItemModelFromJson(
  Map<String, dynamic> json,
) => OrderUpdateSellerItemModel(
  product: _productIdFromJson(json['product']),
  name: json['name'] as String?,
  imageUrl: json['imageUrl'] as String?,
  price: (json['price'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  subtotal: (json['subtotal'] as num?)?.toInt(),
  id: json['_id'] as String?,
);

Map<String, dynamic> _$OrderUpdateSellerItemModelToJson(
  OrderUpdateSellerItemModel instance,
) => <String, dynamic>{
  'product': _productIdToJson(instance.product),
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'price': instance.price,
  'quantity': instance.quantity,
  'subtotal': instance.subtotal,
  '_id': instance.id,
};

OrderUpdateSellerShippingAddressModel
_$OrderUpdateSellerShippingAddressModelFromJson(Map<String, dynamic> json) =>
    OrderUpdateSellerShippingAddressModel(
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      governorate: json['governorate'] as String?,
      postalCode: json['postalCode'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$OrderUpdateSellerShippingAddressModelToJson(
  OrderUpdateSellerShippingAddressModel instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'phone': instance.phone,
  'address': instance.address,
  'city': instance.city,
  'governorate': instance.governorate,
  'postalCode': instance.postalCode,
  'notes': instance.notes,
};
