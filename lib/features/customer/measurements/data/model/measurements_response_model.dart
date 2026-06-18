import 'package:json_annotation/json_annotation.dart';

import 'measurements_request_model.dart';

part 'measurements_response_model.g.dart';

@JsonSerializable()
class MeasurementsResponseModel {
  String? message;
  MeasurementsModel? measurements;

  MeasurementsResponseModel({this.message, this.measurements});
factory MeasurementsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MeasurementsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementsResponseModelToJson(this);

}
