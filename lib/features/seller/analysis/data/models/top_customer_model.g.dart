// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopCustomerModel _$TopCustomerModelFromJson(Map<String, dynamic> json) =>
    TopCustomerModel(
      totalSpent: (json['totalSpent'] as num).toInt(),
      totalOrders: (json['totalOrders'] as num).toInt(),
      customerId: json['customerId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$TopCustomerModelToJson(TopCustomerModel instance) =>
    <String, dynamic>{
      'totalSpent': instance.totalSpent,
      'totalOrders': instance.totalOrders,
      'customerId': instance.customerId,
      'name': instance.name,
      'email': instance.email,
    };
