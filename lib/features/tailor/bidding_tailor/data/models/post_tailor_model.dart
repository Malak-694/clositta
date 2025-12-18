
import 'package:json_annotation/json_annotation.dart';

part 'post_tailor_model.g.dart';

@JsonSerializable()
class PostTailorResponse {
    @JsonKey(name: '_id')
  String? id;
  CustomerModel? customer;
  String? requestDescription;
  String? imageUrl;
  int? price;
  String? time;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PostTailorResponse({
    this.id,
    this.customer,
    this.requestDescription,
    this.imageUrl,
    this.price,
    this.time,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });
  factory PostTailorResponse.fromJson(Map<String, dynamic> json) =>
      _$PostTailorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PostTailorResponseToJson(this);
}
@JsonSerializable()

class CustomerModel {
    @JsonKey(name: '_id')

  String? id;
  String? name;
  String? email;
  String? phone;

  CustomerModel({this.id, this.name, this.email, this.phone});

  
  
  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);
}