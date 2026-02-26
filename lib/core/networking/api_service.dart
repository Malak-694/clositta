import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_endpoints.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';
import 'package:chicora/features/customer/closet/data/models/closet_item_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/rating%20models/rating_request_model.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/bid_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/join_bidding_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/post_tailor_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../features/customer/biding/data/models/bid_customer_model.dart';
import '../../features/customer/biding/data/models/offer_model.dart';

import '../../features/ecommerce_multi/data/models/rating models/rating_response_model.dart';
import '../../features/tailor/portfolio/data/models/portfolio_tailor_response_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;
  @POST(ApiEndpoints.signUp)
  Future<SignUpResponse> signUp(@Body() SignUpRequest body);

  @POST(ApiEndpoints.login)
  Future<LoginResponse> logIn(@Body() LoginRequest body);
  @GET(ApiEndpoints.viewBiddingTailor)
  Future<List<PostTailorResponse>> viewBiddingTailor(
    @Header("Authorization") String token,
  );
  @GET(ApiEndpoints.offers)
  Future<List<BidModelReponse>> viewOffers(
    @Header("Authorization") String token,
    @Path("id") String id,
  );
  @POST(ApiEndpoints.offers)
  Future<JoinBiddingResponse> joinBidding(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() JoinBiddingRequest body,
  );
  @GET(ApiEndpoints.myBids)
  Future<List<BidResponse>> getMyBids(@Header("Authorization") String token);
  @POST(ApiEndpoints.createBid)
  @MultiPart()
  Future<BidResponse> createBidMultipart({
    @Header("Authorization") required String token,
    @Part(name: "requestDescription") required String description,
    @Part(name: "price") String? price,
    @Part(name: "time") String? time,
    @Part(name: "image") required MultipartFile image,
  });
  @GET(ApiEndpoints.bestOffers)
  Future<List<OfferResponse>> getBestOffers(
    @Header("Authorization") String token,
    @Path("bidId") String bidId,
  );
  @GET(ApiEndpoints.sellerProducts)
  Future<List<ProductModel>> getProductsSeller(
    @Header("Authorization") String token,
  );
  @DELETE(ApiEndpoints.product)
  Future<MessageModel> deleteProduct(
    @Header("Authorization") String token,
    @Path("productId") String productId,
  );

  @POST(ApiEndpoints.addProduct)
  @MultiPart()
  Future<MessageModel> addProduct(
      @Header("Authorization") String token,
      @Part(name: "name") String name,
      @Part(name: "description") String description,
      @Part(name: "price") String price,
      @Part(name: "stock") String stock,
      @Part(name: "category") String category,
      @Part(name: "type") String type,
      @Part(name: "image") MultipartFile image,
      );
  //ecommerce -buyer
  @GET(ApiEndpoints.products)
  Future<List<ProductModelBuyer>> getProductsBuyer({
    @Header("Authorization") required String token,
    @Query("category") String? category,
    @Query("minPrice") double? minPrice,
    @Query("maxPrice") double? maxPrice,
    @Query("inStock") bool? inStock,
    @Query("sellerId") String? sellerId,
    @Query("search") String? search,
    @Query("type") String? type,
  });
  //ecommerce -buyer -rate
  @POST(ApiEndpoints.ratePoduct)
  Future<RatingResponseModel> rateProduct(
    @Header("Authorization") String token,
    @Path("productId") String productId,
    @Body() RatingRequestModel body,
  );
  @DELETE(ApiEndpoints.ratePoduct)
  Future<MessageModel> deleteRateProduct(
    @Header("Authorization") String token,
    @Path("productId") String productId,
  );
  @PUT(ApiEndpoints.product)
  @MultiPart()
  Future<MessageModel> updateProduct(
      @Header("Authorization") String token,
      @Path("productId") String productId,
      @Part(name: "name") String name,
      @Part(name: "description") String description,
      @Part(name: "price") String price,
      @Part(name: "stock") String stock,
      @Part(name: "category") String category,
      @Part(name: "type") String type,
      @Part(name: "image") MultipartFile? image,
      );
  //closet operations
  @GET(ApiEndpoints.viewClosetItems)
  Future<List<ClosetItemResponseModel>> viewClosetItems(
    @Header("Authorization") String token,
    @Query("category") String? category,
    @Query("season") String? season,
  );
  @DELETE(ApiEndpoints.deleteClosetItem)
  Future<MessageModel> deleteClosetItem(
    @Header("Authorization") String token,
    @Path("itemId") String itemId,
  );

  @POST(ApiEndpoints.createClosetItems)
  @MultiPart()
  Future<MessageModel> addClosetItem(
      @Header("Authorization") String token,
      @Part(name: "name") String name,
      @Part(name: "category") String category,
      @Part(name: "season") String season,
      @Part(name: "color") String color,
      @Part(name: "image") MultipartFile image,
      );

  @PUT(ApiEndpoints.updateClosetItem)
  @MultiPart()
  Future<MessageModel> updateClosetItem(
      @Header("Authorization") String token,
      @Path("itemId") String itemId,
      @Part(name: "name") String name,
      @Part(name: "category") String category,
      @Part(name: "season") String season,
      @Part(name: "color") String color,
      @Part(name: "image") MultipartFile? image,
      );

  //tailor-portfolio
  @GET(ApiEndpoints.viewPortfolioTailor)
  Future<List<PortfolioTailorResponseModel>> viewPortfolioTailor(
    @Header("Authorization") String token,
    @Query("category") String? category,
  );
  @DELETE(ApiEndpoints.deletePortfolioTailor)
  Future<MessageModel> deletePortfolioTailor(
    @Header("Authorization") String token,
    @Path("itemId") String itemId,
  );

  @POST(ApiEndpoints.createPortfolioTailor)
  @MultiPart()
  Future<MessageModel> addPortfolioItem(
      @Header("Authorization") String token,
      @Part(name: "title") String title,
      @Part(name: "category") String category,
      @Part(name: "description") String description,
      @Part(name: "image") MultipartFile image,
      );

  @PUT(ApiEndpoints.updatePortfolioTailor)
  @MultiPart()
  Future<MessageModel> updatePortfolioItem(
      @Header("Authorization") String token,
      @Path("itemId") String itemId,
      @Part(name: "title") String title,
      @Part(name: "category") String category,
      @Part(name: "description") String description,
      @Part(name: "image") MultipartFile? image, // ✅ optional
      );
}
