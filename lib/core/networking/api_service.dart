import 'package:chicora/core/networking/api_endpoints.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;
  @POST(ApiEndpoints.signUp)
  Future<SignUpResponse> signUp(@Body() SignUpRequest body);

  @POST(ApiEndpoints.login)
  Future<LoginResponse> logIn(@Body() LoginRequest body);
}
