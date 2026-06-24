// lib/features/customer/bidding_customer/data/repo/bidding_customer_repo.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:chicora/core/networking/api_service.dart';
import '../models/bid_customer_model.dart';
import '../models/offer_model.dart';
import '../models/rate_offer_request_model.dart';

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


  Future<List<OfferResponse>> getOffers(String token, String id) async {
    try {
      final response = await apiService.viewOffersCustomer("Bearer $token", id);
      return response;
    } catch (e) {
      throw Exception("Failed to fetch offers: $e");
    }
  }

  //  getBestOffers
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
      final file = File(imagePath);

      if (!await file.exists()) {
        throw Exception("Image file not found");
      }

      final fileName = file.path.split('/').last;

      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      );
      final response = await apiService.createBidMultipart(
        token:  "Bearer $token",
        description: description,
        price: price?.toString(),
        time: time,
        image: multipartFile,
      );
      return response;
    } on DioException catch (e) {
      print('   Headers sent: ${e.requestOptions.headers}');
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

  Future<void> acceptOffer(String token, String offerId) async {
    try {
      await apiService.acceptOffer("Bearer $token", offerId);
    } catch (e) {
      throw Exception("Failed to accept offer: $e");
    }
  }

  Future<void> rateOffer({
    required String token,
    required String offerId,
    required RateOfferRequestModel body,
  }) async {
    await apiService.rateOffer("Bearer $token", offerId, body);
  }
  Future<BidResponse> updateBid({
    required String token,
    required String bidId,
    required String description,
    String? imagePath,
    double? price,
    String? time,
  }) async {
    try {
      MultipartFile? multipartFile;

      if (imagePath != null) {
        final file = File(imagePath);
        if (!await file.exists()) throw Exception("Image file not found");
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
      }

      final response = await apiService.updateBid(
        "Bearer $token",
        bidId,
        description,
        multipartFile,
        price?.toString(),
        time,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception("Server error: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Failed to update bid: $e");
    }
  }

  //delete bid
  Future<void> deleteBid({
    required String token,
    required String bidId,
  }) async {
    try {
      await apiService.deleteBid("Bearer $token", bidId);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception("Server error: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Failed to delete bid: $e");
    }
  }
}
