// lib/features/customer/bidding_customer/cubit/bidding_customer_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/data/models/offer_model.dart';
import 'package:chicora/features/customer/biding/data/models/send_bidding_model.dart';
import 'package:chicora/features/customer/biding/data/repo/bid_repo.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_state.dart';

class CustomerBiddingCubit extends Cubit<CustomerBiddingState> {
  final BiddingCustomerRepo _repository;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  CustomerBiddingCubit(this._repository) : super(const CustomerBiddingState.initial());

  bool _loadedBids = false;
  bool _loadedBestOffers = false;

  // Get token from shared preferences
  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  // Get my bids
  Future<void> getMyBids() async {
    if (_loadedBids) return;
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      final List<BidResponse> response = await _repository.getMyBids(token);
      emit(CustomerBiddingState.success(response));
      _loadedBids = true;
    } catch (e) {
      emit(
        CustomerBiddingState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to load my bids. Please try again.",
        ),
      );
    }
  }

  // Get best offers for a specific bid
  Future<void> getBestOffers(String bidId) async {
    if (_loadedBestOffers) return;
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      final List<OfferResponse> response = await _repository.getBestOffers(
        token,
        bidId,
      );
      emit(CustomerBiddingState.success(response));
      _loadedBestOffers = true;
    } catch (e) {
      emit(
        CustomerBiddingState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to load best offers. Please try again.",
        ),
      );
    }
  }

  // lib/features/customer/biding/logic/cubit/customer_bidding_cubit.dart

// Update the createBid method:
  Future<void> createBid({
    required SendBiddingModel request,
  }) async {
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      // ✅ Validate image path exists
      if (request.imageUrl.isEmpty) {
        emit(const CustomerBiddingState.fail("Please select an image"));
        return;
      }

      // ✅ Call repository with file path
      final BidResponse response = await _repository.createBidWithFile(
        token: token,
        description: request.description,
        imagePath: request.imageUrl, // File path from ImagePicker
        price: request.price,
        time: request.time,
      );

      emit(CustomerBiddingState.success(response));
    } catch (e) {
      emit(
        CustomerBiddingState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to create bid. Please try again.",
        ),
      );
    }
  }
  // Refresh my bids
  Future<void> refreshMyBids() async {
    await getMyBids();
  }

  // Clear state
  void clearState() {
    _loadedBids = false;
    _loadedBestOffers = false;
    emit(const CustomerBiddingState.initial());
  }
}