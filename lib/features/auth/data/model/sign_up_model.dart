import 'package:json_annotation/json_annotation.dart';
part 'sign_up_model.g.dart';
@JsonSerializable()
class SignUpRequest {
   String? name;
  String? email;
  String? password;
  String? confirmpassword;
  String? phone;
  String? role;

  SignUpRequest({
   this.name,
      this.email,
      this.password,
      this.confirmpassword,
      this.phone,
      this.role
  });
factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
  
}
@JsonSerializable()
class SignUpResponse {
  String? message;
 

  SignUpResponse({this.message});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}