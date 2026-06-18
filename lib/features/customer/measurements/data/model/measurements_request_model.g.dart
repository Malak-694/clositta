// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurements_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementsModel _$MeasurementsModelFromJson(Map<String, dynamic> json) =>
    MeasurementsModel(
      unit: json['unit'] as String?,
      chest: (json['chest'] as num?)?.toInt(),
      waist: (json['waist'] as num?)?.toInt(),
      hips: (json['hips'] as num?)?.toInt(),
      shoulders: (json['shoulders'] as num?)?.toInt(),
      armLength: (json['armLength'] as num?)?.toInt(),
      inseam: (json['inseam'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MeasurementsModelToJson(MeasurementsModel instance) =>
    <String, dynamic>{
      'unit': instance.unit,
      'chest': instance.chest,
      'waist': instance.waist,
      'hips': instance.hips,
      'shoulders': instance.shoulders,
      'armLength': instance.armLength,
      'inseam': instance.inseam,
      'height': instance.height,
    };
