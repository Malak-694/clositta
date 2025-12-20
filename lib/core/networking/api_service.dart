import 'package:chicora/core/networking/api_endpoints.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/bid_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/join_bidding_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/post_tailor_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../features/customer/biding/data/models/bid_customer_model.dart';
import '../../features/customer/biding/data/models/offer_model.dart';
import '../../features/customer/biding/data/models/send_bidding_model.dart';
import 'package:retrofit/http.dart'; //

part 'api_service.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;
  @POST(ApiEndpoints.signUp)
  Future<SignUpResponse> signUp(@Body() SignUpRequest body);

  @POST(ApiEndpoints.login)
  Future<LoginResponse> logIn(@Body() LoginRequest body);
  @GET(ApiEndpoints.viewBiddingTailor)
  Future<List<PostTailorResponse>> viewBiddingTailor(@Header("Authorization") String token,);
  @GET(ApiEndpoints.offers)
  Future<List<BidModelReponse>> viewOffers(@Header("Authorization") String token, @Path("id") String id);
  @POST(ApiEndpoints.offers)
  Future<JoinBiddingResponse> joinBidding(@Header("Authorization") String token,@Path("id") String id,@Body() JoinBiddingRequest body);
  @GET(ApiEndpoints.myBids)
  Future<List<BidResponse>> getMyBids(@Header("Authorization") String token);
  @POST(ApiEndpoints.createBid)
  @MultiPart()
  Future<BidResponse> createBidMultipart({
    @Header("Authorization") required String token,
    @Part(name : "requestDescription") required String description,
    @Part(name: "price") String? price,
    @Part(name: "time") String? time,
    @Part(name: "image") required MultipartFile image,
  });
  @GET(ApiEndpoints.bestOffers)
  Future<List<OfferResponse>> getBestOffers(@Header("Authorization") String token, @Path("bidId") String bidId,);

}
