import 'package:json_annotation/json_annotation.dart';

part 'seller_response_model.g.dart';
@JsonSerializable()
class SellerModel {
  @JsonKey(name: '_id')
  String? sId;
  String? name;
  String? email;

  SellerModel({this.sId, this.name, this.email});

  factory SellerModel.fromJson(Map<String, dynamic> json) => _$SellerModelFromJson(json);
  Map<String, dynamic> toJson() => _$SellerModelToJson(this);
}
