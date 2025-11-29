
import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';
@JsonSerializable()
class LoginRequest {

  String? email;
  String? password;


  LoginRequest({
  
    this.email,
    this.password,
   
  });
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
@JsonSerializable()
class LoginResponse {

  final String token;
  LoginResponse({ required this.token});
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
