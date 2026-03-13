import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_endpoints.dart';
import 'package:chicora/features/auth/data/model/login_model.dart';
import 'package:chicora/features/auth/data/model/sign_up_model.dart';
import 'package:chicora/features/customer/closet/data/models/closet_item_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/cart_models/delete_cart_response_model.dart';
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

import '../../features/ecommerce_multi/data/models/cart_models/cart_request_model.dart';
import '../../features/ecommerce_multi/data/models/cart_models/cart_response_model.dart';
import '../../features/ecommerce_multi/data/models/rating models/rating_response_model.dart';
import '../../features/profile/data/model/profile_model.dart';
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

  @GET(ApiEndpoints.profile)
  Future<ProfileResponse> getProfile(
      @Header("Authorization") String token,
      );

  @MultiPart()
  @PUT(ApiEndpoints.profile)
  Future<MessageModel> updateProfile({
    @Header("Authorization") required String token,
    @Part() String? name,
    @Part() String? email,
    @Part() String? phone,
    @Part() MultipartFile? image,
  });

  @DELETE(ApiEndpoints.delete_profile_image)
  Future<MessageModel> deleteProfileImage(
      @Header("Authorization") String token,
      );

  @GET(ApiEndpoints.offers)
  Future<List<BidModelReponse>> viewOffers(
    @Header("Authorization") String token,
    @Path("id") String id,
  );

  @GET(ApiEndpoints.offers)
  Future<List<OfferResponse>> viewOffersCustomer(
      @Header("Authorization") String token,
      @Path("id") String id,
      );

  @POST(ApiEndpoints.offers)
  Future<JoinBiddingResponse> joinBidding(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() JoinBiddingRequest body,
  );
  //customer-bids
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
  @PUT(ApiEndpoints.updateBid)
  @MultiPart()
  Future<BidResponse> updateBid(
      @Header("Authorization") String token,
      @Path("bidId") String bidId,
      @Part(name: "requestDescription") String description,
      @Part(name: "image") MultipartFile? image,
      @Part(name: "price") String? price,
      @Part(name: "time") String? time,
      );

  @DELETE(ApiEndpoints.updateBid)
  Future<void> deleteBid(
      @Header("Authorization") String token,
      @Path("bidId") String bidId,
      );

  @GET(ApiEndpoints.bestOffers)
  Future<List<OfferResponse>> getBestOffers(
    @Header("Authorization") String token,
    @Path("bidId") String bidId,
  );
  @PATCH(ApiEndpoints.acceptOffer)
  Future<void> acceptOffer(
      @Header("Authorization") String token,
      @Path("offerId") String offerId,
      );

  @DELETE(ApiEndpoints.editeOffer)
  Future<void> deleteOffer(
      @Header("Authorization") String token,
      @Path("offerId") String offerId,
      );

  @PUT(ApiEndpoints.editeOffer)
  Future<void> updateOffer({
    @Header("Authorization") required String token,
    @Path("offerId") required String offerId,
    @Body() required Map<String, dynamic> body,
  });
  //seller-products
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

  //ecommerce-cart
  @GET(ApiEndpoints.cart)
  Future<CartResponseModel> getCart(@Header("Authorization") String token);
  @POST(ApiEndpoints.cart)
  Future<CartResponseModel> addToCart(
    @Header("Authorization") String token,
    @Body() CartRequestModel body,
  );
  @PUT(ApiEndpoints.updateCartItems)
  Future<CartResponseModel> updateCart(
    @Header("Authorization") String token,
    @Path("productId") String productId,
    @Body() CartRequestModel body,
  );
  @DELETE(ApiEndpoints.updateCartItems)
  Future<DeleteCartResponseModel> removeFromCart(
    @Header("Authorization") String token,
    @Path("productId") String productId,
  );

  @DELETE(ApiEndpoints.cart)
  Future<MessageModel> removeAllCart(@Header("Authorization") String token);
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
