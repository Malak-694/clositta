import 'package:json_annotation/json_annotation.dart';

part 'google_auth_model.g.dart';

@JsonSerializable()
class GoogleAuthRequestModel {
  final String idToken;
  final String? role;

  GoogleAuthRequestModel({
    required this.idToken,
    required this.role,
  });

 factory GoogleAuthRequestModel.fromJson(Map<String, dynamic> json) =>
    _$GoogleAuthRequestModelFromJson(json);

Map<String, dynamic> toJson() =>
    _$GoogleAuthRequestModelToJson(this);

}
@JsonSerializable()

class GoogleAuthResponseModel {
  final String token;
  final String id;
  final String name;
  final String email;
  final String role;
  final String? imageUrl;

  GoogleAuthResponseModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.imageUrl,
  });
  factory GoogleAuthResponseModel.fromJson(Map<String, dynamic> json) => _$GoogleAuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleAuthResponseModelToJson(this);

}