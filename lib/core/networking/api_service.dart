import 'package:chicora/core/networking/api_endpoints.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/join_bidding_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../features/tailor/bidding_tailor/ui/widgets/post_item_tailor.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;
  @POST(ApiEndpoints.signUp)
  Future<SignUpResponse> signUp(@Body() SignUpRequest body);

  @POST(ApiEndpoints.login)
  Future<LoginResponse> logIn(@Body() LoginRequest body);
  @GET(ApiEndpoints.viewBiddingTailor)
  Future<List<PostItemTailor>> viewBiddingTailor(@Header("Authorization") String token,);
  @GET(ApiEndpoints.offers)
  Future<List<PostItemTailor>> viewOffers(@Header("Authorization") String token, @Path("id") String id);
  @POST(ApiEndpoints.offers)
  Future<JoinBiddingResponse> joinBidding(@Header("Authorization") String token,@Path("id") String id,@Body() JoinBiddingRequest body);

}
