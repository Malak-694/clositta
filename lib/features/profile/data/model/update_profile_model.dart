import 'package:json_annotation/json_annotation.dart';

part 'update_profile_model.g.dart';


@JsonSerializable()
class UpdateProfileResponse {
  final String message;
  final UpdatedUser user;

  UpdateProfileResponse({
    required this.message,
    required this.user,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileResponseToJson(this);
}

@JsonSerializable()
class UpdatedUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? imageUrl;

  UpdatedUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.imageUrl,
  });

  factory UpdatedUser.fromJson(Map<String, dynamic> json) =>
      _$UpdatedUserFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatedUserToJson(this);
}