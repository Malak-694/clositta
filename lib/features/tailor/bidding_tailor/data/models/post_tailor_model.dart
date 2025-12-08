
import 'package:chicora/features/tailor/bidding_tailor/data/models/cutomer_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_tailor_model.g.dart';

@JsonSerializable()
class PostTailor {
  String? sId;
  CustomerModel? customer;
  String? requestDescription;
  String? imageUrl;
  int? price;
  String? time;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PostTailor({
    this.sId,
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
  factory PostTailor.fromJson(Map<String, dynamic> json) =>
      _$PostTailorFromJson(json);
  Map<String, dynamic> toJson() => _$PostTailorToJson(this);
}
@JsonSerializable()

class CustomerModel {
  String? sId;
  String? name;
  String? email;
  String? phone;

  CustomerModel({this.sId, this.name, this.email, this.phone});

  
  
  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);
}