// lib/features/customer/bidding_customer/data/repo/bidding_customer_repo.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:chicora/core/networking/api_service.dart';
import '../models/bid_customer_model.dart';
import '../models/offer_model.dart';
import 'package:http_parser/http_parser.dart';

class BiddingCustomerRepo {
  final ApiService apiService;

  BiddingCustomerRepo({required this.apiService});

  // ✅ GET /api/bids → getMyBids
  Future<List<BidResponse>> getMyBids(String token) async {
    try {
      final response = await apiService.getMyBids("Bearer $token");
      return response;
    } catch (e) {
      throw Exception("Failed to fetch my bids: $e");
    }
  }

  // ✅ POST /api/bids → createBid (multipart)
  // Future<BidResponse> createBid({
  //   required String token,
  //   required String description,
  //   required String imageUrl,
  //   double? price,
  //   String? time,
  // }) async {
  //   try {
  //     return await apiService.createBid(
  //       'Bearer $token',
  //        SendBiddingModel(
  //         description: description,
  //         price: price,
  //         time: time,
  //         imageUrl: imageUrl,
  //       ),
  //     );
  //   } catch (e) {
  //     throw Exception("Failed to create bid: $e");
  //   }
  // }



  // ✅ GET /api/offers/:bidId/best → getBestOffers
  Future<List<OfferResponse>> getBestOffers(String token, String bidId) async {
    try {
      final response = await apiService.getBestOffers("Bearer $token", bidId);
      return response;
    } catch (e) {
      throw Exception("Failed to fetch best offers: $e");
    }
  }


  // In your repository:
  Future<BidResponse> createBidWithFile({
    required String token,
    required String description,
    required String imagePath,
    double? price,
    String? time,
  }) async {
    try {
      // ✅ Convert file path to MultipartFile
      final file = File(imagePath);

      // ✅ Check if file exists
      if (!await file.exists()) {
        throw Exception("Image file not found");
      }

      // ✅ Create multipart file with proper filename and content type
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: 'bid_${DateTime.now().millisecondsSinceEpoch}.jpg',
        // Optional: specify content type based on file extension
        contentType: MediaType('image', 'jpeg'),
      );

      // ✅ Call API with Bearer token
      final response = await apiService.createBidMultipart(
        token:  "Bearer $token",
        description: description,
        price: price?.toString(),
        time: time,
        image: multipartFile,
      );
      print('✅ Bid created successfully');
      return response;
    } on DioException catch (e) {
      print('   Headers sent: ${e.requestOptions.headers}');
      // Handle Dio-specific errors
      if (e.response != null) {
        throw Exception(
            "Server error: ${e.response?.statusCode} - ${e.response?.data}"
        );
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Failed to create bid: $e");
    }
  }
}
