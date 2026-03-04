import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginRequest {
  String? email;
  String? password;

  LoginRequest({this.email, this.password});
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String token;
  final String role;
  final String id;
  final String name;
  final String email;
  final String phone;
  String? imageUrl;
  LoginResponse({
    required this.token,
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
