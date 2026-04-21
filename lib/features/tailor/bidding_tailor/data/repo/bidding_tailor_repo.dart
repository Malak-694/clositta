// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/bid_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/join_bidding_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/post_tailor_model.dart';
import 'package:dio/dio.dart';

class BiddingTailorRepo {
  ApiService apiService;
  BiddingTailorRepo({required this.apiService});

  Future<List<PostTailorResponse>> getBiddingTailors(String token) async {
    try {
      final response = await apiService.viewBiddingTailor("Bearer $token");
      return response;
    } catch (e) {
      // Handle error here if needed
      throw Exception("Failed to fetch bidding tailors: $e");
    }
  }

  // Get offers for a specific post
  Future<List<BidModelReponse>> getOffers(String token, String id) async {
    try {
      final response = await apiService.viewOffers("Bearer $token", id);
      return response;
    } catch (e) {
      throw Exception("Failed to fetch offers: $e");
    }
  }

  // Join bidding for a specific post
  Future<JoinBiddingResponse> joinBidding(
    String token,
    String id,
    JoinBiddingRequest request,
  ) async {
    try {
      final response = await apiService.joinBidding("Bearer $token", id, request);
      return response;
    } catch (e) {
      throw Exception("Failed to join bidding: $e");
    }
  }
  Future<void> deleteOffer({
    required String token,
    required String offerId,
  }) async {
    try {
      await apiService.deleteOffer("Bearer $token", offerId);
    } on DioException catch (e) {
      throw Exception(e.response != null
          ? "Server error: ${e.response?.statusCode} - ${e.response?.data}"
          : "Network error: ${e.message}");
    } catch (e) {
      throw Exception("Failed to delete offer: $e");
    }
  }
  Future<void> updateOffer({
    required String token,
    required String offerId,
    String? price,
    String? timeInDays,
    String? message,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (price != null) body['price'] = int.tryParse(price) ?? price;
      if (timeInDays != null) body['timeInDays'] = int.tryParse(timeInDays) ?? timeInDays;
      if (message != null) body['message'] = message;

      await apiService.updateOffer(
        token: "Bearer $token",
        offerId: offerId,
        body: body,
      );
    } on DioException catch (e) {
      throw Exception(e.response != null
          ? "Server error: ${e.response?.statusCode} - ${e.response?.data}"
          : "Network error: ${e.message}");
    } catch (e) {
      throw Exception("Failed to update offer: $e");
    }
  }
}
