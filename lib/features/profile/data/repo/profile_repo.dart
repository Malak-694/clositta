import 'dart:io';
import 'package:dio/dio.dart';
import 'package:chicora/core/networking/api_service.dart';

import '../../../../core/models/message_model.dart';
import '../model/profile_model.dart';


class ProfileRepo {
  final ApiService apiService;

  ProfileRepo({required this.apiService});

  // GET /api/auth/profile
  Future<ProfileResponse> getProfile(String token) async {
    try {
      return await apiService.getProfile("Bearer $token");
    } catch (e) {
      throw Exception("Failed to fetch profile: $e");
    }
  }

  Future<MessageModel> updateProfile({
    required String token,
    String? name,
    String? email,
    String? phone,
    String? imagePath,
  }) async {
    try {
      MultipartFile? image;
      if (imagePath != null) {
        final file = File(imagePath);
        if (!await file.exists()) throw Exception("Image file not found");
        image = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
      }
      return await apiService.updateProfile(
        token: "Bearer $token",
        name: name,
        email: email,
        phone: phone,
        image: image,
      );
    } on DioException catch (e) {
      throw Exception("Server error: ${e.response?.statusCode} - ${e.response?.data}");
    } catch (e) {
      throw Exception("Failed to update profile: $e");
    }
  }

  Future<MessageModel> deleteProfileImage(String token) async {
    try {
      return await apiService.deleteProfileImage("Bearer $token");
    } catch (e) {
      throw Exception("Failed to delete profile image: $e");
    }
  }
}