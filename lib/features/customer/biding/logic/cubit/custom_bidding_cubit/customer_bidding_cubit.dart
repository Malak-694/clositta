// lib/features/customer/bidding_customer/cubit/bidding_customer_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/data/models/offer_model.dart';
import 'package:chicora/features/customer/biding/data/models/send_bidding_model.dart';
import 'package:chicora/features/customer/biding/data/repo/bid_repo.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_state.dart';

class CustomerBiddingCubit extends Cubit<CustomerBiddingState> {
  final BiddingCustomerRepo _repository;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  CustomerBiddingCubit(this._repository) : super(const CustomerBiddingState.initial());

  bool _loadedBids = false;
  bool _loadedBestOffers = false;
  bool _loadedOffers =false ;
  final Map<String, OfferResponse> _acceptedOffers = {};
  Map<String, OfferResponse?> get acceptedOffers => _acceptedOffers;

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


  Future<void> getOffers(String postId) async {
    if (_loadedOffers) return;
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }
      print(token);
      final List<OfferResponse> response =
      await _repository.getOffers(token, postId);
      emit(CustomerBiddingState.success(response));
      _loadedOffers = true;
    } catch (e) {
      emit(CustomerBiddingState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to load offers. Please try again.",
      ));
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
  Future<void> acceptOffer(String offerId, String bidId) async {
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      await _repository.acceptOffer(token, offerId);

      // emit success message first (listener catches this)
      emit(const CustomerBiddingState.success("Offer accepted successfully"));

      // then reload offers
      _loadedBestOffers = false;
      await getBestOffers(bidId);
    } catch (e) {
      emit(
        CustomerBiddingState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to accept offer. Please try again.",
        ),
      );
    }
  }

  Future<void> refreshBestOffers(String bidId) async {
    _loadedBestOffers = false;
    await getBestOffers(bidId);
  }

  Future<void> refreshOffers(String postId) async {
    _loadedOffers = false;
    await getOffers(postId);
  }

  // update bid
  Future<void> updateBid({
    required String bidId,
    required String description,
    String? imagePath,
    double? price,
    String? time,
  }) async {
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      final BidResponse response = await _repository.updateBid(
        token: token,
        bidId: bidId,
        description: description,
        imagePath: imagePath,
        price: price,
        time: time,
      );

      _loadedBids = false; // force refresh on next load
      emit(CustomerBiddingState.success(response));
    } catch (e) {
      emit(
        CustomerBiddingState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to update bid. Please try again.",
        ),
      );
    }
  }

  // delete
  Future<void> deleteBid({required String bidId}) async {
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      await _repository.deleteBid(token: token, bidId: bidId);

      _loadedBids = false; // force refresh
      emit(const CustomerBiddingState.success("Bid deleted successfully"));
    } catch (e) {
      emit(
        CustomerBiddingState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to delete bid. Please try again.",
        ),
      );
    }
  }

  Future<void> loadAcceptedOffers(List<BidResponse> closedBids) async {
    final token = await _getToken();
    if (token == null || token.isEmpty) return;

    for (final bid in closedBids) {
      if (bid.id == null) continue;
      if (_acceptedOffers.containsKey(bid.id)) continue;

      try {
        final offers = await _repository.getOffers(token, bid.id!);
        final accepted = offers.where(
              (o) => o.status?.toLowerCase() == 'accepted',
        ).firstOrNull ?? (offers.isNotEmpty ? offers.first : null);

        if (accepted != null) {
          _acceptedOffers[bid.id!] = accepted;
        }
      } catch (_) {}
    }

    emit(CustomerBiddingState.success(
      state.maybeWhen(success: (d) => d, orElse: () => <BidResponse>[]),
    ));
  }
}