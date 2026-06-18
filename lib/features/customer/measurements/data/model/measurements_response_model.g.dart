// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurements_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementsResponseModel _$MeasurementsResponseModelFromJson(
  Map<String, dynamic> json,
) => MeasurementsResponseModel(
  message: json['message'] as String?,
  measurements: json['measurements'] == null
      ? null
      : MeasurementsModel.fromJson(
          json['measurements'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MeasurementsResponseModelToJson(
  MeasurementsResponseModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'measurements': instance.measurements,
};
