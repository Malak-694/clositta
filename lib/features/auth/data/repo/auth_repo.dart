import 'package:chicora/core/models/message_model.dart';
import 'dart:io';

import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/auth/data/model/forgot_password_model.dart';
import 'package:chicora/features/auth/data/model/google_auth_model.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';
import 'package:dio/dio.dart';

class AuthRepo {
  ApiService apiService;
  AuthRepo({required this.apiService});

  String? _nonEmptyTrimmed(String? s) {
    final t = s?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }

  Future<ApiResult<SignUpResponse>> signUp(
    SignUpRequest body, {
    String? imagePath,
  }) async {
    try {
      MultipartFile? imageFile;
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          imageFile = await MultipartFile.fromFile(
            file.path,
            filename: file.path.split(RegExp(r'[/\\]')).last,
          );
        }
      }

      final role = body.role ?? 'customer';

      final response = await apiService.signUp(
        name: body.name!,
        email: body.email!,
        password: body.password!,
        confirmpassword: body.confirmpassword!,
        phone: _nonEmptyTrimmed(body.phone),
        role: role,
        location: role == 'tailor' ? _nonEmptyTrimmed(body.location) : null,
        mapsUrl: role == 'tailor' ? _nonEmptyTrimmed(body.mapsUrl) : null,
        image: imageFile,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

  Future<ApiResult<LoginResponse>> logIn(LoginRequest body) async {
    try {
      final response = await apiService.logIn(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

  // In auth_repo.dart

  Future<ApiResult<GoogleAuthResponseModel>> googleAuth(GoogleAuthRequestModel body) async {
    try {
      final response = await apiService.googleAuth(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

  Future<ApiResult<MessageModel>> forgotPassword(
    ForgotPasswordRequest body,
  ) async {
    try {
      final response = await apiService.forgotPassword(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<MessageModel>> verifyResetCode(
    VerifyCodeRequest body,
  ) async {
    try {
      final response = await apiService.verfiyResetCode(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<MessageModel>> resetPassword(
    ResetPasswordRequest body,
  ) async {
    try {
      final response = await apiService.resetPassword(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
