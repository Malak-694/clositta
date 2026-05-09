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
  String? location;
  String? mapsUrl;

  SignUpRequest({
    this.name,
    this.email,
    this.password,
    this.confirmpassword,
    this.phone,
    this.role,
    this.location,
    this.mapsUrl,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}

@JsonSerializable()
class SignUpReturnedUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? imageUrl;
  final String? location;
  final String? mapsUrl;

  SignUpReturnedUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.imageUrl,
    this.location,
    this.mapsUrl,
  });

  factory SignUpReturnedUser.fromJson(Map<String, dynamic> json) =>
      _$SignUpReturnedUserFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpReturnedUserToJson(this);
}

@JsonSerializable()
class SignUpResponse {
  String? message;
  SignUpReturnedUser? user;

  SignUpResponse({this.message, this.user});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}
