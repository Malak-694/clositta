import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';

class AuthRepo {
  ApiService apiService;
  AuthRepo({required this.apiService});
   Future<ApiResult<SignUpResponse>> signUp(SignUpRequest body) async {
    try {
      final response = await apiService.signUp(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }

  }
  Future<ApiResult<LoginResponse>> logIn(LoginRequest body) async {
    try {
      final response = await apiService.logIn(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}