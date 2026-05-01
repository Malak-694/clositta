// forgot_password_model.dart
import 'package:json_annotation/json_annotation.dart';
part 'forgot_password_model.g.dart';

@JsonSerializable()
class ForgotPasswordRequest {
  final String email;
  ForgotPasswordRequest({required this.email});
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class VerifyCodeRequest {
  final String email;
  final String code;
  VerifyCodeRequest({required this.email, required this.code});
  factory VerifyCodeRequest.fromJson(Map<String, dynamic> json) => _$VerifyCodeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String newPassword;
  ResetPasswordRequest({required this.email, required this.newPassword});
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}