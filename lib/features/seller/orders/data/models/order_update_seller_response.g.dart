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
  user: json['user'] == null
      ? null
      : OrderUpdateSellerUserModel.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
  items: (json['items'] as List<dynamic>?)
      ?.map(
        (e) => OrderUpdateSellerItemModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  shippingAddress: json['shippingAddress'] == null
      ? null
      : OrderUpdateSellerShippingAddressModel.fromJson(
          json['shippingAddress'] as Map<String, dynamic>,
        ),
  paymentMethod: json['paymentMethod'] as String?,
  paymentStatus: json['paymentStatus'] as String?,
  orderStatus: json['orderStatus'] as String?,
  itemsTotal: (json['itemsTotal'] as num?)?.toInt(),
  shippingFee: (json['shippingFee'] as num?)?.toInt(),
  totalAmount: (json['totalAmount'] as num?)?.toInt(),
  cancelReason: json['cancelReason'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  iV: (json['__v'] as num?)?.toInt(),
);

Map<String, dynamic> _$OrderUpdateSellerOrderModelToJson(
  OrderUpdateSellerOrderModel instance,
) => <String, dynamic>{
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
  'cancelReason': instance.cancelReason,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  '__v': instance.iV,
};

OrderUpdateSellerUserModel _$OrderUpdateSellerUserModelFromJson(
  Map<String, dynamic> json,
) => OrderUpdateSellerUserModel(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$OrderUpdateSellerUserModelToJson(
  OrderUpdateSellerUserModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
};

OrderUpdateSellerItemModel _$OrderUpdateSellerItemModelFromJson(
  Map<String, dynamic> json,
) => OrderUpdateSellerItemModel(
  product: json['product'] as String?,
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
  'product': instance.product,
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
