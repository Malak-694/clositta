import 'package:json_annotation/json_annotation.dart';

part 'measurements_request_model.g.dart';

@JsonSerializable()
class MeasurementsModel {
  String? unit;
  int? chest;
  int? waist;
  int? hips;
  int? shoulders;
  int? armLength;
  int? inseam;
  int? height;

  MeasurementsModel({
    this.unit,
    this.chest,
    this.waist,
    this.hips,
    this.shoulders,
    this.armLength,
    this.inseam,
    this.height,
  });
   bool get hasMeasurements =>
      chest != null ||
      waist != null ||
      hips != null ||
      shoulders != null ||
      armLength != null ||
      inseam != null ||
      height != null;

  factory MeasurementsModel.fromJson(Map<String, dynamic> json) =>
      _$MeasurementsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementsModelToJson(this);
}
